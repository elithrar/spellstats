-- Numeric spell effects and base timing (seconds) from the Blizzard Forever 1.60.1.71037 client export:
-- https://github.com/wowsims/gamedata/tree/0c2b3f0dff123ea052afd3dbef43c1490907d419/spells
-- Learn levels and per-level caps from SpellPowerCoefficients 1.0.2 (70888/70862):
-- https://www.curseforge.com/wow/addons/spc-forever/files/9739224
-- Hunter RAP shares (15% Arcane Shot; 25% over 5 Serpent Sting ticks) and mage rank levels:
-- https://www.curseforge.com/wow/addons/dynamictooltips/files/9705865
-- Shadow Ward rank values missing from the primary export: https://foreverdb.net/spell/6229 (71037).
-- Effect and timing: https://db.icy-veins.com/wow-forever/spells/6229 (and the other rank IDs).
-- See THIRD-PARTY.txt for attribution. Regenerate with tools/spell_data.py.
local _, ns = ...
ns.SpellData = {
    [400610] = {kind="damage", school=7, ranked=false, cast=0, gcd=1.5, components={{low=3.58, high=4.38, sp=0.429, curve={13.82812, 0.018012, 0.044141}}}}, -- Arcane Barrage
    [400574] = {kind="damage", school=7, level=20, cast=1.5, gcd=1.5, components={{low=29.58367, high=34.41633, sp=0.429, perLevel=0.5, baseLevel=20, maxLevel=28}}}, -- Arcane Blast 1
    [1239696] = {kind="damage", school=7, level=30, cast=1.5, gcd=1.5, components={{low=72.1102, high=83.8898, sp=0.429, perLevel=0.8, baseLevel=30, maxLevel=38}}}, -- Arcane Blast 2
    [1239697] = {kind="damage", school=7, level=40, cast=1.5, gcd=1.5, components={{low=93.37347, high=108.6265, sp=0.429, perLevel=1, baseLevel=40, maxLevel=48}}}, -- Arcane Blast 3
    [1239699] = {kind="damage", school=7, level=50, cast=1.5, gcd=1.5, components={{low=155.3143, high=180.6857, sp=0.429, perLevel=1.3, baseLevel=50, maxLevel=58}}}, -- Arcane Blast 4
    [1239700] = {kind="damage", school=7, level=60, cast=1.5, gcd=1.5, components={{low=218.1796, high=253.8204, sp=0.429, perLevel=1.6, baseLevel=60, maxLevel=68}}}, -- Arcane Blast 5
    [1449] = {kind="damage", school=7, level=14, cast=0, gcd=1.5, components={{low=30.11765, high=33.88235, sp=0.143, perLevel=0.4, baseLevel=14, maxLevel=19}}}, -- Arcane Explosion 1
    [8437] = {kind="damage", school=7, level=22, cast=0, gcd=1.5, components={{low=52.25, high=57.75, sp=0.143, perLevel=0.6, baseLevel=22, maxLevel=27}}}, -- Arcane Explosion 2
    [8438] = {kind="damage", school=7, level=30, cast=0, gcd=1.5, components={{low=90.27723, high=97.72277, sp=0.143, perLevel=0.9, baseLevel=30, maxLevel=35}}}, -- Arcane Explosion 3
    [8439] = {kind="damage", school=7, level=38, cast=0, gcd=1.5, components={{low=129.4138, high=140.5862, sp=0.143, perLevel=0.9, baseLevel=38, maxLevel=43}}}, -- Arcane Explosion 4
    [10201] = {kind="damage", school=7, level=46, cast=0, gcd=1.5, components={{low=175.4536, high=190.5464, sp=0.143, perLevel=1.1, baseLevel=46, maxLevel=51}}}, -- Arcane Explosion 5
    [10202] = {kind="damage", school=7, level=54, cast=0, gcd=1.5, components={{low=232.4348, high=251.5652, sp=0.143, perLevel=1.3, baseLevel=54, maxLevel=59}}}, -- Arcane Explosion 6
    [5143] = {kind="damage", school=7, level=8, cast=0, gcd=1.5, channel=3, components={{low=24, high=24, ticks=3, sp=0.286, perLevel=0.2, baseLevel=8, maxLevel=12}}}, -- Arcane Missiles 1
    [5144] = {kind="damage", school=7, level=16, cast=0, gcd=1.5, channel=4, components={{low=34, high=34, ticks=4, sp=0.286, perLevel=0.3, baseLevel=16, maxLevel=20}}}, -- Arcane Missiles 2
    [5145] = {kind="damage", school=7, level=24, cast=0, gcd=1.5, channel=5, components={{low=47, high=47, ticks=5, sp=0.286, perLevel=0.4, baseLevel=24, maxLevel=28}}}, -- Arcane Missiles 3
    [8416] = {kind="damage", school=7, level=32, cast=0, gcd=1.5, channel=5, components={{low=66, high=66, ticks=5, sp=0.286, perLevel=0.6, baseLevel=32, maxLevel=36}}}, -- Arcane Missiles 4
    [8417] = {kind="damage", school=7, level=40, cast=0, gcd=1.5, channel=5, components={{low=95, high=95, ticks=5, sp=0.286, perLevel=0.7, baseLevel=40, maxLevel=44}}}, -- Arcane Missiles 5
    [10211] = {kind="damage", school=7, level=48, cast=0, gcd=1.5, channel=5, components={{low=130, high=130, ticks=5, sp=0.286, perLevel=0.8, baseLevel=48, maxLevel=52}}}, -- Arcane Missiles 6
    [10212] = {kind="damage", school=7, level=56, cast=0, gcd=1.5, channel=5, components={{low=171, high=171, ticks=5, sp=0.286, perLevel=0.9, baseLevel=56, maxLevel=60}}}, -- Arcane Missiles 7
    [25345] = {kind="damage", school=7, level=56, cast=0, gcd=1.5, channel=5, components={{low=209, high=209, ticks=5, sp=0.286, perLevel=1, baseLevel=56, maxLevel=56}}}, -- Arcane Missiles 8
    [3044] = {kind="damage", school=7, cast=0, gcd=1.5, components={{low=25, high=25, rap=0.15}}}, -- Arcane Shot 1
    [14281] = {kind="damage", school=7, cast=0, gcd=1.5, components={{low=35, high=35, rap=0.15}}}, -- Arcane Shot 2
    [14282] = {kind="damage", school=7, cast=0, gcd=1.5, components={{low=50, high=50, rap=0.15}}}, -- Arcane Shot 3
    [14283] = {kind="damage", school=7, cast=0, gcd=1.5, components={{low=85, high=85, rap=0.15}}}, -- Arcane Shot 4
    [14284] = {kind="damage", school=7, cast=0, gcd=1.5, components={{low=120, high=120, rap=0.15}}}, -- Arcane Shot 5
    [14285] = {kind="damage", school=7, cast=0, gcd=1.5, components={{low=175, high=175, rap=0.15}}}, -- Arcane Shot 6
    [14286] = {kind="damage", school=7, cast=0, gcd=1.5, components={{low=220, high=220, rap=0.15}}}, -- Arcane Shot 7
    [14287] = {kind="damage", school=7, cast=0, gcd=1.5, components={{low=280, high=280, rap=0.15}}}, -- Arcane Shot 8
    [980] = {kind="damage", school=6, level=8, cast=0, gcd=1.5, damageDuration=24, components={{low=6, high=6, ticks=12, sp=0.133}}}, -- Bane of Agony 1
    [1014] = {kind="damage", school=6, level=18, cast=0, gcd=1.5, damageDuration=24, components={{low=10, high=10, ticks=12, sp=0.133}}}, -- Bane of Agony 2
    [6217] = {kind="damage", school=6, level=28, cast=0, gcd=1.5, damageDuration=24, components={{low=14, high=14, ticks=12, sp=0.133}}}, -- Bane of Agony 3
    [11711] = {kind="damage", school=6, level=38, cast=0, gcd=1.5, damageDuration=24, components={{low=21, high=21, ticks=12, sp=0.133}}}, -- Bane of Agony 4
    [11712] = {kind="damage", school=6, level=48, cast=0, gcd=1.5, damageDuration=24, components={{low=33, high=33, ticks=12, sp=0.133}}}, -- Bane of Agony 5
    [11713] = {kind="damage", school=6, level=58, cast=0, gcd=1.5, damageDuration=24, components={{low=46, high=46, ticks=12, sp=0.133}}}, -- Bane of Agony 6
    [603] = {kind="damage", school=6, level=60, ranked=false, cast=0, gcd=1.5, damageDuration=60, components={{low=1742, high=1742, sp=4}}}, -- Bane of Doom
    [401937] = {kind="heal", school=2, level=25, cast=1.5, gcd=1.5, components={{low=222.8182, high=271.1818, sp=0.429, perLevel=2.2, baseLevel=25, maxLevel=31}}}, -- Binding Heal 1
    [1240770] = {kind="heal", school=2, level=32, cast=1.5, gcd=1.5, components={{low=283.4001, high=340.5999, sp=0.429, perLevel=2.5, baseLevel=32, maxLevel=37}}}, -- Binding Heal 2
    [1240771] = {kind="heal", school=2, level=38, cast=1.5, gcd=1.5, components={{low=348.9749, high=417.0251, sp=0.429, perLevel=2.8, baseLevel=38, maxLevel=43}}}, -- Binding Heal 3
    [1240772] = {kind="heal", school=2, level=44, cast=1.5, gcd=1.5, components={{low=463.1851, high=550.8149, sp=0.429, perLevel=3.3, baseLevel=44, maxLevel=49}}}, -- Binding Heal 4
    [1240773] = {kind="heal", school=2, level=50, cast=1.5, gcd=1.5, components={{low=589.1136, high=698.8866, sp=0.429, perLevel=3.7, baseLevel=50, maxLevel=55}}}, -- Binding Heal 5
    [1240774] = {kind="heal", school=2, level=56, cast=1.5, gcd=1.5, components={{low=756.949, high=893.051, sp=0.429, perLevel=4.2, baseLevel=56, maxLevel=61}}}, -- Binding Heal 6
    [11113] = {kind="damage", school=3, level=30, cast=0, gcd=1.5, components={{low=147.6588, high=178.3412, sp=0.129, perLevel=1, baseLevel=30, maxLevel=36}}}, -- Blast Wave 1
    [13018] = {kind="damage", school=3, level=36, cast=0, gcd=1.5, components={{low=192.8145, high=231.1855, sp=0.129, perLevel=1.2, baseLevel=36, maxLevel=42}}}, -- Blast Wave 2
    [13019] = {kind="damage", school=3, level=44, cast=0, gcd=1.5, components={{low=267.8581, high=318.1419, sp=0.129, perLevel=1.4, baseLevel=44, maxLevel=50}}}, -- Blast Wave 3
    [13020] = {kind="damage", school=3, level=52, cast=0, gcd=1.5, components={{low=355.8521, high=422.1479, sp=0.129, perLevel=1.6, baseLevel=52, maxLevel=58}}}, -- Blast Wave 4
    [13021] = {kind="damage", school=3, level=60, cast=0, gcd=1.5, components={{low=452.8151, high=533.1849, sp=0.129, perLevel=1.9, baseLevel=60, maxLevel=66}}}, -- Blast Wave 5
    [10] = {kind="damage", school=5, level=20, cast=0, gcd=1.5, channel=8, components={{low=24, high=24, ticks=8, sp=0.042, perLevel=0.1, baseLevel=20, maxLevel=25}}}, -- Blizzard 1
    [6141] = {kind="damage", school=5, level=28, cast=0, gcd=1.5, channel=8, components={{low=42, high=42, ticks=8, sp=0.042, perLevel=0.2, baseLevel=28, maxLevel=33}}}, -- Blizzard 2
    [8427] = {kind="damage", school=5, level=36, cast=0, gcd=1.5, channel=8, components={{low=62, high=62, ticks=8, sp=0.042, perLevel=0.2, baseLevel=36, maxLevel=41}}}, -- Blizzard 3
    [10185] = {kind="damage", school=5, level=44, cast=0, gcd=1.5, channel=8, components={{low=87, high=87, ticks=8, sp=0.042, perLevel=0.3, baseLevel=44, maxLevel=49}}}, -- Blizzard 4
    [10186] = {kind="damage", school=5, level=52, cast=0, gcd=1.5, channel=8, components={{low=114, high=114, ticks=8, sp=0.042, perLevel=0.3, baseLevel=52, maxLevel=57}}}, -- Blizzard 5
    [10187] = {kind="damage", school=5, level=60, cast=0, gcd=1.5, channel=8, components={{low=146, high=146, ticks=8, sp=0.042, perLevel=0.4, baseLevel=60, maxLevel=60}}}, -- Blizzard 6
    [23881] = {kind="damage", school=1, cast=0, gcd=1.5, components={{low=30, high=30, ap=0.45}}}, -- Bloodthirst 1
    [23892] = {kind="damage", school=1, cast=0, gcd=1.5, components={{low=37, high=37, ap=0.45}}}, -- Bloodthirst 2
    [23893] = {kind="damage", school=1, cast=0, gcd=1.5, components={{low=43, high=43, ap=0.45}}}, -- Bloodthirst 3
    [23894] = {kind="damage", school=1, cast=0, gcd=1.5, components={{low=48, high=48, ap=0.45}}}, -- Bloodthirst 4
    [1064] = {kind="heal", school=4, level=40, cast=2.5, gcd=1.5, components={{low=233.4884, high=268.5116, sp=0.714, perLevel=2.5, baseLevel=40, maxLevel=45}}}, -- Chain Heal 1
    [10622] = {kind="heal", school=4, level=46, cast=2.5, gcd=1.5, components={{low=311.8966, high=358.1034, sp=0.714, perLevel=2.8, baseLevel=46, maxLevel=51}}}, -- Chain Heal 2
    [10623] = {kind="heal", school=4, level=54, cast=2.5, gcd=1.5, components={{low=457.6102, high=522.3898, sp=0.714, perLevel=3.3, baseLevel=54, maxLevel=59}}}, -- Chain Heal 3
    [421] = {kind="damage", school=4, level=32, cast=2.5, gcd=1.5, components={{low=201.299, high=228.701, sp=0.714, perLevel=1.4, baseLevel=32, maxLevel=37}}}, -- Chain Lightning 1
    [930] = {kind="damage", school=4, level=40, cast=2.5, gcd=1.5, components={{low=327.8776, high=368.1224, sp=0.714, perLevel=2.2, baseLevel=40, maxLevel=45}}}, -- Chain Lightning 2
    [2860] = {kind="damage", school=4, level=48, cast=2.5, gcd=1.5, components={{low=403.4514, high=452.5486, sp=0.714, perLevel=2.7, baseLevel=48, maxLevel=53}}}, -- Chain Lightning 3
    [10605] = {kind="damage", school=4, level=56, cast=2.5, gcd=1.5, components={{low=481.6667, high=538.3333, sp=0.714, perLevel=3.3, baseLevel=56, maxLevel=61}}}, -- Chain Lightning 4
    [403629] = {kind="damage", school=3, schools={3, 4, 5, 6, 7}, ranked=false, cast=2.5, gcd=1.5, components={{low=5.22, high=6.62, sp=0.714, curve={6.568597, 0.672028, 0.031721}}}}, -- Chaos Bolt
    [1277331] = {kind="damage", school=2, level=20, cast=0, gcd=1.5, components={{low=43.24, high=48.76, sp=0.143}}}, -- Chastise 1
    [1277332] = {kind="damage", school=2, level=30, cast=0, gcd=1.5, components={{low=87.42, high=98.58, sp=0.143}}}, -- Chastise 2
    [1277333] = {kind="damage", school=2, level=40, cast=0, gcd=1.5, components={{low=131.6, high=148.4, sp=0.143}}}, -- Chastise 3
    [1277334] = {kind="damage", school=2, level=50, cast=0, gcd=1.5, components={{low=201.16, high=226.84, sp=0.143}}}, -- Chastise 4
    [1277335] = {kind="damage", school=2, level=60, cast=0, gcd=1.5, components={{low=271.66, high=306.34, sp=0.143}}}, -- Chastise 5
    [401946] = {kind="heal", school=2, ranked=false, cast=0, gcd=1.5, components={{low=1.3, high=1.44, sp=0.214, curve={38.25838, 0.904195, 0.161311}}}}, -- Circle of Healing
    [120] = {kind="damage", school=5, level=26, cast=0, gcd=1.5, components={{low=92.29126, high=101.7087, sp=0.129, perLevel=0.8, baseLevel=26, maxLevel=31}}}, -- Cone of Cold 1
    [8492] = {kind="damage", school=5, level=34, cast=0, gcd=1.5, components={{low=137.4118, high=150.5882, sp=0.129, perLevel=1, baseLevel=34, maxLevel=39}}}, -- Cone of Cold 2
    [10159] = {kind="damage", school=5, level=42, cast=0, gcd=1.5, components={{low=194.4225, high=213.5775, sp=0.129, perLevel=1.2, baseLevel=42, maxLevel=47}}}, -- Cone of Cold 3
    [10160] = {kind="damage", school=5, level=50, cast=0, gcd=1.5, components={{low=254.4693, high=279.5307, sp=0.129, perLevel=1.3, baseLevel=50, maxLevel=55}}}, -- Cone of Cold 4
    [10161] = {kind="damage", school=5, level=58, cast=0, gcd=1.5, components={{low=325.4286, high=354.5714, sp=0.129, perLevel=1.5, baseLevel=58, maxLevel=63}}}, -- Cone of Cold 5
    [172] = {kind="damage", school=6, level=4, cast=2, gcd=1.5, damageDuration=12, components={{low=10, high=10, ticks=4, sp=0.2}}}, -- Corruption 1
    [6222] = {kind="damage", school=6, level=14, cast=2, gcd=1.5, damageDuration=15, components={{low=13, high=13, ticks=5, sp=0.2}}}, -- Corruption 2
    [6223] = {kind="damage", school=6, level=24, cast=2, gcd=1.5, damageDuration=18, components={{low=22, high=22, ticks=6, sp=0.2}}}, -- Corruption 3
    [7648] = {kind="damage", school=6, level=34, cast=2, gcd=1.5, damageDuration=18, components={{low=28, high=28, ticks=6, sp=0.2}}}, -- Corruption 4
    [11671] = {kind="damage", school=6, level=44, cast=2, gcd=1.5, damageDuration=18, components={{low=40, high=40, ticks=6, sp=0.2}}}, -- Corruption 5
    [11672] = {kind="damage", school=6, level=54, cast=2, gcd=1.5, damageDuration=18, components={{low=57, high=57, ticks=6, sp=0.2}}}, -- Corruption 6
    [25311] = {kind="damage", school=6, level=60, cast=2, gcd=1.5, damageDuration=18, components={{low=73, high=73, ticks=6, sp=0.2}}}, -- Corruption 7
    [6789] = {kind="damage", school=6, level=42, cast=0, gcd=1.5, components={{low=272, high=272, sp=0.214, perLevel=2.2, baseLevel=42, maxLevel=48, leech=1}}}, -- Death Coil 1
    [17925] = {kind="damage", school=6, level=50, cast=0, gcd=1.5, components={{low=359, high=359, sp=0.214, perLevel=2.6, baseLevel=50, maxLevel=56, leech=1}}}, -- Death Coil 2
    [17926] = {kind="damage", school=6, level=58, cast=0, gcd=1.5, components={{low=454, high=454, sp=0.214, perLevel=3, baseLevel=58, maxLevel=64, leech=1}}}, -- Death Coil 3
    [13908] = {kind="heal", school=2, level=10, cast=0, gcd=1.5, components={{low=131.3553, high=166.6447, sp=0.429, perLevel=2.4, baseLevel=10, maxLevel=16}}}, -- Desperate Prayer 1
    [19236] = {kind="heal", school=2, level=18, cast=0, gcd=1.5, components={{low=246.898, high=305.102, sp=0.429, perLevel=3.4, baseLevel=18, maxLevel=24}}}, -- Desperate Prayer 2
    [19238] = {kind="heal", school=2, level=26, cast=0, gcd=1.5, components={{low=413.5879, high=502.4121, sp=0.429, perLevel=4.5, baseLevel=26, maxLevel=32}}}, -- Desperate Prayer 3
    [19240] = {kind="heal", school=2, level=34, cast=0, gcd=1.5, components={{low=539.9074, high=650.0926, sp=0.429, perLevel=5.3, baseLevel=34, maxLevel=40}}}, -- Desperate Prayer 4
    [19241] = {kind="heal", school=2, level=42, cast=0, gcd=1.5, components={{low=781.0766, high=930.9234, sp=0.429, perLevel=6.4, baseLevel=42, maxLevel=48}}}, -- Desperate Prayer 5
    [19242] = {kind="heal", school=2, level=50, cast=0, gcd=1.5, components={{low=1046.087, high=1239.913, sp=0.429, perLevel=7.4, baseLevel=50, maxLevel=56}}}, -- Desperate Prayer 6
    [19243] = {kind="heal", school=2, level=58, cast=0, gcd=1.5, components={{low=1268.948, high=1497.052, sp=0.429, perLevel=8.2, baseLevel=58, maxLevel=64}}}, -- Desperate Prayer 7
    [2944] = {kind="damage", school=6, level=20, cast=0, gcd=1.5, damageDuration=24, healDuration=24, components={{low=16, high=16, ticks=8, sp=0.1, leech=1}}}, -- Devouring Plague 1
    [19276] = {kind="damage", school=6, level=28, cast=0, gcd=1.5, damageDuration=24, healDuration=24, components={{low=29, high=29, ticks=8, sp=0.1, leech=1}}}, -- Devouring Plague 2
    [19277] = {kind="damage", school=6, level=36, cast=0, gcd=1.5, damageDuration=24, healDuration=24, components={{low=43, high=43, ticks=8, sp=0.1, leech=1}}}, -- Devouring Plague 3
    [19278] = {kind="damage", school=6, level=44, cast=0, gcd=1.5, damageDuration=24, healDuration=24, components={{low=61, high=61, ticks=8, sp=0.1, leech=1}}}, -- Devouring Plague 4
    [19279] = {kind="damage", school=6, level=52, cast=0, gcd=1.5, damageDuration=24, healDuration=24, components={{low=82, high=82, ticks=8, sp=0.1, leech=1}}}, -- Devouring Plague 5
    [19280] = {kind="damage", school=6, level=60, cast=0, gcd=1.5, damageDuration=24, healDuration=24, components={{low=106, high=106, ticks=8, sp=0.1, leech=1}}}, -- Devouring Plague 6
    [1277370] = {kind="heal", school=2, level=10, cast=0, gcd=1.5, components={{low=131.3553, high=166.6447, sp=0.429, perLevel=2.4, baseLevel=10, maxLevel=16}}}, -- Divine Grace 1
    [1277371] = {kind="heal", school=2, level=18, cast=0, gcd=1.5, components={{low=246.898, high=305.102, sp=0.429, perLevel=3.4, baseLevel=18, maxLevel=24}}}, -- Divine Grace 2
    [1277372] = {kind="heal", school=2, level=26, cast=0, gcd=1.5, components={{low=413.5879, high=502.4121, sp=0.429, perLevel=4.5, baseLevel=26, maxLevel=32}}}, -- Divine Grace 3
    [1277374] = {kind="heal", school=2, level=34, cast=0, gcd=1.5, components={{low=539.9075, high=650.0925, sp=0.429, perLevel=5.3, baseLevel=34, maxLevel=40}}}, -- Divine Grace 4
    [1277376] = {kind="heal", school=2, level=42, cast=0, gcd=1.5, components={{low=781.0765, high=930.9235, sp=0.429, perLevel=6.4, baseLevel=42, maxLevel=48}}}, -- Divine Grace 5
    [1277377] = {kind="heal", school=2, level=50, cast=0, gcd=1.5, components={{low=1046.087, high=1239.913, sp=0.429, perLevel=7.4, baseLevel=50, maxLevel=56}}}, -- Divine Grace 6
    [1277378] = {kind="heal", school=2, level=58, cast=0, gcd=1.5, components={{low=1268.948, high=1497.052, sp=0.429, perLevel=8.2, baseLevel=58, maxLevel=64}}}, -- Divine Grace 7
    [458856] = {kind="heal", school=2, ranked=false, cast=2.5, gcd=1.5, components={{low=3.55, high=3.93, sp=1, curve={38.25838, 0.904195, 0.161311}}}}, -- Divine Light
    [689] = {kind="damage", school=6, level=14, cast=0, gcd=1.5, channel=5, components={{low=10, high=10, ticks=5, sp=0.1, leech=1}}}, -- Drain Life 1
    [699] = {kind="damage", school=6, level=22, cast=0, gcd=1.5, channel=5, components={{low=14, high=14, ticks=5, sp=0.1, leech=1}}}, -- Drain Life 2
    [709] = {kind="damage", school=6, level=30, cast=0, gcd=1.5, channel=5, components={{low=22, high=22, ticks=5, sp=0.1, leech=1}}}, -- Drain Life 3
    [7651] = {kind="damage", school=6, level=38, cast=0, gcd=1.5, channel=5, components={{low=28, high=28, ticks=5, sp=0.1, leech=1}}}, -- Drain Life 4
    [11699] = {kind="damage", school=6, level=46, cast=0, gcd=1.5, channel=5, components={{low=39, high=39, ticks=5, sp=0.1, leech=1}}}, -- Drain Life 5
    [11700] = {kind="damage", school=6, level=54, cast=0, gcd=1.5, channel=5, components={{low=51, high=51, ticks=5, sp=0.1, leech=1}}}, -- Drain Life 6
    [403677] = {kind="damage", school=6, level=14, cast=0, gcd=1.5, damageDuration=15, healDuration=15, components={{low=10, high=10, ticks=15, sp=0.078, leech=1.5}}}, -- Drain Life 1
    [403685] = {kind="damage", school=6, level=22, cast=0, gcd=1.5, damageDuration=15, healDuration=15, components={{low=17, high=17, ticks=15, sp=0.1, leech=1.5}}}, -- Drain Life 2
    [403686] = {kind="damage", school=6, level=30, cast=0, gcd=1.5, damageDuration=15, healDuration=15, components={{low=29, high=29, ticks=15, sp=0.1, leech=1.5}}}, -- Drain Life 3
    [403687] = {kind="damage", school=6, level=38, cast=0, gcd=1.5, damageDuration=15, healDuration=15, components={{low=41, high=41, ticks=15, sp=0.1, leech=1.5}}}, -- Drain Life 4
    [403688] = {kind="damage", school=6, level=46, cast=0, gcd=1.5, damageDuration=15, healDuration=15, components={{low=55, high=55, ticks=15, sp=0.1, leech=1.5}}}, -- Drain Life 5
    [403689] = {kind="damage", school=6, level=54, cast=0, gcd=1.5, damageDuration=15, healDuration=15, components={{low=71, high=71, ticks=15, sp=0.1, leech=1.5}}}, -- Drain Life 6
    [1120] = {kind="damage", school=6, level=10, cast=0, gcd=1.5, channel=15, components={{low=17, high=17, ticks=5, sp=0.1}}}, -- Drain Soul 1
    [8288] = {kind="damage", school=6, level=24, cast=0, gcd=1.5, channel=15, components={{low=34, high=34, ticks=5, sp=0.1}}}, -- Drain Soul 2
    [8289] = {kind="damage", school=6, level=38, cast=0, gcd=1.5, channel=15, components={{low=54, high=54, ticks=5, sp=0.1}}}, -- Drain Soul 3
    [11675] = {kind="damage", school=6, level=52, cast=0, gcd=1.5, channel=15, components={{low=84, high=84, ticks=5, sp=0.1}}}, -- Drain Soul 4
    [8042] = {kind="damage", school=4, level=4, cast=0, gcd=1.5, components={{low=18.88889, high=21.11111, sp=0.386, perLevel=0.5, baseLevel=4, maxLevel=9}}}, -- Earth Shock 1
    [8044] = {kind="damage", school=4, level=8, cast=0, gcd=1.5, components={{low=34.90909, high=37.09091, sp=0.386, perLevel=0.7, baseLevel=8, maxLevel=13}}}, -- Earth Shock 2
    [8045] = {kind="damage", school=4, level=14, cast=0, gcd=1.5, components={{low=64.83871, high=69.16129, sp=0.386, perLevel=0.9, baseLevel=14, maxLevel=19}}}, -- Earth Shock 3
    [8046] = {kind="damage", school=4, level=24, cast=0, gcd=1.5, components={{low=125.7724, high=134.2276, sp=0.386, perLevel=1.1, baseLevel=24, maxLevel=29}}}, -- Earth Shock 4
    [10412] = {kind="damage", school=4, level=36, cast=0, gcd=1.5, components={{low=234.6983, high=249.3017, sp=0.386, perLevel=1.3, baseLevel=36, maxLevel=41}}}, -- Earth Shock 5
    [10413] = {kind="damage", school=4, level=48, cast=0, gcd=1.5, components={{low=371.6135, high=394.3865, sp=0.386, perLevel=1.6, baseLevel=48, maxLevel=53}}}, -- Earth Shock 6
    [10414] = {kind="damage", school=4, level=60, cast=0, gcd=1.5, components={{low=517, high=545, sp=0.386, perLevel=3.4, baseLevel=60, maxLevel=65}}}, -- Earth Shock 7
    [339] = {kind="damage", school=4, level=8, cast=1.5, gcd=1.5, damageDuration=12, components={{low=5, high=5, ticks=4, sp=0.06}}}, -- Entangling Roots 1
    [1062] = {kind="damage", school=4, level=18, cast=1.5, gcd=1.5, damageDuration=15, components={{low=9, high=9, ticks=5, sp=0.06}}}, -- Entangling Roots 2
    [5195] = {kind="damage", school=4, level=28, cast=1.5, gcd=1.5, damageDuration=18, components={{low=12, high=12, ticks=6, sp=0.06}}}, -- Entangling Roots 3
    [5196] = {kind="damage", school=4, level=38, cast=1.5, gcd=1.5, damageDuration=21, components={{low=16, high=16, ticks=7, sp=0.06}}}, -- Entangling Roots 4
    [9852] = {kind="damage", school=4, level=48, cast=1.5, gcd=1.5, damageDuration=24, components={{low=21, high=21, ticks=8, sp=0.06}}}, -- Entangling Roots 5
    [9853] = {kind="damage", school=4, level=58, cast=1.5, gcd=1.5, damageDuration=27, components={{low=26, high=26, ticks=9, sp=0.06}}}, -- Entangling Roots 6
    [879] = {kind="damage", school=2, level=20, cast=0, gcd=1.5, components={{low=73.73333, high=84.26667, sp=0.429, perLevel=1.2, baseLevel=20, maxLevel=25}}}, -- Exorcism 1
    [5614] = {kind="damage", school=2, level=28, cast=0, gcd=1.5, components={{low=132.2963, high=149.7037, sp=0.429, perLevel=1.6, baseLevel=28, maxLevel=33}}}, -- Exorcism 2
    [5615] = {kind="damage", school=2, level=36, cast=0, gcd=1.5, components={{low=189.7576, high=214.2424, sp=0.429, perLevel=2, baseLevel=36, maxLevel=41}}}, -- Exorcism 3
    [10312] = {kind="damage", school=2, level=44, cast=0, gcd=1.5, components={{low=273.8824, high=308.1176, sp=0.429, perLevel=2.4, baseLevel=44, maxLevel=49}}}, -- Exorcism 4
    [10313] = {kind="damage", school=2, level=52, cast=0, gcd=1.5, components={{low=362.7692, high=405.2308, sp=0.429, perLevel=2.8, baseLevel=52, maxLevel=57}}}, -- Exorcism 5
    [10314] = {kind="damage", school=2, level=60, cast=0, gcd=1.5, components={{low=474.7378, high=529.2622, sp=0.429, perLevel=3.2, baseLevel=60, maxLevel=65}}}, -- Exorcism 6
    [415068] = {kind="damage", school=2, level=20, cast=0, gcd=1.5, components={{low=84, high=96, sp=0.429, perLevel=1.2, baseLevel=0, maxLevel=25}}}, -- Exorcism 1
    [415069] = {kind="damage", school=2, level=28, cast=0, gcd=1.5, components={{low=152, high=172, sp=0.429, perLevel=1.6, baseLevel=0, maxLevel=33}}}, -- Exorcism 2
    [415070] = {kind="damage", school=2, level=36, cast=0, gcd=1.5, components={{low=217, high=245, sp=0.429, perLevel=2, baseLevel=0, maxLevel=41}}}, -- Exorcism 3
    [415071] = {kind="damage", school=2, level=44, cast=0, gcd=1.5, components={{low=304, high=342, sp=0.429, perLevel=2.4, baseLevel=0, maxLevel=49}}}, -- Exorcism 4
    [415072] = {kind="damage", school=2, level=52, cast=0, gcd=1.5, components={{low=393, high=439, sp=0.429, perLevel=2.8, baseLevel=0, maxLevel=57}}}, -- Exorcism 5
    [415073] = {kind="damage", school=2, level=60, cast=0, gcd=1.5, components={{low=505, high=563, sp=0.429, perLevel=3.2, baseLevel=0, maxLevel=65}}}, -- Exorcism 6
    [2136] = {kind="damage", school=3, level=6, cast=0, gcd=1.5, components={{low=24, high=32, sp=0.429, perLevel=0.6, baseLevel=6, maxLevel=11}}}, -- Fire Blast 1
    [2137] = {kind="damage", school=3, level=14, cast=0, gcd=1.5, components={{low=51.65625, high=64.34375, sp=0.429, perLevel=1, baseLevel=14, maxLevel=19}}}, -- Fire Blast 2
    [2138] = {kind="damage", school=3, level=22, cast=0, gcd=1.5, components={{low=89.56522, high=110.4348, sp=0.429, perLevel=1.4, baseLevel=22, maxLevel=27}}}, -- Fire Blast 3
    [8412] = {kind="damage", school=3, level=30, cast=0, gcd=1.5, components={{low=148.0216, high=177.9784, sp=0.429, perLevel=1.8, baseLevel=30, maxLevel=35}}}, -- Fire Blast 4
    [8413] = {kind="damage", school=3, level=38, cast=0, gcd=1.5, components={{low=214.7068, high=257.2932, sp=0.429, perLevel=2.2, baseLevel=38, maxLevel=43}}}, -- Fire Blast 5
    [10197] = {kind="damage", school=3, level=46, cast=0, gcd=1.5, components={{low=302.7328, high=359.2672, sp=0.429, perLevel=2.6, baseLevel=46, maxLevel=51}}}, -- Fire Blast 6
    [10199] = {kind="damage", school=3, level=54, cast=0, gcd=1.5, components={{low=401.6553, high=474.3447, sp=0.429, perLevel=3, baseLevel=54, maxLevel=59}}}, -- Fire Blast 7
    [400616] = {kind="damage", school=3, level=22, cast=0, gcd=0, components={{low=103, high=127, sp=0.429, perLevel=1.4, baseLevel=0, maxLevel=27}}}, -- Fire Blast 3
    [400618] = {kind="damage", school=3, level=6, cast=0, gcd=0, components={{low=24, high=32, sp=0.204, perLevel=0.6, baseLevel=0, maxLevel=11}}}, -- Fire Blast 1
    [400619] = {kind="damage", school=3, level=14, cast=0, gcd=0, components={{low=57, high=71, sp=0.332, perLevel=1, baseLevel=0, maxLevel=19}}}, -- Fire Blast 2
    [400620] = {kind="damage", school=3, level=30, cast=0, gcd=0, components={{low=168, high=202, sp=0.429, perLevel=1.8, baseLevel=0, maxLevel=35}}}, -- Fire Blast 4
    [400621] = {kind="damage", school=3, level=38, cast=0, gcd=0, components={{low=242, high=290, sp=0.429, perLevel=2.2, baseLevel=0, maxLevel=43}}}, -- Fire Blast 5
    [400622] = {kind="damage", school=3, level=46, cast=0, gcd=0, components={{low=332, high=394, sp=0.429, perLevel=2.6, baseLevel=0, maxLevel=51}}}, -- Fire Blast 6
    [400623] = {kind="damage", school=3, level=54, cast=0, gcd=0, components={{low=431, high=509, sp=0.429, perLevel=3, baseLevel=0, maxLevel=59}}}, -- Fire Blast 7
    [543] = {kind="absorb", school=3, level=20, cast=0, gcd=1.5, components={{low=162, high=162}}}, -- Fire Ward 1
    [8457] = {kind="absorb", school=3, level=30, cast=0, gcd=1.5, components={{low=285, high=285}}}, -- Fire Ward 2
    [8458] = {kind="absorb", school=3, level=40, cast=0, gcd=1.5, components={{low=463, high=463}}}, -- Fire Ward 3
    [10223] = {kind="absorb", school=3, level=50, cast=0, gcd=1.5, components={{low=668, high=668}}}, -- Fire Ward 4
    [10225] = {kind="absorb", school=3, level=60, cast=0, gcd=1.5, components={{low=913, high=913}}}, -- Fire Ward 5
    [412214] = {kind="absorb", school=3, level=20, cast=0, gcd=1.5, components={{low=330, high=330}}}, -- Fire Ward 1
    [412218] = {kind="absorb", school=3, level=30, cast=0, gcd=1.5, components={{low=580, high=580}}}, -- Fire Ward 2
    [412230] = {kind="absorb", school=3, level=40, cast=0, gcd=1.5, components={{low=940, high=940}}}, -- Fire Ward 3
    [412231] = {kind="absorb", school=3, level=50, cast=0, gcd=1.5, components={{low=1350, high=1350}}}, -- Fire Ward 4
    [412232] = {kind="absorb", school=3, level=60, cast=0, gcd=1.5, components={{low=1840, high=1840}}}, -- Fire Ward 5
    [133] = {kind="damage", school=3, level=1, cast=1.5, gcd=1.5, damageDuration=4, components={{low=14, high=22, sp=0.429, perLevel=0.2, baseLevel=1, maxLevel=5}, {low=1, high=1, ticks=2}}}, -- Fireball 1
    [143] = {kind="damage", school=3, level=6, cast=2, gcd=1.5, damageDuration=6, components={{low=26.10526, high=37.89474, sp=0.571, perLevel=0.3, baseLevel=6, maxLevel=10}, {low=1, high=1, ticks=3}}}, -- Fireball 2
    [145] = {kind="damage", school=3, level=12, cast=2.5, gcd=1.5, damageDuration=6, components={{low=42.90476, high=59.09524, sp=0.714, perLevel=0.6, baseLevel=12, maxLevel=16}, {low=2, high=2, ticks=3}}}, -- Fireball 3
    [3140] = {kind="damage", school=3, level=18, cast=3, gcd=1.5, damageDuration=8, components={{low=64.68, high=89.32, sp=0.857, perLevel=0.9, baseLevel=18, maxLevel=22}, {low=3, high=3, ticks=4}}}, -- Fireball 4
    [8400] = {kind="damage", school=3, level=24, cast=3.5, gcd=1.5, damageDuration=8, components={{low=102.3313, high=137.6687, sp=1, perLevel=1.4, baseLevel=24, maxLevel=28}, {low=4, high=4, ticks=4}}}, -- Fireball 5
    [8401] = {kind="damage", school=3, level=30, cast=3.5, gcd=1.5, damageDuration=8, components={{low=131.2371, high=174.7629, sp=1, perLevel=1.8, baseLevel=30, maxLevel=34}, {low=6, high=6, ticks=4}}}, -- Fireball 6
    [8402] = {kind="damage", school=3, level=36, cast=3.5, gcd=1.5, damageDuration=8, components={{low=161.6441, high=212.3559, sp=1, perLevel=2.3, baseLevel=36, maxLevel=40}, {low=6, high=6, ticks=4}}}, -- Fireball 7
    [10148] = {kind="damage", school=3, level=42, cast=3.5, gcd=1.5, damageDuration=8, components={{low=204.1803, high=265.8197, sp=1, perLevel=2.2, baseLevel=42, maxLevel=46}, {low=8, high=8, ticks=4}}}, -- Fireball 8
    [10149] = {kind="damage", school=3, level=48, cast=3.5, gcd=1.5, damageDuration=8, components={{low=261.9154, high=338.0846, sp=1, perLevel=2.4, baseLevel=48, maxLevel=52}, {low=10, high=10, ticks=4}}}, -- Fireball 9
    [10150] = {kind="damage", school=3, level=54, cast=3.5, gcd=1.5, damageDuration=8, components={{low=327.7675, high=420.2325, sp=1, perLevel=2.7, baseLevel=54, maxLevel=58}, {low=12, high=12, ticks=4}}}, -- Fireball 10
    [10151] = {kind="damage", school=3, level=60, cast=3.5, gcd=1.5, damageDuration=8, components={{low=396.569, high=505.431, sp=1, perLevel=3, baseLevel=60, maxLevel=64}, {low=14, high=14, ticks=4}}}, -- Fireball 11
    [25306] = {kind="damage", school=3, level=60, cast=3.5, gcd=1.5, damageDuration=8, components={{low=424.5841, high=541.4159, sp=1, perLevel=3, baseLevel=60, maxLevel=64}, {low=15, high=15, ticks=4}}}, -- Fireball 12
    [8050] = {kind="damage", school=3, level=10, cast=0, gcd=1.5, damageDuration=12, components={{low=25, high=25, sp=0.214, perLevel=0.8, baseLevel=10, maxLevel=15}, {low=7, high=7, ticks=4, sp=0.1}}}, -- Flame Shock 1
    [8052] = {kind="damage", school=3, level=18, cast=0, gcd=1.5, damageDuration=12, components={{low=51, high=51, sp=0.214, perLevel=1, baseLevel=18, maxLevel=23}, {low=12, high=12, ticks=4, sp=0.1}}}, -- Flame Shock 2
    [8053] = {kind="damage", school=3, level=28, cast=0, gcd=1.5, damageDuration=12, components={{low=95, high=95, sp=0.214, perLevel=1.2, baseLevel=28, maxLevel=33}, {low=24, high=24, ticks=4, sp=0.1}}}, -- Flame Shock 3
    [10447] = {kind="damage", school=3, level=40, cast=0, gcd=1.5, damageDuration=12, components={{low=164, high=164, sp=0.214, perLevel=1.4, baseLevel=40, maxLevel=45}, {low=42, high=42, ticks=4, sp=0.1}}}, -- Flame Shock 4
    [10448] = {kind="damage", school=3, level=52, cast=0, gcd=1.5, damageDuration=12, components={{low=245, high=245, sp=0.214, perLevel=1.7, baseLevel=52, maxLevel=57}, {low=64, high=64, ticks=4, sp=0.1}}}, -- Flame Shock 5
    [29228] = {kind="damage", school=3, level=60, cast=0, gcd=1.5, damageDuration=12, components={{low=292, high=292, sp=0.214, perLevel=3.8, baseLevel=60, maxLevel=67}, {low=80, high=80, ticks=4, sp=0.1}}}, -- Flame Shock 6
    [2120] = {kind="damage", school=3, level=16, cast=3, gcd=1.5, damageDuration=8, components={{low=52, high=68, sp=0.157, perLevel=0.6, baseLevel=16, maxLevel=21}, {low=11, high=11, ticks=4, sp=0.032}}}, -- Flamestrike 1
    [2121] = {kind="damage", school=3, level=24, cast=3, gcd=1.5, damageDuration=8, components={{low=96, high=122, sp=0.157, perLevel=0.8, baseLevel=24, maxLevel=29}, {low=21, high=21, ticks=4, sp=0.032}}}, -- Flamestrike 2
    [8422] = {kind="damage", school=3, level=32, cast=3, gcd=1.5, damageDuration=8, components={{low=154, high=192, sp=0.157, perLevel=1, baseLevel=32, maxLevel=37}, {low=33, high=33, ticks=4, sp=0.032}}}, -- Flamestrike 3
    [8423] = {kind="damage", school=3, level=40, cast=3, gcd=1.5, damageDuration=8, components={{low=220, high=272, sp=0.157, perLevel=1.3, baseLevel=40, maxLevel=45}, {low=47, high=47, ticks=4, sp=0.032}}}, -- Flamestrike 4
    [10215] = {kind="damage", school=3, level=48, cast=3, gcd=1.5, damageDuration=8, components={{low=291, high=359, sp=0.157, perLevel=1.5, baseLevel=48, maxLevel=53}, {low=64, high=64, ticks=4, sp=0.032}}}, -- Flamestrike 5
    [10216] = {kind="damage", school=3, level=56, cast=3, gcd=1.5, damageDuration=8, components={{low=375, high=459, sp=0.157, perLevel=1.7, baseLevel=56, maxLevel=61}, {low=83, high=83, ticks=4, sp=0.032}}}, -- Flamestrike 6
    [2061] = {kind="heal", school=2, level=20, cast=1.5, gcd=1.5, components={{low=174.1488, high=213.8512, sp=0.429, perLevel=1.9, baseLevel=20, maxLevel=25}}}, -- Flash Heal 1
    [9472] = {kind="heal", school=2, level=26, cast=1.5, gcd=1.5, components={{low=224.6224, high=273.3776, sp=0.429, perLevel=2.2, baseLevel=26, maxLevel=31}}}, -- Flash Heal 2
    [9473] = {kind="heal", school=2, level=32, cast=1.5, gcd=1.5, components={{low=283.4, high=340.6, sp=0.429, perLevel=2.5, baseLevel=32, maxLevel=37}}}, -- Flash Heal 3
    [9474] = {kind="heal", school=2, level=38, cast=1.5, gcd=1.5, components={{low=348.9749, high=417.0251, sp=0.429, perLevel=2.8, baseLevel=38, maxLevel=43}}}, -- Flash Heal 4
    [10915] = {kind="heal", school=2, level=44, cast=1.5, gcd=1.5, components={{low=463.1852, high=550.8148, sp=0.429, perLevel=3.3, baseLevel=44, maxLevel=49}}}, -- Flash Heal 5
    [10916] = {kind="heal", school=2, level=50, cast=1.5, gcd=1.5, components={{low=589.1136, high=698.8864, sp=0.429, perLevel=3.7, baseLevel=50, maxLevel=55}}}, -- Flash Heal 6
    [10917] = {kind="heal", school=2, level=56, cast=1.5, gcd=1.5, components={{low=756.9492, high=893.0508, sp=0.429, perLevel=4.2, baseLevel=56, maxLevel=61}}}, -- Flash Heal 7
    [19750] = {kind="heal", school=2, level=20, cast=1.5, gcd=1.5, components={{low=42.56716, high=49.43284, sp=0.429, perLevel=1, baseLevel=20, maxLevel=25}}}, -- Flash of Light 1
    [19939] = {kind="heal", school=2, level=26, cast=1.5, gcd=1.5, components={{low=61.51456, high=70.48544, sp=0.429, perLevel=1.3, baseLevel=26, maxLevel=31}}}, -- Flash of Light 2
    [19940] = {kind="heal", school=2, level=34, cast=1.5, gcd=1.5, components={{low=95.0974, high=106.9026, sp=0.429, perLevel=1.6, baseLevel=34, maxLevel=39}}}, -- Flash of Light 3
    [19941] = {kind="heal", school=2, level=42, cast=1.5, gcd=1.5, components={{low=142.3301, high=159.6699, sp=0.429, perLevel=1.9, baseLevel=42, maxLevel=47}}}, -- Flash of Light 4
    [19942] = {kind="heal", school=2, level=50, cast=1.5, gcd=1.5, components={{low=210.3922, high=235.6078, sp=0.429, perLevel=2.2, baseLevel=50, maxLevel=55}}}, -- Flash of Light 5
    [19943] = {kind="heal", school=2, level=58, cast=1.5, gcd=1.5, components={{low=286.3058, high=319.6942, sp=0.429, perLevel=2.6, baseLevel=58, maxLevel=63}}}, -- Flash of Light 6
    [122] = {kind="damage", school=5, level=10, cast=0, gcd=1.5, components={{low=19, high=21, sp=0.029, perLevel=0.5, baseLevel=10, maxLevel=15}}}, -- Frost Nova 1
    [865] = {kind="damage", school=5, level=26, cast=0, gcd=1.5, components={{low=32.05714, high=35.94286, sp=0.029, perLevel=0.5, baseLevel=26, maxLevel=31}}}, -- Frost Nova 2
    [6131] = {kind="damage", school=5, level=40, cast=0, gcd=1.5, components={{low=50.10909, high=55.89091, sp=0.029, perLevel=0.5, baseLevel=40, maxLevel=45}}}, -- Frost Nova 3
    [10230] = {kind="damage", school=5, level=54, cast=0, gcd=1.5, components={{low=69.10667, high=76.89333, sp=0.029, perLevel=0.5, baseLevel=54, maxLevel=59}}}, -- Frost Nova 4
    [8056] = {kind="damage", school=5, level=20, cast=0, gcd=1.5, components={{low=94.80435, high=101.1957, sp=0.386, perLevel=0.9, baseLevel=20, maxLevel=25}}}, -- Frost Shock 1
    [8058] = {kind="damage", school=5, level=34, cast=0, gcd=1.5, components={{low=214.7042, high=229.2958, sp=0.386, perLevel=1.3, baseLevel=34, maxLevel=39}}}, -- Frost Shock 2
    [10472] = {kind="damage", school=5, level=46, cast=0, gcd=1.5, components={{low=344.6501, high=365.3499, sp=0.386, perLevel=1.5, baseLevel=46, maxLevel=51}}}, -- Frost Shock 3
    [10473] = {kind="damage", school=5, level=58, cast=0, gcd=1.5, components={{low=491.832, high=520.168, sp=0.386, perLevel=1.8, baseLevel=58, maxLevel=63}}}, -- Frost Shock 4
    [6143] = {kind="absorb", school=5, level=22, absorbTalent=11189, cast=0, gcd=1.5, components={{low=162, high=162, sp=0.1, school=5, fullPower=true}}}, -- Frost Ward 1
    [8461] = {kind="absorb", school=5, level=32, absorbTalent=11189, cast=0, gcd=1.5, components={{low=284, high=284, sp=0.1, school=5, fullPower=true}}}, -- Frost Ward 2
    [8462] = {kind="absorb", school=5, level=42, absorbTalent=11189, cast=0, gcd=1.5, components={{low=463, high=463, sp=0.1, school=5, fullPower=true}}}, -- Frost Ward 3
    [10177] = {kind="absorb", school=5, level=52, absorbTalent=11189, cast=0, gcd=1.5, components={{low=668, high=668, sp=0.1, school=5, fullPower=true}}}, -- Frost Ward 4
    [28609] = {kind="absorb", school=5, level=60, absorbTalent=11189, cast=0, gcd=1.5, components={{low=913, high=913, sp=0.1, school=5, fullPower=true}}}, -- Frost Ward 5
    [412202] = {kind="absorb", school=5, level=22, cast=0, gcd=1.5, components={{low=330, high=330}}}, -- Frost Ward 1
    [412205] = {kind="absorb", school=5, level=32, cast=0, gcd=1.5, components={{low=580, high=580}}}, -- Frost Ward 2
    [412207] = {kind="absorb", school=5, level=42, cast=0, gcd=1.5, components={{low=940, high=940}}}, -- Frost Ward 3
    [412209] = {kind="absorb", school=5, level=52, cast=0, gcd=1.5, components={{low=1350, high=1350}}}, -- Frost Ward 4
    [412210] = {kind="absorb", school=5, level=60, cast=0, gcd=1.5, components={{low=1840, high=1840}}}, -- Frost Ward 5
    [116] = {kind="damage", school=5, level=4, cast=1.5, gcd=1.5, components={{low=18, high=20, sp=0.407, perLevel=0.2, baseLevel=4, maxLevel=8}}}, -- Frostbolt 1
    [205] = {kind="damage", school=5, level=8, cast=1.8, gcd=1.5, components={{low=27.24242, high=30.75758, sp=0.489, perLevel=0.3, baseLevel=8, maxLevel=12}}}, -- Frostbolt 2
    [837] = {kind="damage", school=5, level=14, cast=2.2, gcd=1.5, components={{low=43.44444, high=48.55556, sp=0.597, perLevel=0.5, baseLevel=14, maxLevel=18}}}, -- Frostbolt 3
    [7322] = {kind="damage", school=5, level=20, cast=2.6, gcd=1.5, components={{low=66.41026, high=73.58974, sp=0.706, perLevel=0.8, baseLevel=20, maxLevel=24}}}, -- Frostbolt 4
    [8406] = {kind="damage", school=5, level=26, cast=3, gcd=1.5, components={{low=99.27273, high=108.7273, sp=0.814, perLevel=1.3, baseLevel=26, maxLevel=30}}}, -- Frostbolt 5
    [8407] = {kind="damage", school=5, level=32, cast=3, gcd=1.5, components={{low=128.1099, high=139.8901, sp=0.814, perLevel=1.7, baseLevel=32, maxLevel=36}}}, -- Frostbolt 6
    [8408] = {kind="damage", school=5, level=38, cast=3, gcd=1.5, components={{low=173.3629, high=188.6371, sp=0.814, perLevel=2, baseLevel=38, maxLevel=42}}}, -- Frostbolt 7
    [10179] = {kind="damage", school=5, level=44, cast=3, gcd=1.5, components={{low=234.3684, high=253.6316, sp=0.814, perLevel=2.3, baseLevel=44, maxLevel=48}}}, -- Frostbolt 8
    [10180] = {kind="damage", school=5, level=50, cast=3, gcd=1.5, components={{low=295.4457, high=320.5543, sp=0.814, perLevel=2.6, baseLevel=50, maxLevel=54}}}, -- Frostbolt 9
    [10181] = {kind="damage", school=5, level=56, cast=3, gcd=1.5, components={{low=371.287, high=400.713, sp=0.814, perLevel=2.9, baseLevel=56, maxLevel=60}}}, -- Frostbolt 10
    [25304] = {kind="damage", school=5, level=60, cast=3, gcd=1.5, components={{low=457.243, high=492.757, sp=0.814, perLevel=3.2, baseLevel=60, maxLevel=64}}}, -- Frostbolt 11
    [401502] = {kind="damage", school=3, schools={3, 5}, level=40, cast=3, gcd=1.5, damageDuration=9, components={{low=92.32954, high=107.6705, sp=0.814, perLevel=1.3, baseLevel=40, maxLevel=48}, {low=9, high=9, ticks=3}}}, -- Frostfire Bolt 1
    [1237312] = {kind="damage", school=3, schools={3, 5}, level=50, cast=3, gcd=1.5, damageDuration=9, components={{low=168.0398, high=195.9602, sp=0.814, perLevel=1.7, baseLevel=50, maxLevel=58}, {low=13, high=13, ticks=3}}}, -- Frostfire Bolt 2
    [1237313] = {kind="damage", school=3, schools={3, 5}, level=60, cast=3, gcd=1.5, damageDuration=9, components={{low=269.6023, high=314.3977, sp=0.814, perLevel=2.1, baseLevel=60, maxLevel=68}, {low=19, high=19, ticks=3}}}, -- Frostfire Bolt 3
    [2060] = {kind="heal", school=2, level=40, cast=3, gcd=1.5, components={{low=793.6778, high=894.3222, sp=0.857, perLevel=5.1, baseLevel=40, maxLevel=45}}}, -- Greater Heal 1
    [10963] = {kind="heal", school=2, level=46, cast=3, gcd=1.5, components={{low=1035.891, high=1162.109, sp=0.857, perLevel=5.8, baseLevel=46, maxLevel=51}}}, -- Greater Heal 2
    [10964] = {kind="heal", school=2, level=52, cast=3, gcd=1.5, components={{low=1323.776, high=1482.224, sp=0.857, perLevel=6.6, baseLevel=52, maxLevel=57}}}, -- Greater Heal 3
    [10965] = {kind="heal", school=2, level=58, cast=3, gcd=1.5, components={{low=1684.562, high=1879.438, sp=0.857, perLevel=7.5, baseLevel=58, maxLevel=63}}}, -- Greater Heal 4
    [25314] = {kind="heal", school=2, level=60, cast=3, gcd=1.5, components={{low=1852.577, high=2067.423, sp=0.857, perLevel=8.1, baseLevel=60, maxLevel=65}}}, -- Greater Heal 5
    [24239] = {kind="damage", school=2, level=60, cast=1, gcd=1, components={{low=473.5698, high=522.4302, sp=0.429, perLevel=3.1, baseLevel=60, maxLevel=65}}}, -- Hammer of Wrath 3
    [24274] = {kind="damage", school=2, level=52, cast=1, gcd=1, components={{low=368.6, high=407.4, sp=0.429, perLevel=2.7, baseLevel=52, maxLevel=57}}}, -- Hammer of Wrath 2
    [24275] = {kind="damage", school=2, level=44, cast=1, gcd=1, components={{low=273.6, high=302.4, sp=0.429, perLevel=2.4, baseLevel=44, maxLevel=49}}}, -- Hammer of Wrath 1
    [2054] = {kind="heal", school=2, level=16, cast=3, gcd=1.5, components={{low=250.4717, high=289.5283, sp=0.857, perLevel=2, baseLevel=16, maxLevel=21}}}, -- Heal 1
    [2055] = {kind="heal", school=2, level=22, cast=3, gcd=1.5, components={{low=349.7283, high=400.2717, sp=0.857, perLevel=2.9, baseLevel=22, maxLevel=27}}}, -- Heal 2
    [6063] = {kind="heal", school=2, level=28, cast=3, gcd=1.5, components={{low=490.096, high=555.904, sp=0.857, perLevel=4, baseLevel=28, maxLevel=33}}}, -- Heal 3
    [6064] = {kind="heal", school=2, level=34, cast=3, gcd=1.5, components={{low=611.4934, high=690.5066, sp=0.857, perLevel=4.5, baseLevel=34, maxLevel=39}}}, -- Heal 4
    [415236] = {kind="heal", school=4, ranked=false, cast=2, gcd=1.5, healDuration=10, components={{low=0.15, high=0.15, ticks=10, sp=0.063, curve={29.8882, 0.690312, 0.136267}}}}, -- Healing Rain
    [5394] = {kind="heal", school=5, level=20, cast=0, gcd=1, healDuration=300, components={{low=5, high=5, ticks=150, sp=0.022}}}, -- Healing Stream Totem 1
    [6375] = {kind="heal", school=5, level=30, cast=0, gcd=1, healDuration=300, components={{low=6, high=6, ticks=150, sp=0.022}}}, -- Healing Stream Totem 2
    [6377] = {kind="heal", school=5, level=40, cast=0, gcd=1, healDuration=300, components={{low=7, high=7, ticks=150, sp=0.022}}}, -- Healing Stream Totem 3
    [10462] = {kind="heal", school=5, level=50, cast=0, gcd=1, healDuration=300, components={{low=9, high=9, ticks=150, sp=0.022}}}, -- Healing Stream Totem 4
    [10463] = {kind="heal", school=5, level=60, cast=0, gcd=1, healDuration=300, components={{low=11, high=11, ticks=150, sp=0.022}}}, -- Healing Stream Totem 5
    [5185] = {kind="heal", school=4, level=1, cast=1.5, gcd=1.5, components={{low=37, high=51, sp=0.429, perLevel=0.8, baseLevel=1, maxLevel=5}}}, -- Healing Touch 1
    [5186] = {kind="heal", school=4, level=8, cast=2, gcd=1.5, components={{low=88, high=112, sp=0.571, perLevel=1.3, baseLevel=8, maxLevel=13}}}, -- Healing Touch 2
    [5187] = {kind="heal", school=4, level=14, cast=2.5, gcd=1.5, components={{low=178.9726, high=223.0274, sp=0.714, perLevel=1.9, baseLevel=14, maxLevel=19}}}, -- Healing Touch 3
    [5188] = {kind="heal", school=4, level=20, cast=3, gcd=1.5, components={{low=325.2624, high=398.7376, sp=0.857, perLevel=2.7, baseLevel=20, maxLevel=25}}}, -- Healing Touch 4
    [5189] = {kind="heal", school=4, level=26, cast=3.5, gcd=1.5, components={{low=493.3839, high=598.6161, sp=1, perLevel=3.5, baseLevel=26, maxLevel=31}}}, -- Healing Touch 5
    [6778] = {kind="heal", school=4, level=32, cast=3.5, gcd=1.5, components={{low=641.313, high=772.687, sp=1, perLevel=4, baseLevel=32, maxLevel=37}}}, -- Healing Touch 6
    [8903] = {kind="heal", school=4, level=38, cast=3.5, gcd=1.5, components={{low=817.6342, high=978.3658, sp=1, perLevel=4.5, baseLevel=38, maxLevel=43}}}, -- Healing Touch 7
    [9758] = {kind="heal", school=4, level=44, cast=3.5, gcd=1.5, components={{low=1071.155, high=1274.845, sp=1, perLevel=5.2, baseLevel=44, maxLevel=49}}}, -- Healing Touch 8
    [9888] = {kind="heal", school=4, level=50, cast=3.5, gcd=1.5, components={{low=1387.836, high=1644.164, sp=1, perLevel=5.9, baseLevel=50, maxLevel=55}}}, -- Healing Touch 9
    [9889] = {kind="heal", school=4, level=56, cast=3.5, gcd=1.5, components={{low=1761.553, high=2078.447, sp=1, perLevel=6.6, baseLevel=56, maxLevel=61}}}, -- Healing Touch 10
    [25297] = {kind="heal", school=4, level=60, cast=3.5, gcd=1.5, components={{low=2138.61, high=2525.39, sp=1, perLevel=7.3, baseLevel=60, maxLevel=65}}}, -- Healing Touch 11
    [331] = {kind="heal", school=4, level=1, cast=1.5, gcd=1.5, components={{low=34, high=44, sp=0.429, perLevel=0.7, baseLevel=1, maxLevel=5}}}, -- Healing Wave 1
    [332] = {kind="heal", school=4, level=6, cast=2, gcd=1.5, components={{low=64, high=78, sp=0.571, perLevel=1, baseLevel=6, maxLevel=11}}}, -- Healing Wave 2
    [547] = {kind="heal", school=4, level=12, cast=2.5, gcd=1.5, components={{low=119.007, high=142.993, sp=0.714, perLevel=1.5, baseLevel=12, maxLevel=17}}}, -- Healing Wave 3
    [913] = {kind="heal", school=4, level=18, cast=3, gcd=1.5, components={{low=234.9589, high=277.0411, sp=0.857, perLevel=2.3, baseLevel=18, maxLevel=23}}}, -- Healing Wave 4
    [939] = {kind="heal", school=4, level=24, cast=3, gcd=1.5, components={{low=315.1765, high=368.8235, sp=0.857, perLevel=2.7, baseLevel=24, maxLevel=29}}}, -- Healing Wave 5
    [959] = {kind="heal", school=4, level=32, cast=3, gcd=1.5, components={{low=448.0553, high=519.9447, sp=0.857, perLevel=3.3, baseLevel=32, maxLevel=37}}}, -- Healing Wave 6
    [8005] = {kind="heal", school=4, level=40, cast=3, gcd=1.5, components={{low=636.01, high=733.99, sp=0.857, perLevel=3.9, baseLevel=40, maxLevel=45}}}, -- Healing Wave 7
    [10395] = {kind="heal", school=4, level=48, cast=3, gcd=1.5, components={{low=905.2418, high=1038.758, sp=0.857, perLevel=4.7, baseLevel=48, maxLevel=53}}}, -- Healing Wave 8
    [10396] = {kind="heal", school=4, level=56, cast=3, gcd=1.5, components={{low=1254.951, high=1433.049, sp=0.857, perLevel=5.5, baseLevel=56, maxLevel=61}}}, -- Healing Wave 9
    [25357] = {kind="heal", school=4, level=60, cast=3, gcd=1.5, components={{low=1507.954, high=1722.046, sp=0.857, perLevel=5.5, baseLevel=60, maxLevel=65}}}, -- Healing Wave 10
    [14914] = {kind="damage", school=2, level=20, cast=3.5, gcd=1.5, damageDuration=10, components={{low=47.86364, high=60.13636, sp=0.75, perLevel=1.3, baseLevel=20, maxLevel=24}, {low=4, high=4, ticks=5, sp=0.05}}}, -- Holy Fire 1
    [15261] = {kind="damage", school=2, level=60, cast=3.5, gcd=1.5, damageDuration=10, components={{low=183.6816, high=232.3184, sp=0.75, perLevel=2, baseLevel=60, maxLevel=66}, {low=15, high=15, ticks=5, sp=0.05}}}, -- Holy Fire 8
    [15262] = {kind="damage", school=2, level=24, cast=3.5, gcd=1.5, damageDuration=10, components={{low=56, high=70, sp=0.75, perLevel=1.4, baseLevel=24, maxLevel=30}, {low=5, high=5, ticks=5, sp=0.05}}}, -- Holy Fire 2
    [15263] = {kind="damage", school=2, level=30, cast=3.5, gcd=1.5, damageDuration=10, components={{low=70.87248, high=89.12752, sp=0.75, perLevel=1.5, baseLevel=30, maxLevel=36}, {low=6, high=6, ticks=5, sp=0.05}}}, -- Holy Fire 3
    [15264] = {kind="damage", school=2, level=36, cast=3.5, gcd=1.5, damageDuration=10, components={{low=81.17647, high=102.8235, sp=0.75, perLevel=1.5, baseLevel=36, maxLevel=42}, {low=7, high=7, ticks=5, sp=0.05}}}, -- Holy Fire 4
    [15265] = {kind="damage", school=2, level=42, cast=3.5, gcd=1.5, damageDuration=10, components={{low=93.61039, high=118.3896, sp=0.75, perLevel=1.5, baseLevel=42, maxLevel=48}, {low=9, high=9, ticks=5, sp=0.05}}}, -- Holy Fire 5
    [15266] = {kind="damage", school=2, level=48, cast=3.5, gcd=1.5, damageDuration=10, components={{low=122.5903, high=155.4097, sp=0.75, perLevel=1.7, baseLevel=48, maxLevel=54}, {low=10, high=10, ticks=5, sp=0.05}}}, -- Holy Fire 6
    [15267] = {kind="damage", school=2, level=54, cast=3.5, gcd=1.5, damageDuration=10, components={{low=152.4406, high=193.5594, sp=0.75, perLevel=1.9, baseLevel=54, maxLevel=60}, {low=13, high=13, ticks=5, sp=0.05}}}, -- Holy Fire 7
    [635] = {kind="heal", school=2, level=1, cast=2.5, gcd=1.5, components={{low=39, high=47, sp=0.714, perLevel=0.8, baseLevel=1, maxLevel=5}}}, -- Holy Light 1
    [639] = {kind="heal", school=2, level=6, cast=2.5, gcd=1.5, components={{low=76, high=90, sp=0.714, perLevel=1.1, baseLevel=6, maxLevel=11}}}, -- Holy Light 2
    [647] = {kind="heal", school=2, level=14, cast=2.5, gcd=1.5, components={{low=142.4566, high=167.5434, sp=0.714, perLevel=1.7, baseLevel=14, maxLevel=19}}}, -- Holy Light 3
    [1026] = {kind="heal", school=2, level=22, cast=2.5, gcd=1.5, components={{low=267.1772, high=306.8228, sp=0.714, perLevel=2.4, baseLevel=22, maxLevel=27}}}, -- Holy Light 4
    [1042] = {kind="heal", school=2, level=30, cast=2.5, gcd=1.5, components={{low=425.1571, high=478.8429, sp=0.714, perLevel=3.1, baseLevel=30, maxLevel=35}}}, -- Holy Light 5
    [3472] = {kind="heal", school=2, level=38, cast=2.5, gcd=1.5, components={{low=610.1597, high=681.8403, sp=0.714, perLevel=3.8, baseLevel=38, maxLevel=43}}}, -- Holy Light 6
    [10328] = {kind="heal", school=2, level=46, cast=2.5, gcd=1.5, components={{low=850.4054, high=947.5946, sp=0.714, perLevel=4.6, baseLevel=46, maxLevel=51}}}, -- Holy Light 7
    [10329] = {kind="heal", school=2, level=54, cast=2.5, gcd=1.5, components={{low=1151.391, high=1282.609, sp=0.714, perLevel=5.2, baseLevel=54, maxLevel=59}}}, -- Holy Light 8
    [25292] = {kind="heal", school=2, level=60, cast=2.5, gcd=1.5, components={{low=1495.357, high=1664.643, sp=0.714, perLevel=5.8, baseLevel=60, maxLevel=65}}}, -- Holy Light 9
    [15237] = {kind="heal", school=2, level=20, cast=0, gcd=1.5, components={{kind="damage", low=25.2, high=28.8, sp=0.107, perLevel=0.2, baseLevel=20, maxLevel=26}, {low=47.35714, high=54.64286, sp=0.107, perLevel=0.4, baseLevel=20, maxLevel=26}}}, -- Holy Nova 1
    [15430] = {kind="heal", school=2, level=28, cast=0, gcd=1.5, components={{kind="damage", low=45.37037, high=52.62963, sp=0.107, perLevel=0.4, baseLevel=28, maxLevel=34}, {low=76.65217, high=87.34783, sp=0.107, perLevel=0.5, baseLevel=28, maxLevel=34}}}, -- Holy Nova 2
    [15431] = {kind="heal", school=2, level=36, cast=0, gcd=1.5, components={{kind="damage", low=69.5122, high=80.4878, sp=0.107, perLevel=0.6, baseLevel=36, maxLevel=42}, {low=107.9692, high=124.0308, sp=0.107, perLevel=0.6, baseLevel=36, maxLevel=42}}}, -- Holy Nova 3
    [27799] = {kind="heal", school=2, level=44, cast=0, gcd=1.5, components={{kind="damage", low=98.5614, high=113.4386, sp=0.107, perLevel=0.8, baseLevel=44, maxLevel=50}, {low=147.1207, high=170.8793, sp=0.107, perLevel=0.7, baseLevel=44, maxLevel=50}}}, -- Holy Nova 4
    [27800] = {kind="heal", school=2, level=52, cast=0, gcd=1.5, components={{kind="damage", low=132.5828, high=153.4172, sp=0.107, perLevel=1, baseLevel=52, maxLevel=58}, {low=221.0672, high=254.9328, sp=0.107, perLevel=0.8, baseLevel=52, maxLevel=58}}}, -- Holy Nova 5
    [27801] = {kind="heal", school=2, level=60, cast=0, gcd=1.5, components={{kind="damage", low=173.5744, high=200.4256, sp=0.107, perLevel=1.2, baseLevel=60, maxLevel=66}, {low=288.1043, high=333.8957, sp=0.107, perLevel=0.9, baseLevel=60, maxLevel=66}}}, -- Holy Nova 6
    [20473] = {kind="heal", school=2, level=40, cast=0, gcd=1.5, components={{kind="damage", low=175.1321, high=188.8679, sp=0.429}, {low=150.1132, high=161.8868, sp=0.429}}}, -- Holy Shock 2
    [20929] = {kind="heal", school=2, level=48, cast=0, gcd=1.5, components={{kind="damage", low=248.2138, high=267.7862, sp=0.429}, {low=221.2759, high=238.7241, sp=0.429}}}, -- Holy Shock 3
    [20930] = {kind="heal", school=2, level=56, cast=0, gcd=1.5, components={{kind="damage", low=334.2632, high=361.7368, sp=0.429}, {low=307.3684, high=332.6316, sp=0.429}}}, -- Holy Shock 4
    [1311606] = {kind="heal", school=2, level=30, cast=0, gcd=1.5, components={{kind="damage", low=128.9434, high=139.0566, sp=0.429}, {low=109.6981, high=118.3019, sp=0.429}}}, -- Holy Shock 1
    [2812] = {kind="damage", school=2, level=50, cast=2, gcd=1.5, components={{low=362, high=428, sp=0.19, perLevel=1.6, baseLevel=50, maxLevel=54}}}, -- Holy Wrath 1
    [10318] = {kind="damage", school=2, level=60, cast=2, gcd=1.5, components={{low=490, high=576, sp=0.19, perLevel=1.9, baseLevel=60, maxLevel=64}}}, -- Holy Wrath 2
    [16914] = {kind="damage", school=4, level=40, cast=0, gcd=1.5, channel=10, components={{low=68, high=68, ticks=10, sp=0.03, perLevel=0.2, baseLevel=40, maxLevel=46}}}, -- Hurricane 1
    [17401] = {kind="damage", school=4, level=50, cast=0, gcd=1.5, channel=10, components={{low=98, high=98, ticks=10, sp=0.03, perLevel=0.2, baseLevel=50, maxLevel=56}}}, -- Hurricane 2
    [17402] = {kind="damage", school=4, level=60, cast=0, gcd=1.5, channel=10, components={{low=132, high=132, ticks=10, sp=0.03, perLevel=0.3, baseLevel=60, maxLevel=60}}}, -- Hurricane 3
    [11426] = {kind="absorb", school=5, level=40, absorbTalent=11189, cast=0, gcd=1.5, components={{low=431, high=431, perLevel=2.8, baseLevel=40, maxLevel=46, sp=0.1, school=5, fullPower=true}}}, -- Ice Barrier 1
    [13031] = {kind="absorb", school=5, level=46, absorbTalent=11189, cast=0, gcd=1.5, components={{low=542, high=542, perLevel=3.2, baseLevel=46, maxLevel=52, sp=0.1, school=5, fullPower=true}}}, -- Ice Barrier 2
    [13032] = {kind="absorb", school=5, level=52, absorbTalent=11189, cast=0, gcd=1.5, components={{low=671, high=671, perLevel=3.6, baseLevel=52, maxLevel=58, sp=0.1, school=5, fullPower=true}}}, -- Ice Barrier 3
    [13033] = {kind="absorb", school=5, level=58, absorbTalent=11189, cast=0, gcd=1.5, components={{low=811, high=811, perLevel=4, baseLevel=58, maxLevel=60, sp=0.1, school=5, fullPower=true}}}, -- Ice Barrier 4
    [1240044] = {kind="damage", school=5, level=34, cast=0, gcd=1.5, components={{low=41.25, high=48.75, perLevel=0.5, baseLevel=34, maxLevel=40}}}, -- Ice Lance 3
    [1240046] = {kind="damage", school=5, level=48, cast=0, gcd=1.5, components={{low=89.83333, high=106.1667, perLevel=0.7, baseLevel=48, maxLevel=56}}}, -- Ice Lance 5
    [1240047] = {kind="damage", school=5, level=56, cast=0, gcd=1.5, components={{low=132.9167, high=157.0833, perLevel=0.9, baseLevel=56, maxLevel=60}}}, -- Ice Lance 6
    [1312002] = {kind="damage", school=5, level=20, cast=0, gcd=1.5, components={{low=25.66667, high=30.33333, perLevel=0.35, baseLevel=20, maxLevel=27}}}, -- Ice Lance 1
    [348] = {kind="damage", school=3, level=1, cast=2, gcd=1.5, damageDuration=15, components={{low=3, high=3, ticks=5, sp=0.13}, {low=8, high=8, sp=0.2, perLevel=0.7, baseLevel=1, maxLevel=5}}}, -- Immolate 1
    [707] = {kind="damage", school=3, level=10, cast=2, gcd=1.5, damageDuration=15, components={{low=6, high=6, ticks=5, sp=0.13}, {low=17, high=17, sp=0.2, perLevel=0.8, baseLevel=10, maxLevel=15}}}, -- Immolate 2
    [1094] = {kind="damage", school=3, level=20, cast=2, gcd=1.5, damageDuration=15, components={{low=12, high=12, ticks=5, sp=0.13}, {low=32, high=32, sp=0.2, perLevel=1.2, baseLevel=20, maxLevel=25}}}, -- Immolate 3
    [2941] = {kind="damage", school=3, level=30, cast=2, gcd=1.5, damageDuration=15, components={{low=19, high=19, ticks=5, sp=0.13}, {low=56, high=56, sp=0.2, perLevel=1.5, baseLevel=30, maxLevel=35}}}, -- Immolate 4
    [11665] = {kind="damage", school=3, level=40, cast=2, gcd=1.5, damageDuration=15, components={{low=25, high=25, ticks=5, sp=0.13}, {low=72, high=72, sp=0.2, perLevel=1.6, baseLevel=40, maxLevel=45}}}, -- Immolate 5
    [11667] = {kind="damage", school=3, level=50, cast=2, gcd=1.5, damageDuration=15, components={{low=38, high=38, ticks=5, sp=0.13}, {low=106, high=106, sp=0.2, perLevel=1.9, baseLevel=50, maxLevel=55}}}, -- Immolate 6
    [11668] = {kind="damage", school=3, level=60, cast=2, gcd=1.5, damageDuration=15, components={{low=52, high=52, ticks=5, sp=0.13}, {low=146, high=146, sp=0.2, perLevel=2.3, baseLevel=60, maxLevel=65}}}, -- Immolate 7
    [25309] = {kind="damage", school=3, level=60, cast=2, gcd=1.5, damageDuration=15, components={{low=55, high=55, ticks=5, sp=0.13}, {low=158, high=158, sp=0.2, perLevel=2.3, baseLevel=60, maxLevel=65}}}, -- Immolate 8
    [412758] = {kind="damage", school=3, level=40, cast=2.5, gcd=1.5, components={{low=89.725, high=104.275, sp=0.714, perLevel=1.1, baseLevel=40, maxLevel=49}}}, -- Incinerate 1
    [1293812] = {kind="damage", school=3, level=50, cast=2.5, gcd=1.5, components={{low=134.125, high=155.875, sp=0.714, perLevel=1.3, baseLevel=50, maxLevel=59}}}, -- Incinerate 2
    [1293813] = {kind="damage", school=3, level=60, cast=2.5, gcd=1.5, components={{low=200.725, high=233.275, sp=0.714, perLevel=1.4, baseLevel=60, maxLevel=69}}}, -- Incinerate 3
    [5570] = {kind="damage", school=4, level=20, cast=0, gcd=1.5, damageDuration=12, components={{low=8, high=8, ticks=6, sp=0.158}}}, -- Insect Swarm 1
    [24974] = {kind="damage", school=4, level=30, cast=0, gcd=1.5, damageDuration=12, components={{low=15, high=15, ticks=6, sp=0.158}}}, -- Insect Swarm 2
    [24975] = {kind="damage", school=4, level=40, cast=0, gcd=1.5, damageDuration=12, components={{low=20, high=20, ticks=6, sp=0.158}}}, -- Insect Swarm 3
    [24976] = {kind="damage", school=4, level=50, cast=0, gcd=1.5, damageDuration=12, components={{low=25, high=25, ticks=6, sp=0.158}}}, -- Insect Swarm 4
    [24977] = {kind="damage", school=4, level=60, cast=0, gcd=1.5, damageDuration=12, components={{low=31, high=31, ticks=6, sp=0.158}}}, -- Insect Swarm 5
    [408490] = {kind="damage", school=3, level=30, cast=2.5, gcd=1.5, components={{low=107.4246, high=138.5754, sp=0.714, perLevel=0.8, baseLevel=30, maxLevel=38}}}, -- Lava Burst 1
    [1238299] = {kind="damage", school=3, level=40, cast=2.5, gcd=1.5, components={{low=143.2328, high=184.7672, sp=0.714, perLevel=0.9, baseLevel=40, maxLevel=48}}}, -- Lava Burst 2
    [1238300] = {kind="damage", school=3, level=50, cast=2.5, gcd=1.5, components={{low=171.1806, high=220.8194, sp=0.714, perLevel=1.1, baseLevel=50, maxLevel=58}}}, -- Lava Burst 3
    [1326047] = {kind="damage", school=3, level=60, cast=2.5, gcd=1.5, components={{low=192.1415, high=247.8585, sp=0.714, perLevel=1.3, baseLevel=60, maxLevel=68}}}, -- Lava Burst 4
    [633] = {kind="heal", school=2, allMana=true, cast=0, gcd=1.5, components={{low=0, high=0, health=1}}}, -- Lay on Hands 1
    [2800] = {kind="heal", school=2, allMana=true, cast=0, gcd=1.5, components={{low=0, high=0, health=1}}}, -- Lay on Hands 2
    [10310] = {kind="heal", school=2, allMana=true, cast=0, gcd=1.5, components={{low=0, high=0, health=1}}}, -- Lay on Hands 3
    [2050] = {kind="heal", school=2, level=1, cast=1.5, gcd=1.5, components={{low=46, high=56, sp=0.429, perLevel=0.3, baseLevel=1, maxLevel=3}}}, -- Lesser Heal 1
    [2052] = {kind="heal", school=2, level=4, cast=2, gcd=1.5, components={{low=85.5641, high=102.4359, sp=0.571, perLevel=0.7, baseLevel=4, maxLevel=9}}}, -- Lesser Heal 2
    [2053] = {kind="heal", school=2, level=10, cast=2.5, gcd=1.5, components={{low=150.7192, high=175.2808, sp=0.714, perLevel=1.2, baseLevel=10, maxLevel=15}}}, -- Lesser Heal 3
    [8004] = {kind="heal", school=4, level=20, cast=1.5, gcd=1.5, components={{low=142.4483, high=163.5517, sp=0.429, perLevel=1.7, baseLevel=20, maxLevel=25}}}, -- Lesser Healing Wave 1
    [8008] = {kind="heal", school=4, level=28, cast=1.5, gcd=1.5, components={{low=209.5758, high=238.4242, sp=0.429, perLevel=2.1, baseLevel=28, maxLevel=33}}}, -- Lesser Healing Wave 2
    [8010] = {kind="heal", school=4, level=36, cast=1.5, gcd=1.5, components={{low=285.3705, high=322.6295, sp=0.429, perLevel=2.5, baseLevel=36, maxLevel=41}}}, -- Lesser Healing Wave 3
    [10466] = {kind="heal", school=4, level=44, cast=1.5, gcd=1.5, components={{low=401.4568, high=450.5432, sp=0.429, perLevel=3, baseLevel=44, maxLevel=49}}}, -- Lesser Healing Wave 4
    [10467] = {kind="heal", school=4, level=52, cast=1.5, gcd=1.5, components={{low=574.3234, high=641.6766, sp=0.429, perLevel=3.6, baseLevel=52, maxLevel=57}}}, -- Lesser Healing Wave 5
    [10468] = {kind="heal", school=4, level=60, cast=1.5, gcd=1.5, components={{low=775.2727, high=864.7273, sp=0.429, perLevel=4.2, baseLevel=60, maxLevel=65}}}, -- Lesser Healing Wave 6
    [408124] = {kind="heal", school=4, ranked=false, cast=0, gcd=1, healDuration=7, components={{low=0.04, high=0.04, ticks=7, curve={38.94983, 0.606705, 0.16778}}, {low=0.57, high=0.57, sp=0.274, curve={38.94983, 0.606705, 0.16778}}}}, -- Lifebloom
    [403] = {kind="damage", school=4, level=1, cast=1.5, gcd=1.5, components={{low=14.85714, high=17.14286, sp=0.429, perLevel=0.1, baseLevel=1, maxLevel=6}}}, -- Lightning Bolt 1
    [529] = {kind="damage", school=4, level=8, cast=2, gcd=1.5, components={{low=27.85714, high=32.14286, sp=0.571, perLevel=0.1, baseLevel=8, maxLevel=13}}}, -- Lightning Bolt 2
    [548] = {kind="damage", school=4, level=14, cast=2.5, gcd=1.5, components={{low=47.7551, high=56.2449, sp=0.714, perLevel=0.3, baseLevel=14, maxLevel=19}}}, -- Lightning Bolt 3
    [915] = {kind="damage", school=4, level=20, cast=2.5, gcd=1.5, components={{low=68.07865, high=77.92135, sp=0.714, perLevel=0.5, baseLevel=20, maxLevel=25}}}, -- Lightning Bolt 4
    [943] = {kind="damage", school=4, level=26, cast=2.5, gcd=1.5, components={{low=101.6791, high=116.3209, sp=0.714, perLevel=0.7, baseLevel=26, maxLevel=31}}}, -- Lightning Bolt 5
    [6041] = {kind="damage", school=4, level=32, cast=2.5, gcd=1.5, components={{low=139.1038, high=156.8962, sp=0.714, perLevel=1, baseLevel=32, maxLevel=37}}}, -- Lightning Bolt 6
    [10391] = {kind="damage", school=4, level=38, cast=2.5, gcd=1.5, components={{low=182.7303, high=205.2697, sp=0.714, perLevel=1, baseLevel=38, maxLevel=43}}}, -- Lightning Bolt 7
    [10392] = {kind="damage", school=4, level=44, cast=2.5, gcd=1.5, components={{low=226.3545, high=253.6455, sp=0.714, perLevel=1.5, baseLevel=44, maxLevel=49}}}, -- Lightning Bolt 8
    [15207] = {kind="damage", school=4, level=50, cast=2.5, gcd=1.5, components={{low=278.1658, high=311.8342, sp=0.714, perLevel=1.6, baseLevel=50, maxLevel=55}}}, -- Lightning Bolt 9
    [15208] = {kind="damage", school=4, level=56, cast=2.5, gcd=1.5, components={{low=333.8758, high=372.1242, sp=0.714, perLevel=2.1, baseLevel=56, maxLevel=61}}}, -- Lightning Bolt 10
    [724] = {kind="heal", school=2, cast=1.5, gcd=1.5, components={}}, -- Lightwell 1
    [27870] = {kind="heal", school=2, cast=1.5, gcd=1.5, components={}}, -- Lightwell 2
    [27871] = {kind="heal", school=2, cast=1.5, gcd=1.5, components={}}, -- Lightwell 3
    [1463] = {kind="absorb", school=7, level=20, conditionalMana=true, cast=0, gcd=1.5, components={{low=120, high=120}}}, -- Mana Shield 1
    [8494] = {kind="absorb", school=7, level=28, conditionalMana=true, cast=0, gcd=1.5, components={{low=210, high=210}}}, -- Mana Shield 2
    [8495] = {kind="absorb", school=7, level=36, conditionalMana=true, cast=0, gcd=1.5, components={{low=300, high=300}}}, -- Mana Shield 3
    [10191] = {kind="absorb", school=7, level=44, conditionalMana=true, cast=0, gcd=1.5, components={{low=390, high=390}}}, -- Mana Shield 4
    [10192] = {kind="absorb", school=7, level=52, conditionalMana=true, cast=0, gcd=1.5, components={{low=480, high=480}}}, -- Mana Shield 5
    [10193] = {kind="absorb", school=7, level=60, conditionalMana=true, cast=0, gcd=1.5, components={{low=570, high=570}}}, -- Mana Shield 6
    [412116] = {kind="absorb", school=7, level=20, conditionalMana=true, cast=0, gcd=1.5, components={{low=240, high=240}}}, -- Mana Shield 1
    [412118] = {kind="absorb", school=7, level=28, conditionalMana=true, cast=0, gcd=1.5, components={{low=420, high=420}}}, -- Mana Shield 2
    [412120] = {kind="absorb", school=7, level=36, conditionalMana=true, cast=0, gcd=1.5, components={{low=600, high=600}}}, -- Mana Shield 3
    [412121] = {kind="absorb", school=7, level=44, conditionalMana=true, cast=0, gcd=1.5, components={{low=780, high=780}}}, -- Mana Shield 4
    [412122] = {kind="absorb", school=7, level=52, conditionalMana=true, cast=0, gcd=1.5, components={{low=960, high=960}}}, -- Mana Shield 5
    [412123] = {kind="absorb", school=7, level=60, conditionalMana=true, cast=0, gcd=1.5, components={{low=1140, high=1140}}}, -- Mana Shield 6
    [136] = {kind="heal", school=4, level=12, cast=0, gcd=1.5, channel=5, components={{low=20, high=20, ticks=5, sp=0.14}}}, -- Mend Pet 1
    [3111] = {kind="heal", school=4, level=20, cast=0, gcd=1.5, channel=5, components={{low=38, high=38, ticks=5, sp=0.2}}}, -- Mend Pet 2
    [3661] = {kind="heal", school=4, level=28, cast=0, gcd=1.5, channel=5, components={{low=68, high=68, ticks=5, sp=0.2}}}, -- Mend Pet 3
    [3662] = {kind="heal", school=4, level=36, cast=0, gcd=1.5, channel=5, components={{low=103, high=103, ticks=5, sp=0.2}}}, -- Mend Pet 4
    [13542] = {kind="heal", school=4, level=44, cast=0, gcd=1.5, channel=5, components={{low=142, high=142, ticks=5, sp=0.2}}}, -- Mend Pet 5
    [13543] = {kind="heal", school=4, level=52, cast=0, gcd=1.5, channel=5, components={{low=189, high=189, ticks=5, sp=0.2}}}, -- Mend Pet 6
    [13544] = {kind="heal", school=4, level=60, cast=0, gcd=1.5, channel=5, components={{low=245, high=245, ticks=5, sp=0.2}}}, -- Mend Pet 7
    [8092] = {kind="damage", school=6, level=10, cast=1.5, gcd=1.5, components={{low=37.09756, high=40.90244, sp=0.429, perLevel=0.6, baseLevel=10, maxLevel=15}}}, -- Mind Blast 1
    [8102] = {kind="damage", school=6, level=16, cast=1.5, gcd=1.5, components={{low=65.28, high=70.72, sp=0.429, perLevel=0.9, baseLevel=16, maxLevel=21}}}, -- Mind Blast 2
    [8103] = {kind="damage", school=6, level=22, cast=1.5, gcd=1.5, components={{low=97.51724, high=104.4828, sp=0.429, perLevel=1.1, baseLevel=22, maxLevel=27}}}, -- Mind Blast 3
    [8104] = {kind="damage", school=6, level=28, cast=1.5, gcd=1.5, components={{low=146.6105, high=155.3895, sp=0.429, perLevel=1.4, baseLevel=28, maxLevel=33}}}, -- Mind Blast 4
    [8105] = {kind="damage", school=6, level=34, cast=1.5, gcd=1.5, components={{low=189.875, high=202.125, sp=0.429, perLevel=1.6, baseLevel=34, maxLevel=39}}}, -- Mind Blast 5
    [8106] = {kind="damage", school=6, level=40, cast=1.5, gcd=1.5, components={{low=249.9375, high=266.0625, sp=0.429, perLevel=1.9, baseLevel=40, maxLevel=45}}}, -- Mind Blast 6
    [10945] = {kind="damage", school=6, level=46, cast=1.5, gcd=1.5, components={{low=314.8989, high=333.1011, sp=0.429, perLevel=2.1, baseLevel=46, maxLevel=51}}}, -- Mind Blast 7
    [10946] = {kind="damage", school=6, level=52, cast=1.5, gcd=1.5, components={{low=393.8787, high=416.1213, sp=0.429, perLevel=2.4, baseLevel=52, maxLevel=57}}}, -- Mind Blast 8
    [10947] = {kind="damage", school=6, level=58, cast=1.5, gcd=1.5, components={{low=471.8665, high=498.1335, sp=0.429, perLevel=2.6, baseLevel=58, maxLevel=63}}}, -- Mind Blast 9
    [15407] = {kind="damage", school=6, level=20, cast=0, gcd=1.5, channel=3, components={{low=21, high=21, ticks=3, sp=0.167}}}, -- Mind Flay 1
    [17311] = {kind="damage", school=6, level=28, cast=0, gcd=1.5, channel=3, components={{low=34, high=34, ticks=3, sp=0.167}}}, -- Mind Flay 2
    [17312] = {kind="damage", school=6, level=36, cast=0, gcd=1.5, channel=3, components={{low=51, high=51, ticks=3, sp=0.167}}}, -- Mind Flay 3
    [17313] = {kind="damage", school=6, level=44, cast=0, gcd=1.5, channel=3, components={{low=75, high=75, ticks=3, sp=0.167}}}, -- Mind Flay 4
    [17314] = {kind="damage", school=6, level=52, cast=0, gcd=1.5, channel=3, components={{low=98, high=98, ticks=3, sp=0.167}}}, -- Mind Flay 5
    [18807] = {kind="damage", school=6, level=60, cast=0, gcd=1.5, channel=3, components={{low=130, high=130, ticks=3, sp=0.167}}}, -- Mind Flay 6
    [431655] = {kind="damage", school=5, schools={5, 6}, ranked=false, cast=1.5, gcd=1.5, components={{low=1.22, high=1.42, sp=0.429, curve={9.456667, 0.635108, 0.039063}}}}, -- Mind Spike
    [425339] = {kind="damage", school=3, ranked=false, cast=0, gcd=1.5, components={{low=0.72, high=1.08, sp=0.143, curve={7.583798, 0.471881, 0.036599}, ap=0.05}}}, -- Molten Blast
    [8921] = {kind="damage", school=7, level=4, cast=0, gcd=1.5, damageDuration=9, components={{low=4, high=4, ticks=3, sp=0.13}, {low=7, high=9, sp=0.15, perLevel=0.5, baseLevel=4, maxLevel=9}}}, -- Moonfire 1
    [8924] = {kind="damage", school=7, level=10, cast=0, gcd=1.5, damageDuration=12, components={{low=6, high=6, ticks=4, sp=0.13}, {low=11.26667, high=14.73333, sp=0.15, perLevel=0.8, baseLevel=10, maxLevel=15}}}, -- Moonfire 2
    [8925] = {kind="damage", school=7, level=16, cast=0, gcd=1.5, damageDuration=12, components={{low=9, high=9, ticks=4, sp=0.13}, {low=19.64286, high=24.35714, sp=0.15, perLevel=1, baseLevel=16, maxLevel=21}}}, -- Moonfire 3
    [8926] = {kind="damage", school=7, level=22, cast=0, gcd=1.5, damageDuration=12, components={{low=13, high=13, ticks=4, sp=0.13}, {low=29.09091, high=34.90909, sp=0.15, perLevel=1.5, baseLevel=22, maxLevel=27}}}, -- Moonfire 4
    [8927] = {kind="damage", school=7, level=28, cast=0, gcd=1.5, damageDuration=12, components={{low=19, high=19, ticks=4, sp=0.13}, {low=42.79104, high=51.20896, sp=0.15, perLevel=1.5, baseLevel=28, maxLevel=33}}}, -- Moonfire 5
    [8928] = {kind="damage", school=7, level=34, cast=0, gcd=1.5, damageDuration=12, components={{low=23, high=23, ticks=4, sp=0.13}, {low=53.69663, high=64.30337, sp=0.15, perLevel=1.6, baseLevel=34, maxLevel=39}}}, -- Moonfire 6
    [8929] = {kind="damage", school=7, level=40, cast=0, gcd=1.5, damageDuration=12, components={{low=31, high=31, ticks=4, sp=0.13}, {low=66.65217, high=79.34783, sp=0.15, perLevel=1.7, baseLevel=40, maxLevel=45}}}, -- Moonfire 7
    [9833] = {kind="damage", school=7, level=46, cast=0, gcd=1.5, damageDuration=12, components={{low=39, high=39, ticks=4, sp=0.13}, {low=83.30986, high=98.69014, sp=0.15, perLevel=2.7, baseLevel=46, maxLevel=51}}}, -- Moonfire 8
    [9834] = {kind="damage", school=7, level=52, cast=0, gcd=1.5, damageDuration=12, components={{low=49, high=49, ticks=4, sp=0.13}, {low=101.9123, high=120.0877, sp=0.15, perLevel=2.1, baseLevel=52, maxLevel=57}}}, -- Moonfire 9
    [9835] = {kind="damage", school=7, level=58, cast=0, gcd=1.5, damageDuration=12, components={{low=60, high=60, ticks=4, sp=0.13}, {low=124.4634, high=145.5366, sp=0.15, perLevel=2.3, baseLevel=58, maxLevel=63}}}, -- Moonfire 10
    [408247] = {kind="heal", school=4, ranked=false, cast=2, gcd=1.5, components={{low=1.61, high=1.89, sp=0.357, curve={38.94983, 0.606705, 0.16778}}}}, -- Nourish
    [402174] = {kind="heal", school=2, level=30, cast=0, gcd=1.5, channel=2, components={{kind="damage", low=42, high=42, ticks=3, sp=0.19, perLevel=0.29, baseLevel=30, maxLevel=39}, {low=126, high=126, ticks=3, sp=0.19, perLevel=0.87, baseLevel=30, maxLevel=39}}}, -- Penance 1
    [1240720] = {kind="heal", school=2, level=40, cast=0, gcd=1.5, channel=2, components={{kind="damage", low=50, high=50, ticks=3, sp=0.19, perLevel=0.33, baseLevel=40, maxLevel=49}, {low=200, high=200, ticks=3, sp=0.19, perLevel=0.98, baseLevel=40, maxLevel=49}}}, -- Penance 2
    [1240721] = {kind="heal", school=2, level=50, cast=0, gcd=1.5, channel=2, components={{kind="damage", low=68, high=68, ticks=3, sp=0.19, perLevel=0.43, baseLevel=50, maxLevel=59}, {low=268, high=268, ticks=3, sp=0.19, perLevel=1.27, baseLevel=50, maxLevel=59}}}, -- Penance 3
    [1316995] = {kind="heal", school=2, level=60, cast=0, gcd=1.5, channel=2, components={{kind="damage", low=92, high=92, ticks=3, sp=0.19}, {low=425, high=425, ticks=3, sp=0.19}}}, -- Penance 4
    [17] = {kind="absorb", school=2, level=6, absorbTalent=14748, cast=0, gcd=1.5, components={{low=44, high=44, sp=0.1, perLevel=0.8, baseLevel=6, maxLevel=11}}}, -- Power Word: Shield 1
    [592] = {kind="absorb", school=2, level=12, absorbTalent=14748, cast=0, gcd=1.5, components={{low=86, high=86, sp=0.1, perLevel=1.2, baseLevel=12, maxLevel=17}}}, -- Power Word: Shield 2
    [600] = {kind="absorb", school=2, level=18, absorbTalent=14748, cast=0, gcd=1.5, components={{low=154, high=154, sp=0.1, perLevel=1.6, baseLevel=18, maxLevel=23}}}, -- Power Word: Shield 3
    [3747] = {kind="absorb", school=2, level=24, absorbTalent=14748, cast=0, gcd=1.5, components={{low=226, high=226, sp=0.1, perLevel=2, baseLevel=24, maxLevel=29}}}, -- Power Word: Shield 4
    [6065] = {kind="absorb", school=2, level=30, absorbTalent=14748, cast=0, gcd=1.5, components={{low=291, high=291, sp=0.1, perLevel=2.3, baseLevel=30, maxLevel=35}}}, -- Power Word: Shield 5
    [6066] = {kind="absorb", school=2, level=36, absorbTalent=14748, cast=0, gcd=1.5, components={{low=368, high=368, sp=0.1, perLevel=2.6, baseLevel=36, maxLevel=41}}}, -- Power Word: Shield 6
    [10898] = {kind="absorb", school=2, level=42, absorbTalent=14748, cast=0, gcd=1.5, components={{low=470, high=470, sp=0.1, perLevel=3, baseLevel=42, maxLevel=47}}}, -- Power Word: Shield 7
    [10899] = {kind="absorb", school=2, level=48, absorbTalent=14748, cast=0, gcd=1.5, components={{low=591, high=591, sp=0.1, perLevel=3.4, baseLevel=48, maxLevel=53}}}, -- Power Word: Shield 8
    [10900] = {kind="absorb", school=2, level=54, absorbTalent=14748, cast=0, gcd=1.5, components={{low=749, high=749, sp=0.1, perLevel=3.9, baseLevel=54, maxLevel=59}}}, -- Power Word: Shield 9
    [10901] = {kind="absorb", school=2, level=60, absorbTalent=14748, cast=0, gcd=1.5, components={{low=928, high=928, sp=0.1, perLevel=4.3, baseLevel=60, maxLevel=65}}}, -- Power Word: Shield 10
    [596] = {kind="heal", school=2, level=30, cast=3, gcd=1.5, components={{low=172.2765, high=183.7235, sp=0.286, perLevel=0.8, baseLevel=30, maxLevel=39}}}, -- Prayer of Healing 1
    [996] = {kind="heal", school=2, level=40, cast=3, gcd=1.5, components={{low=256.8996, high=273.1004, sp=0.286, perLevel=1, baseLevel=40, maxLevel=49}}}, -- Prayer of Healing 2
    [10960] = {kind="heal", school=2, level=50, cast=3, gcd=1.5, components={{low=389.7293, high=412.2707, sp=0.286, perLevel=1.3, baseLevel=50, maxLevel=59}}}, -- Prayer of Healing 3
    [10961] = {kind="heal", school=2, level=60, cast=3, gcd=1.5, components={{low=567.2922, high=598.7078, sp=0.286, perLevel=1.5, baseLevel=60, maxLevel=69}}}, -- Prayer of Healing 4
    [25316] = {kind="heal", school=2, level=60, cast=3, gcd=1.5, components={{low=631.4103, high=666.5897, sp=0.286, perLevel=1.6, baseLevel=60, maxLevel=69}}}, -- Prayer of Healing 5
    [11366] = {kind="damage", school=3, level=20, cast=6, gcd=1.5, damageDuration=12, components={{low=94.57317, high=125.4268, sp=1, perLevel=1.5, baseLevel=20, maxLevel=24}, {low=11, high=11, ticks=4, sp=0.15}}}, -- Pyroblast 1
    [12505] = {kind="damage", school=3, level=24, cast=6, gcd=1.5, damageDuration=12, components={{low=115.9615, high=152.0385, sp=1, perLevel=1.7, baseLevel=24, maxLevel=30}, {low=14, high=14, ticks=4, sp=0.15}}}, -- Pyroblast 2
    [12522] = {kind="damage", school=3, level=30, cast=6, gcd=1.5, damageDuration=12, components={{low=167.3711, high=214.6289, sp=1, perLevel=2.1, baseLevel=30, maxLevel=36}, {low=19, high=19, ticks=4, sp=0.15}}}, -- Pyroblast 3
    [12523] = {kind="damage", school=3, level=36, cast=6, gcd=1.5, damageDuration=12, components={{low=215.5214, high=274.4786, sp=1, perLevel=2.4, baseLevel=36, maxLevel=42}, {low=25, high=25, ticks=4, sp=0.15}}}, -- Pyroblast 4
    [12524] = {kind="damage", school=3, level=42, cast=6, gcd=1.5, damageDuration=12, components={{low=274.5705, high=347.4295, sp=1, perLevel=2.7, baseLevel=42, maxLevel=48}, {low=31, high=31, ticks=4, sp=0.15}}}, -- Pyroblast 5
    [12525] = {kind="damage", school=3, level=48, cast=6, gcd=1.5, damageDuration=12, components={{low=349.5273, high=438.4727, sp=1, perLevel=3, baseLevel=48, maxLevel=54}, {low=38, high=38, ticks=4, sp=0.15}}}, -- Pyroblast 6
    [12526] = {kind="damage", school=3, level=54, cast=6, gcd=1.5, damageDuration=12, components={{low=427.5556, high=534.4444, sp=1, perLevel=3.4, baseLevel=54, maxLevel=60}, {low=46, high=46, ticks=4, sp=0.15}}}, -- Pyroblast 7
    [18809] = {kind="damage", school=3, level=60, cast=6, gcd=1.5, damageDuration=12, components={{low=519.8356, high=646.1644, sp=1, perLevel=4.6, baseLevel=60, maxLevel=66}, {low=53, high=53, ticks=4, sp=0.15}}}, -- Pyroblast 8
    [5740] = {kind="damage", school=3, level=20, cast=0, gcd=1.5, channel=8, components={{low=40, high=40, ticks=4, sp=0.083, perLevel=0.3, baseLevel=20, maxLevel=25}}}, -- Rain of Fire 1
    [6219] = {kind="damage", school=3, level=34, cast=0, gcd=1.5, channel=8, components={{low=91, high=91, ticks=4, sp=0.083, perLevel=0.4, baseLevel=34, maxLevel=39}}}, -- Rain of Fire 2
    [11677] = {kind="damage", school=3, level=46, cast=0, gcd=1.5, channel=8, components={{low=149, high=149, ticks=4, sp=0.083, perLevel=0.5, baseLevel=46, maxLevel=51}}}, -- Rain of Fire 3
    [11678] = {kind="damage", school=3, level=58, cast=0, gcd=1.5, channel=8, components={{low=220, high=220, ticks=4, sp=0.083, perLevel=0.6, baseLevel=58, maxLevel=60}}}, -- Rain of Fire 4
    [19474] = {kind="damage", school=3, level=60, cast=0, gcd=1.5, channel=8, components={{low=196, high=196, ticks=4, sp=0.083, perLevel=0.6, baseLevel=60, maxLevel=60}}}, -- Rain of Fire 1
    [401417] = {kind="heal", school=7, ranked=false, cast=0, gcd=1.5, channel=3, components={{low=0.42, high=0.42, ticks=3, sp=0.594, curve={38.25838, 0.904195, 0.161311}}}}, -- Regeneration
    [8936] = {kind="heal", school=4, level=12, cast=2, gcd=1.5, healDuration=21, components={{low=80.30769, high=93.69231, sp=0.286, perLevel=1.8, baseLevel=12, maxLevel=17}, {low=13, high=13, ticks=7, sp=0.071}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Regrowth 1
    [8938] = {kind="heal", school=4, level=18, cast=2, gcd=1.5, healDuration=21, components={{low=152.8182, high=175.1818, sp=0.286, perLevel=2.5, baseLevel=18, maxLevel=23}, {low=22, high=22, ticks=7, sp=0.071}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Regrowth 2
    [8939] = {kind="heal", school=4, level=24, cast=2, gcd=1.5, healDuration=21, components={{low=219.4553, high=250.5447, sp=0.286, perLevel=3.1, baseLevel=24, maxLevel=29}, {low=32, high=32, ticks=7, sp=0.071}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Regrowth 3
    [8940] = {kind="heal", school=4, level=30, cast=2, gcd=1.5, healDuration=21, components={{low=291.7345, high=330.2655, sp=0.286, perLevel=3.6, baseLevel=30, maxLevel=35}, {low=42, high=42, ticks=7, sp=0.071}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Regrowth 4
    [8941] = {kind="heal", school=4, level=36, cast=2, gcd=1.5, healDuration=21, components={{low=370.232, high=417.768, sp=0.286, perLevel=4.1, baseLevel=36, maxLevel=41}, {low=52, high=52, ticks=7, sp=0.071}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Regrowth 5
    [9750] = {kind="heal", school=4, level=42, cast=2, gcd=1.5, healDuration=21, components={{low=474.2983, high=533.7017, sp=0.286, perLevel=4.7, baseLevel=42, maxLevel=47}, {low=68, high=68, ticks=7, sp=0.071}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Regrowth 6
    [9856] = {kind="heal", school=4, level=48, cast=2, gcd=1.5, healDuration=21, components={{low=608.2774, high=681.7226, sp=0.286, perLevel=5.3, baseLevel=48, maxLevel=53}, {low=88, high=88, ticks=7, sp=0.071}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Regrowth 7
    [9857] = {kind="heal", school=4, level=54, cast=2, gcd=1.5, healDuration=21, components={{low=771.2404, high=862.7596, sp=0.286, perLevel=6, baseLevel=54, maxLevel=59}, {low=113, high=113, ticks=7, sp=0.071}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Regrowth 8
    [9858] = {kind="heal", school=4, level=60, cast=2, gcd=1.5, healDuration=21, components={{low=965.1866, high=1076.813, sp=0.286, perLevel=6.8, baseLevel=60, maxLevel=65}, {low=142, high=142, ticks=7, sp=0.071}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Regrowth 9
    [774] = {kind="heal", school=4, level=4, cast=0, gcd=1.5, healDuration=12, components={{low=8, high=8, ticks=4, sp=0.2}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Rejuvenation 1
    [1058] = {kind="heal", school=4, level=10, cast=0, gcd=1.5, healDuration=12, components={{low=12, high=12, ticks=4, sp=0.2}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Rejuvenation 2
    [1430] = {kind="heal", school=4, level=16, cast=0, gcd=1.5, healDuration=12, components={{low=23, high=23, ticks=4, sp=0.2}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Rejuvenation 3
    [2090] = {kind="heal", school=4, level=22, cast=0, gcd=1.5, healDuration=12, components={{low=32, high=32, ticks=4, sp=0.2}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Rejuvenation 4
    [2091] = {kind="heal", school=4, level=28, cast=0, gcd=1.5, healDuration=12, components={{low=42, high=42, ticks=4, sp=0.2}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Rejuvenation 5
    [3627] = {kind="heal", school=4, level=34, cast=0, gcd=1.5, healDuration=12, components={{low=51, high=51, ticks=4, sp=0.2}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Rejuvenation 6
    [8910] = {kind="heal", school=4, level=40, cast=0, gcd=1.5, healDuration=12, components={{low=71, high=71, ticks=4, sp=0.2}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Rejuvenation 7
    [9839] = {kind="heal", school=4, level=46, cast=0, gcd=1.5, healDuration=12, components={{low=94, high=94, ticks=4, sp=0.2}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Rejuvenation 8
    [9840] = {kind="heal", school=4, level=52, cast=0, gcd=1.5, healDuration=12, components={{low=124, high=124, ticks=4, sp=0.2}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Rejuvenation 9
    [9841] = {kind="heal", school=4, level=58, cast=0, gcd=1.5, healDuration=12, components={{low=161, high=161, ticks=4, sp=0.2}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Rejuvenation 10
    [25299] = {kind="heal", school=4, level=60, cast=0, gcd=1.5, healDuration=12, components={{low=194, high=194, ticks=4, sp=0.2}, {low=0, high=0, spirit=1, talent=1328621}}}, -- Rejuvenation 11
    [139] = {kind="heal", school=2, level=8, cast=0, gcd=1.5, healDuration=15, components={{low=9, high=9, ticks=5, sp=0.2}}}, -- Renew 1
    [6074] = {kind="heal", school=2, level=14, cast=0, gcd=1.5, healDuration=15, components={{low=15, high=15, ticks=5, sp=0.2}}}, -- Renew 2
    [6075] = {kind="heal", school=2, level=20, cast=0, gcd=1.5, healDuration=15, components={{low=25, high=25, ticks=5, sp=0.2}}}, -- Renew 3
    [6076] = {kind="heal", school=2, level=26, cast=0, gcd=1.5, healDuration=15, components={{low=32, high=32, ticks=5, sp=0.2}}}, -- Renew 4
    [6077] = {kind="heal", school=2, level=32, cast=0, gcd=1.5, healDuration=15, components={{low=41, high=41, ticks=5, sp=0.2}}}, -- Renew 5
    [6078] = {kind="heal", school=2, level=38, cast=0, gcd=1.5, healDuration=15, components={{low=54, high=54, ticks=5, sp=0.2}}}, -- Renew 6
    [10927] = {kind="heal", school=2, level=44, cast=0, gcd=1.5, healDuration=15, components={{low=74, high=74, ticks=5, sp=0.2}}}, -- Renew 7
    [10928] = {kind="heal", school=2, level=50, cast=0, gcd=1.5, healDuration=15, components={{low=102, high=102, ticks=5, sp=0.2}}}, -- Renew 8
    [10929] = {kind="heal", school=2, level=56, cast=0, gcd=1.5, healDuration=15, components={{low=134, high=134, ticks=5, sp=0.2}}}, -- Renew 9
    [25315] = {kind="heal", school=2, level=60, cast=0, gcd=1.5, healDuration=15, components={{low=166, high=166, ticks=5, sp=0.2}}}, -- Renew 10
    [425268] = {kind="heal", school=2, level=8, cast=0, gcd=1.5, healDuration=15, components={{low=9, high=9, ticks=5, sp=0.1265}}}, -- Renew 1
    [425269] = {kind="heal", school=2, level=14, cast=0, gcd=1.5, healDuration=15, components={{low=20, high=20, ticks=5, sp=0.17825}}}, -- Renew 2
    [425270] = {kind="heal", school=2, level=20, cast=0, gcd=1.5, healDuration=15, components={{low=35, high=35, ticks=5, sp=0.23}}}, -- Renew 3
    [425271] = {kind="heal", school=2, level=26, cast=0, gcd=1.5, healDuration=15, components={{low=49, high=49, ticks=5, sp=0.23}}}, -- Renew 4
    [425272] = {kind="heal", school=2, level=32, cast=0, gcd=1.5, healDuration=15, components={{low=63, high=63, ticks=5, sp=0.23}}}, -- Renew 5
    [425273] = {kind="heal", school=2, level=38, cast=0, gcd=1.5, healDuration=15, components={{low=80, high=80, ticks=5, sp=0.23}}}, -- Renew 6
    [425274] = {kind="heal", school=2, level=44, cast=0, gcd=1.5, healDuration=15, components={{low=102, high=102, ticks=5, sp=0.23}}}, -- Renew 7
    [425275] = {kind="heal", school=2, level=50, cast=0, gcd=1.5, healDuration=15, components={{low=130, high=130, ticks=5, sp=0.23}}}, -- Renew 8
    [425276] = {kind="heal", school=2, level=56, cast=0, gcd=1.5, healDuration=15, components={{low=162, high=162, ticks=5, sp=0.23}}}, -- Renew 9
    [425277] = {kind="heal", school=2, level=60, cast=0, gcd=1.5, healDuration=15, components={{low=194, high=194, ticks=5, sp=0.23}}}, -- Renew 10
    [408521] = {kind="heal", school=4, level=40, cast=0, gcd=1.5, healDuration=15, components={{low=89, high=89, ticks=5, sp=0.1}}}, -- Riptide 1
    [1239242] = {kind="heal", school=4, level=50, cast=0, gcd=1.5, healDuration=15, components={{low=115, high=115, ticks=5, sp=0.1}}}, -- Riptide 2
    [1239243] = {kind="heal", school=4, level=60, cast=0, gcd=1.5, healDuration=15, components={{low=161, high=161, ticks=5, sp=0.1, perLevel=3.7, baseLevel=60, maxLevel=68}}}, -- Riptide 3
    [2948] = {kind="damage", school=3, level=22, cast=1.5, gcd=1.5, components={{low=35.0339, high=42.9661, sp=0.429, perLevel=0.8, baseLevel=22, maxLevel=26}}}, -- Scorch 1
    [8444] = {kind="damage", school=3, level=28, cast=1.5, gcd=1.5, components={{low=49.82353, high=60.17647, sp=0.429, perLevel=1, baseLevel=28, maxLevel=32}}}, -- Scorch 2
    [8445] = {kind="damage", school=3, level=34, cast=1.5, gcd=1.5, components={{low=62.72727, high=75.27273, sp=0.429, perLevel=1, baseLevel=34, maxLevel=38}}}, -- Scorch 3
    [8446] = {kind="damage", school=3, level=40, cast=1.5, gcd=1.5, components={{low=84.71918, high=101.2808, sp=0.429, perLevel=1.2, baseLevel=40, maxLevel=44}}}, -- Scorch 4
    [10205] = {kind="damage", school=3, level=46, cast=1.5, gcd=1.5, components={{low=106.1695, high=125.8305, sp=0.429, perLevel=1.4, baseLevel=46, maxLevel=50}}}, -- Scorch 5
    [10206] = {kind="damage", school=3, level=52, cast=1.5, gcd=1.5, components={{low=136.6438, high=163.3562, sp=0.429, perLevel=1.5, baseLevel=52, maxLevel=56}}}, -- Scorch 6
    [10207] = {kind="damage", school=3, level=58, cast=1.5, gcd=1.5, components={{low=163.2835, high=192.7165, sp=0.429, perLevel=1.7, baseLevel=58, maxLevel=62}}}, -- Scorch 7
    [5676] = {kind="damage", school=3, level=18, cast=1.5, gcd=1.5, components={{low=20.57895, high=25.42105, sp=0.429, perLevel=0.6, baseLevel=18, maxLevel=24}}}, -- Searing Pain 1
    [17919] = {kind="damage", school=3, level=26, cast=1.5, gcd=1.5, components={{low=29.95385, high=36.04615, sp=0.429, perLevel=0.7, baseLevel=26, maxLevel=32}}}, -- Searing Pain 2
    [17920] = {kind="damage", school=3, level=34, cast=1.5, gcd=1.5, components={{low=39.83158, high=48.16842, sp=0.429, perLevel=0.8, baseLevel=34, maxLevel=40}}}, -- Searing Pain 3
    [17921] = {kind="damage", school=3, level=42, cast=1.5, gcd=1.5, components={{low=56.44776, high=67.55224, sp=0.429, perLevel=0.9, baseLevel=42, maxLevel=48}}}, -- Searing Pain 4
    [17922] = {kind="damage", school=3, level=50, cast=1.5, gcd=1.5, components={{low=77.63006, high=92.36994, sp=0.429, perLevel=1, baseLevel=50, maxLevel=56}}}, -- Searing Pain 5
    [17923] = {kind="damage", school=3, level=58, cast=1.5, gcd=1.5, components={{low=104.7568, high=123.2432, sp=0.429, perLevel=1.2, baseLevel=58, maxLevel=64}}}, -- Searing Pain 6
    [1978] = {kind="damage", school=4, cast=0, gcd=1.5, damageDuration=15, components={{low=3, high=3, ticks=5, rap=0.05}}}, -- Serpent Sting 1
    [13549] = {kind="damage", school=4, cast=0, gcd=1.5, damageDuration=15, components={{low=7, high=7, ticks=5, rap=0.05}}}, -- Serpent Sting 2
    [13550] = {kind="damage", school=4, cast=0, gcd=1.5, damageDuration=15, components={{low=14, high=14, ticks=5, rap=0.05}}}, -- Serpent Sting 3
    [13551] = {kind="damage", school=4, cast=0, gcd=1.5, damageDuration=15, components={{low=26, high=26, ticks=5, rap=0.05}}}, -- Serpent Sting 4
    [13552] = {kind="damage", school=4, cast=0, gcd=1.5, damageDuration=15, components={{low=40, high=40, ticks=5, rap=0.05}}}, -- Serpent Sting 5
    [13553] = {kind="damage", school=4, cast=0, gcd=1.5, damageDuration=15, components={{low=58, high=58, ticks=5, rap=0.05}}}, -- Serpent Sting 6
    [13554] = {kind="damage", school=4, cast=0, gcd=1.5, damageDuration=15, components={{low=75, high=75, ticks=5, rap=0.05}}}, -- Serpent Sting 7
    [13555] = {kind="damage", school=4, cast=0, gcd=1.5, damageDuration=15, components={{low=100, high=100, ticks=5, rap=0.05}}}, -- Serpent Sting 8
    [25295] = {kind="damage", school=4, cast=0, gcd=1.5, damageDuration=15, components={{low=135, high=135, ticks=5, rap=0.05}}}, -- Serpent Sting 9
    [686] = {kind="damage", school=6, level=1, cast=1.7, gcd=1.5, components={{low=11.14286, high=14.85714, sp=0.486, perLevel=0.2, baseLevel=1, maxLevel=5}}}, -- Shadow Bolt 1
    [695] = {kind="damage", school=6, level=6, cast=2.2, gcd=1.5, components={{low=20.34615, high=25.65385, sp=0.629, perLevel=0.3, baseLevel=6, maxLevel=11}}}, -- Shadow Bolt 2
    [705] = {kind="damage", school=6, level=12, cast=2.8, gcd=1.5, components={{low=36.92308, high=43.07692, sp=0.8, perLevel=0.6, baseLevel=12, maxLevel=17}}}, -- Shadow Bolt 3
    [1088] = {kind="damage", school=6, level=20, cast=3, gcd=1.5, components={{low=54.21739, high=61.78261, sp=0.857, perLevel=0.8, baseLevel=20, maxLevel=25}}}, -- Shadow Bolt 4
    [1106] = {kind="damage", school=6, level=28, cast=3, gcd=1.5, components={{low=72.86842, high=83.13158, sp=0.857, perLevel=1.2, baseLevel=28, maxLevel=33}}}, -- Shadow Bolt 5
    [7641] = {kind="damage", school=6, level=36, cast=3, gcd=1.5, components={{low=94.94931, high=107.0507, sp=0.857, perLevel=1.2, baseLevel=36, maxLevel=41}}}, -- Shadow Bolt 6
    [11659] = {kind="damage", school=6, level=44, cast=3, gcd=1.5, components={{low=132.9564, high=149.0436, sp=0.857, perLevel=1.4, baseLevel=44, maxLevel=49}}}, -- Shadow Bolt 7
    [11660] = {kind="damage", school=6, level=52, cast=3, gcd=1.5, components={{low=180.4724, high=201.5276, sp=0.857, perLevel=1.6, baseLevel=52, maxLevel=57}}}, -- Shadow Bolt 8
    [11661] = {kind="damage", school=6, level=60, cast=3, gcd=1.5, components={{low=237.4324, high=264.5676, sp=0.857, perLevel=1.8, baseLevel=60, maxLevel=65}}}, -- Shadow Bolt 9
    [25307] = {kind="damage", school=6, level=60, cast=3, gcd=1.5, components={{low=253.2863, high=282.7137, sp=0.857, perLevel=1.9, baseLevel=60, maxLevel=65}}}, -- Shadow Bolt 10
    [401955] = {kind="damage", school=6, ranked=false, cast=0, gcd=1.5, components={{low=3.2, high=3.72, sp=0.429, curve={9.456667, 0.635108, 0.039063}}}}, -- Shadow Word: Death
    [1309595] = {kind="damage", school=6, level=32, cast=0, gcd=1.5, components={{low=286.0763, high=303.9238, sp=0.429, perLevel=1.5, baseLevel=32, maxLevel=37}}}, -- Shadow Word: Death 1
    [1309633] = {kind="damage", school=6, level=40, cast=0, gcd=1.5, components={{low=358.8075, high=381.1925, sp=0.429, perLevel=1.9, baseLevel=40, maxLevel=45}}}, -- Shadow Word: Death 2
    [1309635] = {kind="damage", school=6, level=48, cast=0, gcd=1.5, components={{low=390.8093, high=415.1908, sp=0.429, perLevel=2.2, baseLevel=48, maxLevel=53}}}, -- Shadow Word: Death 3
    [1309636] = {kind="damage", school=6, level=56, cast=0, gcd=1.5, components={{low=434.448, high=461.552, sp=0.429, perLevel=2.5, baseLevel=56, maxLevel=61}}}, -- Shadow Word: Death 4
    [589] = {kind="damage", school=6, level=4, cast=0, gcd=1.5, damageDuration=18, components={{low=5, high=5, ticks=6, sp=0.2}}}, -- Shadow Word: Pain 1
    [594] = {kind="damage", school=6, level=10, cast=0, gcd=1.5, damageDuration=18, components={{low=10, high=10, ticks=6, sp=0.2}}}, -- Shadow Word: Pain 2
    [970] = {kind="damage", school=6, level=18, cast=0, gcd=1.5, damageDuration=18, components={{low=18, high=18, ticks=6, sp=0.2}}}, -- Shadow Word: Pain 3
    [992] = {kind="damage", school=6, level=26, cast=0, gcd=1.5, damageDuration=18, components={{low=30, high=30, ticks=6, sp=0.2}}}, -- Shadow Word: Pain 4
    [2767] = {kind="damage", school=6, level=34, cast=0, gcd=1.5, damageDuration=18, components={{low=48, high=48, ticks=6, sp=0.2}}}, -- Shadow Word: Pain 5
    [10892] = {kind="damage", school=6, level=42, cast=0, gcd=1.5, damageDuration=18, components={{low=71, high=71, ticks=6, sp=0.2}}}, -- Shadow Word: Pain 6
    [10893] = {kind="damage", school=6, level=50, cast=0, gcd=1.5, damageDuration=18, components={{low=97, high=97, ticks=6, sp=0.2}}}, -- Shadow Word: Pain 7
    [10894] = {kind="damage", school=6, level=58, cast=0, gcd=1.5, damageDuration=18, components={{low=127, high=127, ticks=6, sp=0.2}}}, -- Shadow Word: Pain 8
    [17877] = {kind="damage", school=6, level=20, cast=0, gcd=1.5, components={{low=61.74194, high=70.25806, sp=0.429, perLevel=0.9, baseLevel=20, maxLevel=24}}}, -- Shadowburn 1
    [18867] = {kind="damage", school=6, level=24, cast=0, gcd=1.5, components={{low=74.79675, high=85.20325, sp=0.429, perLevel=1, baseLevel=24, maxLevel=30}}}, -- Shadowburn 2
    [18868] = {kind="damage", school=6, level=32, cast=0, gcd=1.5, components={{low=110.8485, high=125.1515, sp=0.429, perLevel=1.3, baseLevel=32, maxLevel=38}}}, -- Shadowburn 3
    [18869] = {kind="damage", school=6, level=40, cast=0, gcd=1.5, components={{low=139.4513, high=156.5487, sp=0.429, perLevel=1.3, baseLevel=40, maxLevel=46}}}, -- Shadowburn 4
    [18870] = {kind="damage", school=6, level=48, cast=0, gcd=1.5, components={{low=191.5094, high=214.4906, sp=0.429, perLevel=1.6, baseLevel=48, maxLevel=54}}}, -- Shadowburn 5
    [18871] = {kind="damage", school=6, level=56, cast=0, gcd=1.5, components={{low=251.4706, high=280.5294, sp=0.429, perLevel=1.8, baseLevel=56, maxLevel=62}}}, -- Shadowburn 6
    [18265] = {kind="damage", school=6, level=30, cast=0, gcd=1.5, damageDuration=30, healDuration=30, components={{low=11, high=11, ticks=10, sp=0.05, leech=1}}}, -- Siphon Life 1
    [18879] = {kind="damage", school=6, level=38, cast=0, gcd=1.5, damageDuration=30, healDuration=30, components={{low=19, high=19, ticks=10, sp=0.05, leech=1}}}, -- Siphon Life 2
    [18880] = {kind="damage", school=6, level=48, cast=0, gcd=1.5, damageDuration=30, healDuration=30, components={{low=29, high=29, ticks=10, sp=0.05, leech=1}}}, -- Siphon Life 3
    [18881] = {kind="damage", school=6, level=58, cast=0, gcd=1.5, damageDuration=30, healDuration=30, components={{low=41, high=41, ticks=10, sp=0.05, leech=1}}}, -- Siphon Life 4
    [585] = {kind="damage", school=2, level=1, cast=1.5, gcd=1.5, components={{low=13, high=17, sp=0.429, perLevel=0.1, baseLevel=1, maxLevel=6}}}, -- Smite 1
    [591] = {kind="damage", school=2, level=6, cast=2, gcd=1.5, components={{low=24.10714, high=29.89286, sp=0.571, perLevel=0.3, baseLevel=6, maxLevel=11}}}, -- Smite 2
    [598] = {kind="damage", school=2, level=14, cast=2.5, gcd=1.5, components={{low=41.89655, high=48.10345, sp=0.714, perLevel=0.5, baseLevel=14, maxLevel=19}}}, -- Smite 3
    [984] = {kind="damage", school=2, level=22, cast=2.5, gcd=1.5, components={{low=55.71429, high=64.28571, sp=0.714, perLevel=0.7, baseLevel=22, maxLevel=27}}}, -- Smite 4
    [1004] = {kind="damage", school=2, level=30, cast=2.5, gcd=1.5, components={{low=75.9375, high=86.0625, sp=0.714, perLevel=1, baseLevel=30, maxLevel=35}}}, -- Smite 5
    [6060] = {kind="damage", school=2, level=38, cast=2.5, gcd=1.5, components={{low=88.17699, high=99.82301, sp=0.714, perLevel=1.1, baseLevel=38, maxLevel=43}}}, -- Smite 6
    [10933] = {kind="damage", school=2, level=46, cast=2.5, gcd=1.5, components={{low=118.5639, high=133.4361, sp=0.714, perLevel=1.1, baseLevel=46, maxLevel=51}}}, -- Smite 7
    [10934] = {kind="damage", school=2, level=54, cast=2.5, gcd=1.5, components={{low=160.4835, high=179.5165, sp=0.714, perLevel=1.3, baseLevel=54, maxLevel=59}}}, -- Smite 8
    [6353] = {kind="damage", school=3, level=48, cast=6, gcd=1.5, components={{low=334.0982, high=419.9018, sp=1, perLevel=1.7, baseLevel=48, maxLevel=54}}}, -- Soul Fire 1
    [17924] = {kind="damage", school=3, level=56, cast=6, gcd=1.5, components={{low=382.5669, high=479.4331, sp=1, perLevel=1.9, baseLevel=56, maxLevel=62}}}, -- Soul Fire 2
    [2912] = {kind="damage", school=7, level=20, cast=3.5, gcd=1.5, components={{low=101.5859, high=124.4141, sp=1, perLevel=1.8, baseLevel=20, maxLevel=25}}}, -- Starfire 1
    [8949] = {kind="damage", school=7, level=26, cast=3.5, gcd=1.5, components={{low=138.8026, high=169.1974, sp=1, perLevel=2.1, baseLevel=26, maxLevel=32}}}, -- Starfire 2
    [8950] = {kind="damage", school=7, level=34, cast=3.5, gcd=1.5, components={{low=182.81, high=219.19, sp=1, perLevel=2.2, baseLevel=34, maxLevel=40}}}, -- Starfire 3
    [8951] = {kind="damage", school=7, level=42, cast=3.5, gcd=1.5, components={{low=252.6384, high=301.3616, sp=1, perLevel=2.5, baseLevel=42, maxLevel=48}}}, -- Starfire 4
    [9875] = {kind="damage", school=7, level=50, cast=3.5, gcd=1.5, components={{low=340.9215, high=403.0785, sp=1, perLevel=3, baseLevel=50, maxLevel=56}}}, -- Starfire 5
    [9876] = {kind="damage", school=7, level=58, cast=3.5, gcd=1.5, components={{low=432.1546, high=509.8454, sp=1, perLevel=3.2, baseLevel=58, maxLevel=64}}}, -- Starfire 6
    [25298] = {kind="damage", school=7, level=60, cast=3.5, gcd=1.5, components={{low=489.5704, high=576.4296, sp=1, perLevel=3.4, baseLevel=60, maxLevel=66}}}, -- Starfire 7
    [10797] = {kind="damage", school=7, level=10, cast=0, gcd=1.5, channel=6, components={{low=27, high=27, ticks=6, sp=0.167}}}, -- Starshards 1
    [19296] = {kind="damage", school=7, level=18, cast=0, gcd=1.5, channel=6, components={{low=50, high=50, ticks=6, sp=0.167}}}, -- Starshards 2
    [19299] = {kind="damage", school=7, level=26, cast=0, gcd=1.5, channel=6, components={{low=88, high=88, ticks=6, sp=0.167}}}, -- Starshards 3
    [19302] = {kind="damage", school=7, level=34, cast=0, gcd=1.5, channel=6, components={{low=127, high=127, ticks=6, sp=0.167}}}, -- Starshards 4
    [19303] = {kind="damage", school=7, level=42, cast=0, gcd=1.5, channel=6, components={{low=178, high=178, ticks=6, sp=0.167}}}, -- Starshards 5
    [19304] = {kind="damage", school=7, level=50, cast=0, gcd=1.5, channel=6, components={{low=240, high=240, ticks=6, sp=0.167}}}, -- Starshards 6
    [19305] = {kind="damage", school=7, level=58, cast=0, gcd=1.5, channel=6, components={{low=300, high=300, ticks=6, sp=0.167}}}, -- Starshards 7
    [417157] = {kind="damage", school=7, ranked=false, cast=0, gcd=1.5, components={{low=2.48, high=3.04, sp=0.429, curve={9.183105, 0.616405, 0.028608}}}}, -- Starsurge
    [414684] = {kind="damage", school=4, ranked=false, cast=0, gcd=1.5, damageDuration=12, components={{low=0.65, high=0.65, ticks=4, sp=0.13, curve={9.183105, 0.616405, 0.028608}}, {low=1.3, high=1.52, sp=0.15, curve={9.183105, 0.616405, 0.028608}}}}, -- Sunfire
    [18562] = {kind="heal", school=4, ranked=false, cast=0, gcd=1.5, components={}}, -- Swiftmend
    [1311015] = {kind="absorb", school=2, ranked=false, cast=0, gcd=0, components={{low=0, high=0, health=1}}}, -- Templar's Bulwark
    [740] = {kind="heal", school=4, level=30, cast=0, gcd=1.5, channel=10, components={{low=87, high=87, ticks=5, sp=0.067, perLevel=0.6, baseLevel=30, maxLevel=36}}}, -- Tranquility 1
    [8918] = {kind="heal", school=4, level=40, cast=0, gcd=1.5, channel=10, components={{low=129, high=129, ticks=5, sp=0.067, perLevel=0.7, baseLevel=40, maxLevel=46}}}, -- Tranquility 2
    [9862] = {kind="heal", school=4, level=50, cast=0, gcd=1.5, channel=10, components={{low=196, high=196, ticks=5, sp=0.067, perLevel=0.9, baseLevel=50, maxLevel=56}}}, -- Tranquility 3
    [9863] = {kind="heal", school=4, level=60, cast=0, gcd=1.5, channel=10, components={{low=285, high=285, ticks=5, sp=0.067, perLevel=1, baseLevel=60, maxLevel=66}}}, -- Tranquility 4
    [402668] = {kind="damage", school=6, ranked=false, cast=1.5, gcd=1.5, damageDuration=15, components={{low=0.65, high=0.65, ticks=5, sp=0.167, curve={9.456667, 0.635108, 0.039063}}}}, -- Vampiric Touch
    [402927] = {kind="damage", school=1, ranked=false, cast=0, gcd=1.5, components={{low=1, high=1, ap=0.15}, {kind="heal", low=0, high=0, health=0.1}}}, -- Victory Rush
    [425204] = {kind="damage", school=6, ranked=false, cast=0, gcd=1.5, damageDuration=18, components={{low=1.29, high=1.29, ticks=6, sp=0.166, curve={9.456667, 0.635108, 0.039063}}}}, -- Void Plague
    [408120] = {kind="heal", school=4, level=40, cast=3, gcd=1.5, healDuration=7, components={{low=40, high=40, ticks=7, sp=0.066, perLevel=1, baseLevel=40, maxLevel=48}}}, -- Wild Growth 1
    [1238214] = {kind="heal", school=4, level=50, cast=3, gcd=1.5, healDuration=7, components={{low=60, high=60, ticks=7, sp=0.066, perLevel=1.3, baseLevel=50, maxLevel=58}}}, -- Wild Growth 2
    [1238215] = {kind="heal", school=4, level=60, cast=3, gcd=1.5, healDuration=7, components={{low=97, high=97, ticks=7, sp=0.066, perLevel=1.6, baseLevel=60, maxLevel=68}}}, -- Wild Growth 3
    [1316697] = {kind="damage", school=6, level=40, cast=0, gcd=1.5, channel=6, components={{low=25.2, high=25.2, ticks=6, sp=0.2002, perLevel=1.75, baseLevel=40, maxLevel=60}}}, -- Wrack 1
    [5176] = {kind="damage", school=4, level=1, cast=1.5, gcd=1.5, components={{low=13.84615, high=16.15385, sp=0.429, perLevel=0.2, baseLevel=1, maxLevel=5}}}, -- Wrath 1
    [5177] = {kind="damage", school=4, level=6, cast=1.7, gcd=1.5, components={{low=19.44444, high=22.55556, sp=0.486, perLevel=0.3, baseLevel=6, maxLevel=12}}}, -- Wrath 2
    [5178] = {kind="damage", school=4, level=14, cast=2, gcd=1.5, components={{low=27.5, high=32.5, sp=0.571, perLevel=0.5, baseLevel=14, maxLevel=20}}}, -- Wrath 3
    [5179] = {kind="damage", school=4, level=22, cast=2, gcd=1.5, components={{low=34.27941, high=39.72059, sp=0.571, perLevel=0.6, baseLevel=22, maxLevel=28}}}, -- Wrath 4
    [5180] = {kind="damage", school=4, level=30, cast=2, gcd=1.5, components={{low=42.08333, high=47.91667, sp=0.571, perLevel=0.7, baseLevel=30, maxLevel=36}}}, -- Wrath 5
    [6780] = {kind="damage", school=4, level=38, cast=2, gcd=1.5, components={{low=50.71622, high=57.28378, sp=0.571, perLevel=0.9, baseLevel=38, maxLevel=44}}}, -- Wrath 6
    [8905] = {kind="damage", school=4, level=46, cast=2, gcd=1.5, components={{low=64.24121, high=71.75879, sp=0.571, perLevel=0.9, baseLevel=46, maxLevel=52}}}, -- Wrath 7
    [9912] = {kind="damage", school=4, level=54, cast=2, gcd=1.5, components={{low=85.904, high=96.096, sp=0.571, perLevel=1, baseLevel=54, maxLevel=60}}}, -- Wrath 8
    [6229] = {kind="absorb", school=6, level=32, cast=0, gcd=1.5, components={{low=290, high=290}}}, -- Shadow Ward 1
    [11739] = {kind="absorb", school=6, level=42, cast=0, gcd=1.5, components={{low=470, high=470}}}, -- Shadow Ward 2
    [11740] = {kind="absorb", school=6, level=52, cast=0, gcd=1.5, components={{low=675, high=675}}}, -- Shadow Ward 3
    [28610] = {kind="absorb", school=6, level=60, cast=0, gcd=1.5, components={{low=920, high=920}}}, -- Shadow Ward 4
}
