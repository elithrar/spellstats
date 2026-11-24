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
    if not level then return end
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

-- Forever can restrict player-stat reads in combat. Keep only this player's
-- last readable, out-of-combat inputs. Action identities and costs stay live.
local playerStats = {}
local function observed(key, value, valid)
    if InCombatLockdown() then
        if valid then return value end
        return playerStats[key]
    end
    if valid then
        playerStats[key] = value
        return value
    end
end

local function numberStat(key, value, positive)
    return observed(key, value, values.Number(value) and (not positive or value > 0))
end

local function playerLevel() return numberStat("level", UnitLevel("player"), true) end
local function maxHealth() return numberStat("maxHealth", UnitHealthMax("player"), true) end
local function bonusHealing() return numberStat("healing", GetSpellBonusHealing()) end
local function schoolPower(school) return numberStat(school, GetSpellBonusDamage(school)) end
local function meleePower() return numberStat("melee", attackPower(UnitAttackPower)) end
local function rangedPower() return numberStat("ranged", attackPower(UnitRangedAttackPower)) end
local function playerSpirit()
    local _, effective = UnitStat("player", 5)
    return numberStat("spirit", effective)
end
local function talentKnown(id)
    local known = C_SpellBook.IsSpellKnown(id)
    return observed("talent:" .. id, known, values.Readable(known) and type(known) == "boolean")
end

-- Only committed ranks of these two Forever traits modify shield capacity.
-- Check the entry's definition before using a node from the client export.
-- Nodes: https://zephras.com/data/forever/enUS/talents/1.60.1.70938.json
-- Trait overrides: https://www.wowhead.com/forever/spell=14748 and spell=11189
local shieldTalents = {
    [14748] = {node = 105846, definition = 135376, 7, 14, 20}, -- Improved Power Word: Shield
    [11189] = {node = 105780, definition = 135310, 10, 20},    -- Frost Warding
}

function ns.ClearShieldTalentRanks()
    for _, talent in pairs(shieldTalents) do talent.config, talent.percent = nil, nil end
end

local function nativeID(getID, ...)
    if getID then
        local ok, id = pcall(getID, ...)
        if ok and values.Number(id) and id > 0 then return id end
    end
end

local function activeConfig()
    local config = nativeID(C_ClassTalents and C_ClassTalents.GetActiveConfigID)
    if config then return config end
    local spec = C_SpecializationInfo
    local group = nativeID(spec and spec.GetActiveSpecGroup)
    if group then return nativeID(spec.GetCombatConfigIDForSpecGroup, group) end
end

local function committedPercent(config, talent)
    local staged = C_Traits.ConfigHasStagedChanges(config)
    if not values.Readable(staged) or type(staged) ~= "boolean" then return end
    if staged then return talent.percent end
    local node = C_Traits.GetNodeInfo(config, talent.node)
    if not values.Readable(node) or type(node) ~= "table" then return end
    local rank = node.activeRank
    if not values.Number(rank) then return end
    if rank == 0 then return 0 end
    local active = node.activeEntry
    if not values.Readable(active) or type(active) ~= "table" or not values.Number(active.entryID) then return end
    local entry = C_Traits.GetEntryInfo(config, active.entryID)
    if values.Readable(entry) and type(entry) == "table" and values.Number(entry.definitionID) then
        if entry.definitionID ~= talent.definition then return 0 end
        return talent[rank]
    end
end

local function shieldMultiplier(id)
    local talent = shieldTalents[id]
    if not talent then return 1 end
    local config = activeConfig()
    if config then
        if config ~= talent.config then talent.config, talent.percent = config, nil end
        if C_Traits then
            local read, percent = pcall(committedPercent, config, talent)
            if read and percent then
                if not InCombatLockdown() then talent.percent = percent end
                return 1 + percent / 100
            end
        end
    end
    if InCombatLockdown() and talent.percent then return 1 + talent.percent / 100 end
    return 1
end

function ns.RefreshPlayerStats()
    if InCombatLockdown() then return end
    playerLevel()
    bonusHealing()
    for school = 1, 7 do schoolPower(school) end
    meleePower()
    rangedPower()
    playerSpirit()
    maxHealth()
    talentKnown(1328621) -- Bloom adds a Spirit-based component to druid heals.
    if UnitClass then
        local _, class = UnitClass("player")
        if values.Readable(class) then
            if class == "PRIEST" then shieldMultiplier(14748)
            elseif class == "MAGE" then shieldMultiplier(11189) end
        end
    end
end

local function spellPower(rank, effect, kind)
    if kind == "heal" or (kind == "absorb" and not effect.school) then return bonusHealing() end
    if effect.school or not rank.schools then return schoolPower(effect.school or rank.school) end
    local highest
    for _, school in ipairs(rank.schools) do
        local bonus = schoolPower(school)
        if not bonus then return end
        highest = math.max(highest or bonus, bonus)
    end
    return highest
end

local function magnitude(rank, effect, kind, level, share)
    if effect.talent then
        local known = talentKnown(effect.talent)
        if known == nil then return end
        if not known then return 0 end
    end
    local amount = (effect.low + effect.high) / 2
    if effect.curve then
        if not level then return end
        local constant, linear, quadratic = unpack(effect.curve)
        amount = amount * (constant + level * (linear + level * quadratic))
    end
    if effect.spirit then
        local spirit = playerSpirit()
        if not spirit then return end
        amount = amount + spirit * effect.spirit
    end
    if effect.health and effect.health ~= 0 then
        local health = maxHealth()
        if not health then return end
        amount = amount + health * effect.health
    end
    if effect.perLevel and effect.perLevel ~= 0 then
        if not level then return end
        local last = math.min(level, effect.maxLevel or level)
        local gained = math.max(0, last - (effect.baseLevel or rank.level))
        amount = amount + effect.perLevel * gained
        -- The client truncates level growth before adding shield power.
        if kind == "absorb" then amount = math.floor(amount) end
    end
    if effect.sp and effect.sp ~= 0 then
        -- Frost Ward and Ice Barrier explicitly add a share of Frost power
        -- outside their rank-scaled base in the client tooltip formula.
        local coefficientShare = effect.fullPower and 1 or share
        if not coefficientShare then return end
        local power = spellPower(rank, effect, kind)
        if not power then return end
        amount = amount + power * effect.sp * coefficientShare
    end
    if effect.ap and effect.ap ~= 0 then
        local power = meleePower()
        if not power then return end
        amount = amount + power * effect.ap
    end
    if effect.rap and effect.rap ~= 0 then
        local power = rangedPower()
        if not power then return end
        amount = amount + power * effect.rap
    end
    if kind == "absorb" and rank.absorbTalent then amount = amount * shieldMultiplier(rank.absorbTalent) end
    return math.max(0, amount) * (effect.ticks or 1)
end

local function liveCastSeconds(spellID)
    local info = C_Spell.GetSpellInfo(spellID)
    if not values.Readable(info) or type(info) ~= "table" then return end
    local milliseconds = info.castTime
    if values.Number(milliseconds) and milliseconds >= 0 then return milliseconds / 1000 end
end

local function applicationSeconds(spellID, rank, healing)
    local elapsed = rank.channel
    if not elapsed then
        local cast = rank.cast or 0
        if C_Spell.GetSpellInfo then
            local ok, live = pcall(liveCastSeconds, spellID)
            if ok and live then cast = live end
        end
        local delivery = healing and (rank.healDuration or 0) or (rank.damageDuration or 0)
        elapsed = cast + delivery
    end
    -- Casts and channels overlap the GCD. A channel already includes its ticks.
    elapsed = math.max(rank.gcd or 0, elapsed)
    if elapsed > 0 then return elapsed end
end

function ns.Estimate(spellID, includeTiming)
    if not values.Number(spellID) or spellID <= 0 then return end
    local rank = ns.SpellData[spellID]
    local result = {cost = manaCost(spellID, rank), isHeal = false}
    if not rank then return result end

    result.isHeal = rank.kind == "heal" or rank.kind == "absorb"
    result.conditionalMana = rank.conditionalMana
    if #rank.components == 0 then return result end

    local level = playerLevel()
    local share = spellPowerShare(spellID, rank, level)
    local missingHeal, missingAbsorb, missingDamage = false, false, false
    for _, effect in ipairs(rank.components) do
        local kind = effect.kind or rank.kind
        if kind == "heal" or kind == "absorb" or effect.leech then result.isHeal = true end
        local amount = magnitude(rank, effect, kind, level, share)
        if amount then
            result[kind] = (result[kind] or 0) + amount
            -- Leech restores a fraction of the damage the spell deals. Use the
            -- same damage roll and damage-school power for both estimates.
            if effect.leech then result.heal = (result.heal or 0) + amount * effect.leech end
        elseif kind == "absorb" then
            missingAbsorb = true
        elseif kind == "heal" then
            missingHeal = true
        else
            missingDamage = true
            if effect.leech then missingHeal = true end
        end
    end
    -- The healing display includes the capacity applied to one target. A
    -- shield covering several schools still contributes its pool only once.
    if missingAbsorb then result.absorb = nil end
    if missingHeal or missingAbsorb then
        result.heal = nil
    elseif result.absorb then
        result.heal = (result.heal or 0) + result.absorb
    end
    if missingDamage then result.damage = nil end
    if includeTiming and (result.heal or result.damage) then
        result.seconds = applicationSeconds(spellID, rank, result.heal ~= nil)
    end
    return result
end
