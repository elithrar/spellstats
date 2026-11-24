local _, ns = ...
local values = ns.SomethingNeedDoing.Values
local MANA = Enum.PowerType.Mana

function ns.MaxMana()
    local maximum = UnitPowerMax("player", MANA)
    if values.Number(maximum) and maximum > 0 then return maximum end
end

-- .cost is the current charge. .costPercent uses *base* mana and cannot
-- be substituted for the percentage of the player's actual mana pool.
local function manaCost(spellID, rank)
    if rank and rank.allMana then
        local current = UnitPower("player", MANA)
        if values.Number(current) and current >= 0 then return current end
        return
    end
    local costs = C_Spell.GetSpellPowerCost(spellID)
    if not values.Readable(costs) or type(costs) ~= "table" then return end
    local total
    for _, row in ipairs(costs) do
        if not values.Readable(row) or not values.Number(row.type) then return end
        if row.type == MANA then
            if not values.Readable(row.requiredAuraID) or not values.Readable(row.hasRequiredAura) then return end
            if (row.requiredAuraID or 0) == 0 or row.hasRequiredAura then
                if not values.Number(row.cost) or row.cost < 0 or not values.Readable(row.costPerSec) then return end
                -- A per-second charge needs a channel duration and base mana.
                -- A partial cost would also overstate the spell's efficiency.
                if (row.costPerSec or 0) ~= 0 then return end
                total = (total or 0) + row.cost
            end
        end
    end
    return total
end

-- Community measurements on Forever ranks (DoubleZug, November 2026).
-- Only the spell-power term is reduced. First-rank Holy Light and Healing
-- Touch measured as if learned at level zero. Base growth uses client levels.
local function spellPowerShare(spellID, rank, level)
    if rank.ranked == false or not rank.level or rank.level <= 0 then return 1 end
    local learned = rank.level
    if spellID == 635 or spellID == 5185 then learned = 0 end
    local levelsPastWindow = math.max(0, level - learned - 17)
    return math.max(0.10, 1 - 0.05 * levelsPastWindow)
end

local function attackPower(getPower)
    local base, positive, negative = getPower("player")
    if values.Number(base) and values.Number(positive) and values.Number(negative) then
        return math.max(0, base + positive + negative)
    end
end

local function spellPower(rank, effect, kind)
    if kind == "heal" then return GetSpellBonusHealing() end
    if effect.school or not rank.schools then return GetSpellBonusDamage(effect.school or rank.school) end
    local highest
    for _, school in ipairs(rank.schools) do
        local bonus = GetSpellBonusDamage(school)
        if not values.Number(bonus) then return end
        highest = math.max(highest or bonus, bonus)
    end
    return highest
end

local function magnitude(rank, effect, kind, level, share)
    if effect.talent and not C_SpellBook.IsSpellKnown(effect.talent) then return 0 end
    local amount = (effect.low + effect.high) / 2
    if effect.curve then
        local constant, linear, quadratic = unpack(effect.curve)
        amount = amount * (constant + level * (linear + level * quadratic))
    end
    if effect.spirit then
        local _, spirit = UnitStat("player", 5)
        if not values.Number(spirit) then return end
        amount = amount + spirit * effect.spirit
    end
    if effect.health and effect.health ~= 0 then
        local health = UnitHealthMax("player")
        if not values.Number(health) or health <= 0 then return end
        amount = amount + health * effect.health
    end
    if effect.perLevel and effect.perLevel ~= 0 then
        local last = math.min(level, effect.maxLevel or level)
        local gained = math.max(0, last - (effect.baseLevel or rank.level))
        amount = amount + effect.perLevel * gained
    end
    if effect.sp and effect.sp ~= 0 then
        local power = spellPower(rank, effect, kind)
        if not values.Number(power) then return end
        amount = amount + power * effect.sp * share
    end
    if effect.ap and effect.ap ~= 0 then
        local power = attackPower(UnitAttackPower)
        if not power then return end
        amount = amount + power * effect.ap
    end
    if effect.rap and effect.rap ~= 0 then
        local power = attackPower(UnitRangedAttackPower)
        if not power then return end
        amount = amount + power * effect.rap
    end
    return math.max(0, amount) * (effect.ticks or 1)
end

function ns.Estimate(spellID)
    if not values.Number(spellID) or spellID <= 0 then return end
    local rank = ns.SpellData[spellID]
    local result = {cost = manaCost(spellID, rank), isHeal = false}
    if not rank then return result end

    result.isHeal = rank.kind == "heal"
    if #rank.components == 0 then return result end

    local level = UnitLevel("player")
    local hasLevel = values.Number(level) and level > 0
    local share = hasLevel and spellPowerShare(spellID, rank, level)
    local missingHeal, missingDamage = false, false
    for _, effect in ipairs(rank.components) do
        local kind = effect.kind or rank.kind
        if kind == "heal" or effect.leech then result.isHeal = true end
        local amount = hasLevel and magnitude(rank, effect, kind, level, share)
        if amount then
            result[kind] = (result[kind] or 0) + amount
            -- Leech restores a fraction of the damage the spell deals. Use the
            -- same damage roll and damage-school power for both estimates.
            if effect.leech then result.heal = (result.heal or 0) + amount * effect.leech end
        elseif kind == "heal" then
            missingHeal = true
        else
            missingDamage = true
            if effect.leech then missingHeal = true end
        end
    end
    -- Don't display the direct hit alone if a periodic part couldn't be read.
    if missingHeal then result.heal = nil end
    if missingDamage then result.damage = nil end
    return result
end
