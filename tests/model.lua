-- Run from the project root with Lua 5.1 or texlua.
local ns = {}
assert(loadfile("SpellStats/Libs/SomethingNeedDoing/Core.lua"))("SpellStats", ns)
local secret = {}
function issecretvalue(value) return value == secret end
Enum = {PowerType = {Mana = 0}}
unpack = unpack or table.unpack
local level, healing, damage, maxMana = 20, 100, 200, 1250
local inCombat = false
function InCombatLockdown() return inCombat end
function UnitLevel() return level end
function GetSpellBonusHealing() return healing end
function GetSpellBonusDamage(school)
    if school == 3 then return 250 end
    assert(school == 4 or school == 6)
    return damage
end
function UnitPowerMax(unit, power) assert(unit == "player" and power == 0); return maxMana end
function UnitHealthMax() return 2000 end
function UnitPower(unit, power) assert(unit == "player" and power == 0); return 900 end
function UnitAttackPower() return 98, 4, -2 end
function UnitRangedAttackPower() return 148, 5, -3 end
local costs, bloomKnown = nil, false
C_SpellBook = {IsSpellKnown = function(id) assert(id == 1328621); return bloomKnown end}
function UnitStat(unit, index) assert(index == 5); return 120, 125, 5, 0 end
C_Spell = {GetSpellPowerCost = function() return costs end}
ns.SpellData = {
    [1] = {kind = "heal", level = 10, components = {
        {low = 40, high = 60, sp = 0.5, perLevel = 2, baseLevel = 10, maxLevel = 14},
        {low = 10, high = 10, sp = 0.2, ticks = 4},
    }},
    [2] = {kind = "damage", level = 10, school = 4, components = {
        {low = 22, high = 26, sp = 0.8, ap = 0.1, rap = 0.2},
        {kind = "heal", low = 10, high = 10},
    }},
    [3] = {kind = "heal", level = 1, ranked = false, components = {
        {low = 2, high = 2, sp = 1, health = 0.1, curve = {1, 2, 0.1}},
    }},
    [8] = {kind = "damage", school = 6, components = {
        {low = 12, high = 16, sp = 0.1, ticks = 5, leech = 0.5},
        {low = 8, high = 8}, -- separate damage does not leech
    }},
    [4] = {kind = "heal", components = {}},
    [7] = {kind = "damage", schools = {3, 4}, components = {{low = 10, high = 10, sp = 0.5}}},
    [6] = {kind = "heal", components = {{low = 100, high = 100}, {low = 0, high = 0, talent = 1328621, spirit = 1}}},
    [5] = {kind = "heal", allMana = true, components = {{low = 0, high = 0, health = 1}}},
}
assert(loadfile("SpellStats/Model.lua"))("SpellStats", ns)

costs = {
    {type = 3, cost = 70}, -- another resource
    {type = 0, cost = 20, requiredAuraID = 0, hasRequiredAura = false, costPercent = 5},
    {type = 0, cost = 8, requiredAuraID = 8, hasRequiredAura = true},
    {type = 0, cost = 35, requiredAuraID = 9, hasRequiredAura = false},
}
assert(ns.Estimate(6).heal == 100)
bloomKnown = true
assert(ns.Estimate(6).heal == 225)
assert(ns.Estimate(7).damage == 135) -- stronger fire bonus on a mixed-school spell
local drain = ns.Estimate(8)
assert(drain.isHeal and drain.damage == 178 and drain.heal == 85)
local heal = ns.Estimate(1)
assert(heal.heal == 228 and heal.cost == 28 and heal.isHeal)
assert(ns.MaxMana() == 1250)
local hybrid = ns.Estimate(2)
assert(hybrid.damage == 224 and hybrid.heal == 10 and hybrid.isHeal)
assert(ns.Estimate(3).heal == 462)
assert(ns.Estimate(4).isHeal and ns.Estimate(4).heal == nil)
assert(ns.Estimate(5).heal == 2000 and ns.Estimate(5).cost == 900)

level = 30 -- rank learned at 10, 85% of bonus retained
assert(math.abs(ns.Estimate(1).heal - 208.5) < 0.00001)
level = 60
assert(ns.Estimate(1).heal == 111)
assert(ns.Estimate(3).heal == 1262) -- unranked power retained
level = 20
local unknown = ns.Estimate(98765)
assert(unknown.cost == 28 and unknown.heal == nil and unknown.damage == nil and not unknown.isHeal)
costs = {{type = 0, cost = 0}}
assert(ns.Estimate(1).cost == 0)
costs = {{type = 0, cost = 10, costPerSec = 5}}
assert(ns.Estimate(1).cost == nil)
costs = {{type = 3, cost = 75}}
assert(ns.Estimate(1).cost == nil)
costs = {{type = 0, cost = secret}}
assert(ns.Estimate(1).cost == nil)
costs = nil
maxMana, healing, damage = secret, secret, secret
assert(ns.Estimate(secret) == nil and ns.MaxMana() == nil)
assert(ns.Estimate(1).heal == nil and ns.Estimate(1).isHeal)
assert(ns.Estimate(2).damage == nil and ns.Estimate(2).heal == 10)
assert(ns.Estimate(8).isHeal and ns.Estimate(8).damage == nil and ns.Estimate(8).heal == nil)
-- Check real Forever ranks as well as testing the adapter with synthetic rows.
assert(loadfile("SpellStats/SpellData.lua"))("SpellStats", ns)
level, healing, damage, bloomKnown = 60, 100, 200, false
function GetSpellBonusDamage(school)
    assert(school >= 1 and school <= 7)
    return damage
end
local function near(actual, expected)
    assert(math.abs(actual - expected) < 0.001, tostring(actual) .. " vs " .. expected)
end
near(ns.Estimate(25299).heal, 856) -- Rejuvenation XI, 4 x (194 + .2 * 100)
near(ns.Estimate(774).heal, 40) -- first rank at level 60 retains 10% of its coefficient
near(ns.Estimate(9858).heal, 2093.3) -- Regrowth IX, direct + seven ticks
bloomKnown = true
near(ns.Estimate(25299).heal, 981) -- 125 effective Spirit once on expiration
near(ns.Estimate(9858).heal, 2218.3)
bloomKnown = false
near(ns.Estimate(3044).damage, 47.5) -- Arcane Shot I includes 15% ranged AP
level = 48
local shock = ns.Estimate(20929)
near(shock.heal, 272.9)
near(shock.damage, 343.8)
assert(shock.isHeal)
-- Death Coil I: 272 + six capped levels of 2.2 + 21.4% of 200 Shadow
-- damage. Changing bonus healing alone must not change the health return.
local coil = ns.Estimate(6789)
near(coil.damage, 328)
near(coil.heal, 328)
assert(coil.isHeal)
healing = 300
near(ns.Estimate(6789).heal, 328)
healing = 100
local hands = ns.Estimate(633)
assert(hands.heal == 2000 and hands.cost == 900)
local count = 0
for id, rank in pairs(ns.SpellData) do
    local estimate = ns.Estimate(id)
    assert(estimate, id)
    for _, effect in ipairs(rank.components) do
        local stat = effect.kind or rank.kind
        assert(stat == "heal" or stat == "damage", id)
        assert(estimate[stat] and estimate[stat] >= 0, id)
    end
    count = count + 1
end

-- An in-combat reload has no prior character sample. A readable cost still
-- belongs to this cast even when its Priest Heal rank 3 magnitude is unknown.
local fresh = {SomethingNeedDoing = ns.SomethingNeedDoing, SpellData = ns.SpellData}
assert(loadfile("SpellStats/Model.lua"))("SpellStats", fresh)
inCombat, level, healing, damage = true, 36, secret, secret
costs = {{type = 0, cost = 140}}
local cast = fresh.Estimate(6063)
assert(cast.isHeal and cast.heal == nil and cast.cost == 140)
healing, bloomKnown = 100, secret
assert(fresh.Estimate(3627).heal == nil) -- unknown talent state cannot count as unlearned

-- Snapshot all schools with no spell on a bar, then page to new spells while
-- stats are restricted. A proc's current cost and the player's current mana
-- must never be replaced by the precombat cost or mana.
inCombat, healing, damage, maxMana, bloomKnown = false, 100, 200, 1000, false
fresh.RefreshPlayerStats()
inCombat, level, healing, damage, bloomKnown = true, secret, secret, secret, secret
costs, maxMana = {{type = 0, cost = 0}}, secret
cast = fresh.Estimate(6063)
near(cast.heal, 628.7)
assert(cast.cost == 0 and fresh.MaxMana() == nil)
near(fresh.Estimate(116).damage, 40.15) -- downranked Frostbolt with 200 Frost power
near(fresh.Estimate(3627).heal, 284) -- Rejuvenation 6, with Bloom known to be absent
costs = {{type = 0, cost = secret}}
assert(fresh.Estimate(6063).cost == nil)

healing = 150 -- readable combat buff applies, without replacing the baseline
near(fresh.Estimate(6063).heal, 671.55)
fresh.RefreshPlayerStats()
healing = secret
near(fresh.Estimate(6063).heal, 628.7)
inCombat = false
assert(fresh.Estimate(6063).heal == nil)
level, healing, bloomKnown = 36, 0, false
fresh.RefreshPlayerStats() -- zero bonus healing is a valid new baseline
inCombat, healing = true, secret
near(fresh.Estimate(6063).heal, 543)

print("SpellStats model fixtures passed (" .. count .. " shipped ranks checked)")
