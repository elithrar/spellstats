-- Run with Lua 5.1.4 from the repository root or extracted ZIP.
local ns = {}
assert(loadfile("SpellStats/Libs/SomethingNeedDoing/Core.lua"))("SpellStats", ns)
local secret = {}
function issecretvalue(value) return value == secret end
Enum = {PowerType = {Mana = 0}}
local level, healing, damage, maxMana, health = 20, 100, 200, 1250, 2000
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
function UnitHealthMax() return health end
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

-- Client build 71037: one shared pool on a shield covering all seven schools.
-- PW:S scales with bonus healing; the literal Frost tooltip formula uses
-- Frost power even for low-rank Frost Ward, outside the downranked base.
costs = {{type = 0, cost = 500}}
local shield = ns.Estimate(10901, true)
near(shield.absorb, 938) -- 928 + 10% of 100 healing
assert(shield.heal == shield.absorb and shield.isHeal and shield.damage == nil)
assert(shield.cost == 500 and not shield.conditionalMana and shield.seconds == 1.5)
near(ns.Estimate(17).absorb, 49) -- 44 + 5 * 0.8 + 10% of downranked healing
near(ns.Estimate(6065).absorb, 305.5) -- floor(291 + 5 * 2.3) + .1 * 100 * .35
near(ns.Estimate(11426).absorb, 467) -- floor(431 + 6 * 2.8) + .1 * 200
near(ns.Estimate(13033).absorb, 839)
near(ns.Estimate(6143).absorb, 182) -- 162 + .1 * 200, no low-rank penalty
level = 6
near(ns.Estimate(17).absorb, 54)
level, healing = 60, secret
assert(ns.Estimate(10901).isHeal and ns.Estimate(10901).heal == nil)
near(ns.Estimate(28609).absorb, 933) -- a Frost shield doesn't use bonus healing
damage = secret
assert(ns.Estimate(28609).absorb == nil)
level, maxMana = secret, secret
local fixed = ns.Estimate(543, true) -- Fire Ward has a fixed pool, no power term
assert(fixed.absorb == 162 and fixed.heal == 162 and fixed.seconds == 1.5)
for id, capacity in pairs({[6229] = 290, [11739] = 470, [11740] = 675, [28610] = 920}) do
    local ward = ns.Estimate(id, true) -- Shadow Ward ranks from the supplemental data
    assert(ward.isHeal and ward.absorb == capacity and ward.heal == capacity and ward.seconds == 1.5)
end
for _, id in ipairs({642, 324, 408696}) do -- Divine Shield, Lightning Shield, Spirit of the Alpha
    assert(ns.Estimate(id).absorb == nil, "no absorb capacity for spell " .. id)
end
assert(ns.Estimate(11426).heal == nil and ns.MaxMana() == nil)
costs = {{type = 0, cost = 140}}
local manaShield = ns.Estimate(10193, true)
assert(manaShield.absorb == 570 and manaShield.cost == 140 and manaShield.conditionalMana)
assert(ns.Estimate(412120).absorb == 600 and ns.Estimate(412120).conditionalMana)
local bulwark = ns.Estimate(1311015, true)
assert(bulwark.absorb == 2000 and bulwark.seconds == nil)
health = secret
assert(ns.Estimate(1311015).heal == nil and ns.Estimate(1311015).isHeal)
level, healing, damage, health = 60, 100, 200, 2000

-- A single passive spell ID is shared by multiple ranks. Only a matching
-- active definition in the committed config identifies the damage bonus.
local config, staged, ranks = 31, false, {[105846] = 0, [105780] = 0}
local definitions = {[130575] = 135376, [130509] = 135310}
C_ClassTalents = {GetActiveConfigID = function() return config end}
C_Traits = {
    ConfigHasStagedChanges = function(id) assert(id == config); return staged end,
    GetNodeInfo = function(id, node)
        assert(id == config and ranks[node] ~= nil)
        return {activeRank = ranks[node], activeEntry = {entryID = node == 105846 and 130575 or 130509}}
    end,
    GetEntryInfo = function(id, entry) assert(id == config); return {definitionID = definitions[entry]} end,
}
for rank, factor in ipairs({1.07, 1.14, 1.20}) do
    ranks[105846] = rank
    near(ns.Estimate(10901).heal, 938 * factor)
end
for rank, factor in ipairs({1.10, 1.20}) do
    ranks[105780] = rank
    near(ns.Estimate(13033).absorb, 839 * factor)
    near(ns.Estimate(6143).absorb, 182 * factor)
end
staged, ranks[105846] = true, 1
near(ns.Estimate(10901).heal, 938 * 1.20) -- uncommitted edits don't change the active rank
config = 32
near(ns.Estimate(10901).heal, 938) -- a staged new config cannot borrow the last config's rank
staged = false
near(ns.Estimate(10901).heal, 938 * 1.07)
definitions[130575] = 135310
near(ns.Estimate(10901).heal, 938) -- a readable, different talent is never the prior talent
definitions[130575], ranks[105846] = 135376, 2
near(ns.Estimate(10901).heal, 938 * 1.14)
inCombat, ranks[105846] = true, secret
near(ns.Estimate(10901).heal, 938 * 1.14) -- restricted rank with a confirmed config
config = secret
near(ns.Estimate(10901).heal, 938 * 1.14) -- same combat, even the config ID is restricted
ns.ClearShieldTalentRanks() -- active group/config changed while its new ID is unreadable
near(ns.Estimate(10901).heal, 938)
inCombat, config, ranks[105846] = false, 31, 0
near(ns.Estimate(10901).heal, 938)
C_ClassTalents = nil
C_SpecializationInfo = {
    GetActiveSpecGroup = function() return 2 end,
    GetCombatConfigIDForSpecGroup = function(group) assert(group == 2); return config end,
}
ranks[105846] = 1
near(ns.Estimate(10901).heal, 938 * 1.07) -- Forever's alternate active group API
C_ClassTalents = {GetActiveConfigID = function() return nil end}
near(ns.Estimate(10901).heal, 938 * 1.07)
C_ClassTalents, C_SpecializationInfo, C_Traits = nil, nil, nil

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
        assert(stat == "heal" or stat == "damage" or stat == "absorb", id)
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

-- Request casting information only for rate displays. The API reports
-- milliseconds, including zero for a cast made instant by a proc.
inCombat, level, healing, damage, bloomKnown = false, 60, 100, 200, false
local castInfo, castLookups = {castTime = 2250}, 0
C_Spell.GetSpellInfo = function()
    castLookups = castLookups + 1
    return castInfo
end
assert(ns.Estimate(6063).seconds == nil and ns.Estimate(98765, true).seconds == nil and castLookups == 0)
near(ns.Estimate(6063, true).seconds, 2.25)
castInfo = {castTime = 0}
near(ns.Estimate(6063, true).seconds, 1.5) -- Heal with an instant-cast proc still occupies the GCD
near(ns.Estimate(25299, true).seconds, 12) -- Rejuvenation delivers the full heal over 12 s
assert(ns.Estimate(400616, true).seconds == nil) -- this instant Fire Blast variant is off the GCD
castInfo = {castTime = 1750}
near(ns.Estimate(9858, true).seconds, 22.75) -- Regrowth cast + its 21 s of healing
near(ns.Estimate(348, true).seconds, 16.75) -- Immolate cast + its 15 s of damage
local beforeChannels = castLookups
near(ns.Estimate(402174, true).seconds, 2) -- Penance's linked channel delivers all three bolts
near(ns.Estimate(15407, true).seconds, 3) -- Mind Flay's channel includes all three ticks
assert(castLookups == beforeChannels)

-- A hybrid can deliver its healing immediately and its damage over time.
-- Match the amount renderer's heal-first choice even when healing is zero.
local hybridID = 999999
ns.SpellData[hybridID] = {kind = "damage", cast = 2, gcd = 1.5, damageDuration = 5,
    components = {{kind = "heal", low = 0, high = 0, sp = 1}, {low = 20, high = 20}}}
castInfo, healing = nil, 0
local timed = ns.Estimate(hybridID, true)
assert(timed.heal == 0 and timed.damage == 20 and timed.seconds == 2)
healing = secret
timed = ns.Estimate(hybridID, true)
assert(timed.heal == nil and timed.damage == 20 and timed.seconds == 7)

-- An instant shield supplements the same target's heal. If a required stat
-- is unreadable the combined amount is unknown; independent damage survives.
ns.SpellData[hybridID].components[1] = {kind = "heal", low = 5, high = 5}
ns.SpellData[hybridID].components[3] = {kind = "absorb", low = 60, high = 60, sp = .1}
ns.SpellData[hybridID].healDuration = 3
healing = 100
timed = ns.Estimate(hybridID, true)
assert(timed.isHeal and timed.heal == 75 and timed.absorb == 70 and timed.damage == 20 and timed.seconds == 5)
healing = secret
timed = ns.Estimate(hybridID, true)
assert(timed.isHeal and timed.heal == nil and timed.absorb == nil and timed.damage == 20 and timed.seconds == 7)

inCombat, healing = true, 100
for _, unreadable in ipairs({secret, {castTime = secret}, {castTime = -1}, {castTime = math.huge}}) do
    castInfo = unreadable
    near(ns.Estimate(6063, true).seconds, 3) -- verified base cast time remains usable
end
C_Spell.GetSpellInfo = nil
near(ns.Estimate(6063, true).seconds, 3)

print("SpellStats model fixtures passed (" .. count .. " shipped ranks checked)")
