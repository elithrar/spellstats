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
    assert(type(actual) == "number" and math.abs(actual - expected) < 0.001, tostring(actual) .. " vs " .. expected)
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
local config, staged, ranks, nodeReads = 31, false, {}, 0
local entries = {[105846] = 130575, [105780] = 130509, [105866] = 130595,
    [105849] = 130578, [105852] = 130581}
local definitions = {[130575] = 135376, [130509] = 135310, [130595] = 135396,
    [130578] = 135379, [130581] = 135382}
C_ClassTalents = {GetActiveConfigID = function() return config end}
C_Traits = {
    ConfigHasStagedChanges = function(id) assert(id == config); return staged end,
    GetNodeInfo = function(id, node)
        assert(id == config and entries[node])
        nodeReads = nodeReads + 1
        return {activeRank = ranks[node] or 0, activeEntry = {entryID = entries[node]}}
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
ns.ClearTalentRanks() -- active group/config changed while its new ID is unreadable
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

local renews = {139, 6074, 6075, 6076, 6077, 6078, 10927, 10928, 10929, 25315,
    425268, 425269, 425270, 425271, 425272, 425273, 425274, 425275, 425276, 425277}
local untalented = {}
for _, id in ipairs(renews) do untalented[id] = ns.Estimate(id).heal end
near(untalented[25315], 5 * (166 + .2 * healing))
near(untalented[425277], 5 * (194 + .23 * healing))
for rank, factor in ipairs({1.05, 1.10, 1.15}) do
    ranks[105866] = rank
    for _, id in ipairs(renews) do
        local renewed = ns.Estimate(id, true)
        near(renewed.heal, untalented[id] * factor)
        assert(renewed.seconds == 15)
    end
    near(ns.Estimate(25299).heal, 856) -- Improved Renew is specific to Renew
end
staged, ranks[105866] = true, 0
near(ns.Estimate(25315).heal, 930 * 1.15)
staged = false
near(ns.Estimate(25315).heal, 930)

-- Each Prayer of Mending tooltip multiplies the whole charge by both
-- passives. Neither the five charges nor the 30 s buff is a per-target rate.
for twin = 0, 5 do
    ranks[105849] = twin
    for rank, spiritual in ipairs({0, 3, 7, 10}) do
        ranks[105852] = rank - 1
        local factor = (1 + twin / 100) * (1 + spiritual / 100)
        local prayer = ns.Estimate(1240827, true)
        near(prayer.heal, 455.9 * factor)
        assert(prayer.isHeal and prayer.seconds == nil)
        near(ns.Estimate(25315).heal, 930 * factor)
    end
end
-- At full ranks, Improved Renew multiplies both periodic bonuses on Renew.
-- Prayer of Mending still uses only Twin Disciplines and Spiritual Healing.
ranks[105866] = 3
for _, id in ipairs(renews) do near(ns.Estimate(id).heal, untalented[id] * 1.32825) end
costs = {{type = 0, cost = 410}}
local fullRenew = ns.Estimate(25315, true)
near(fullRenew.heal / fullRenew.seconds, 82.3515)
near(fullRenew.heal / fullRenew.cost, 3.01286)
near(ns.Estimate(1240827).heal, 455.9 * 1.05 * 1.10)
ranks[105866], ranks[105849], ranks[105852] = 0, 0, 0
-- The event-driven bars share committed talent reads across visible ranks.
-- A respec can invalidate these reads independently of an ordinary stat update.
function UnitClass() return "Priest", "PRIEST" end
ranks[105866] = 2
ns.DirtyTalentRanks()
ns.RefreshPlayerStats()
local sampled = nodeReads
ns.RefreshPlayerStats()
near(ns.Estimate(25315).heal, 930 * 1.10)
near(ns.Estimate(425277).heal, 1085 * 1.10)
assert(nodeReads == sampled)
ranks[105866] = 0
ns.DirtyTalentRanks()
near(ns.Estimate(25315).heal, 930)
assert(nodeReads > sampled)
UnitClass = nil
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

-- Build 71037 cast records at their learned level. The listed damage is
-- for one target: one Conflagrate hit and both of Consecration's eight-tick
-- effects on the first enemy. The four-target cap adds no extra hits here.
local ordinaryDamage = GetSpellBonusDamage
function GetSpellBonusDamage(school) return school * 50 end
for _, family in ipairs({
    {seconds = 1.5, bonus = .429 * 150, {1293817, 25, 95}, {1293818, 32, 122}, {17962, 40, 146},
        {18930, 48, 194}, {18931, 54, 239}, {18932, 60, 282}},
    {seconds = 8, bonus = .336 * 100, {26573, 20, 48}, {20116, 30, 80}, {20922, 40, 136},
        {20923, 50, 224}, {20924, 60, 312}},
}) do
    for _, row in ipairs(family) do
        level = row[2]
        local hit = ns.Estimate(row[1], true)
        near(hit.damage, row[3] + family.bonus)
        assert(not hit.isHeal and hit.heal == nil and hit.seconds == family.seconds)
    end
end
-- Caster health is the resource spent on Health Funnel. The pet receives
-- ten fixed heals; the caster's own periodic damage does not enter DPS.
costs = {{type = -2, cost = 79}}
for id, total in pairs({[755]=120, [3698]=240, [3699]=430, [3700]=640,
    [11693]=890, [11694]=1190, [11695]=1530}) do
    local funnel = ns.Estimate(id, true)
    assert(funnel.isHeal and funnel.heal == total and funnel.damage == nil)
    assert(funnel.cost == nil and funnel.seconds == 10)
end
for _, row in ipairs({{401859, 40, 172, 210}, {1240826, 50, 298, 305}, {1240827, 60, 413, 390}}) do
    level, costs = row[2], {{type = 0, cost = row[4]}}
    local prayer = ns.Estimate(row[1], true)
    near(prayer.heal, row[3] + .429 * healing)
    assert(prayer.isHeal and prayer.damage == nil and prayer.seconds == nil and prayer.cost == row[4])
end
near(ns.Estimate(401859).heal, 172 + .429 * healing * .85)
for _, helper in ipairs({401863, 401877, 401880, 1280349}) do
    local proc = ns.Estimate(helper, true)
    assert(proc.heal == nil and proc.damage == nil and proc.seconds == nil)
end
-- Arcane Wrath's 5% of maximum mana adds spell power before downranking.
maxMana = 1000
for _, row in ipairs({{1326079, 25, 120}, {1326080, 36, 187}, {1326081, 48, 300}, {1326082, 60, 451}}) do
    level = row[2]
    local wrath = ns.Estimate(row[1], true)
    near(wrath.damage, row[3] + 350 + 50)
    assert(not wrath.isHeal and wrath.seconds == 3.5)
end
near(ns.Estimate(1326079).damage, 134 + .1 * (350 + 50))
maxMana = 2000
near(ns.Estimate(1326082).damage, 451 + 350 + 100)
near(ns.Estimate(18932).damage, 282 + .429 * 150) -- changing the mana pool only scales Arcane Wrath
GetSpellBonusDamage = ordinaryDamage

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
inCombat, level, healing, damage, maxMana = true, 36, secret, secret, secret
costs = {{type = 0, cost = 140}}
local cast = fresh.Estimate(6063)
assert(cast.isHeal and cast.heal == nil and cast.cost == 140)
damage = 200
assert(fresh.Estimate(1326079).damage == nil) -- no readable maximum mana before this combat
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
near(fresh.Estimate(1326079).damage, 134 + 200 + 50) -- recalled damage inputs, live mana percentage remains unavailable
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

-- Missile Barrage changes the firing interval of the trained channels. The
-- damage and the live cost can still be read when aura information is blocked.
local aura, restricted, auraReads = nil, false, 0
C_Secrets = {ShouldSpellAuraBeSecret = function(id) assert(id == 400589); return restricted end}
C_UnitAuras = {GetPlayerAuraBySpellID = function(id)
    assert(id == 400589)
    auraReads = auraReads + 1
    return aura
end}
costs = {{type = 0, cost = 0}}
for _, row in ipairs({{5143, 3}, {5144, 4}, {5145, 5}, {8416, 5}, {8417, 5},
    {10211, 5}, {10212, 5}, {25345, 5}}) do
    local id, seconds = row[1], row[2]
    aura = nil
    local normal = ns.Estimate(id, true)
    near(normal.seconds, seconds)
    aura = {spellId = 400589}
    local barrage = ns.Estimate(id, true)
    near(barrage.seconds, seconds / 2)
    near(barrage.damage, normal.damage) -- still delivers all three, four or five missiles
    assert(barrage.cost == 0)
end
local reads = auraReads
near(ns.Estimate(25345).damage, 5 * (209 + .286 * damage))
near(ns.Estimate(11695, true).seconds, 10) -- other channels ignore Missile Barrage
assert(auraReads == reads)
restricted = true
local hidden = ns.Estimate(25345, true)
assert(hidden.seconds == nil and hidden.cost == 0 and hidden.damage ~= nil and auraReads == reads)
restricted = false
for _, invalidAura in ipairs({secret, {spellId = secret}, {spellId = 400588}}) do
    aura = invalidAura
    assert(ns.Estimate(25345, true).seconds == nil)
end
C_UnitAuras.GetPlayerAuraBySpellID = function() error("aura access restricted") end
assert(ns.Estimate(25345, true).seconds == nil)
C_UnitAuras, C_Secrets = nil, nil
assert(ns.Estimate(25345, true).seconds == nil)

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
