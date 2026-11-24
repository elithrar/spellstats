"""Rebuild SpellData.lua from the pinned, unpacked inputs listed in its header.

Usage: python spell_data.py /path/to/gamedata /path/to/SpellPowerCoefficients > SpellData.lua
"""
from pathlib import Path
import math
import re
import sys

game, spc = map(Path, sys.argv[1:])
schools = "physical holy fire nature frost shadow arcane".split()
heals = set("""Binding Heal|Chain Heal|Circle of Healing|Desperate Prayer|Divine Grace|Divine Light|Flash Heal|Flash of Light|Greater Heal|Heal|Healing Rain|Healing Stream Totem|Healing Touch|Healing Wave|Holy Light|Holy Nova|Holy Shock|Lay on Hands|Lesser Heal|Lesser Healing Wave|Lifebloom|Lightwell|Mend Pet|Nourish|Penance|Prayer of Healing|Regeneration|Regrowth|Rejuvenation|Renew|Riptide|Swiftmend|Tranquility|Wild Growth""".split("|"))
damage = set("""Arcane Explosion|Arcane Missiles|Arcane Shot|Bane of Agony|Bane of Doom|Blast Wave|Blizzard|Bloodthirst|Chain Lightning|Cone of Cold|Corruption|Death Coil|Devouring Plague|Drain Life|Drain Soul|Earth Shock|Entangling Roots|Exorcism|Fire Blast|Fireball|Flame Shock|Flamestrike|Frost Nova|Frost Shock|Frostbolt|Hammer of Wrath|Holy Fire|Holy Wrath|Hurricane|Immolate|Insect Swarm|Lightning Bolt|Mind Blast|Mind Flay|Moonfire|Pyroblast|Rain of Fire|Scorch|Searing Pain|Serpent Sting|Shadow Bolt|Shadow Word: Pain|Shadowburn|Siphon Life|Smite|Soul Fire|Starfire|Starshards|Victory Rush|Wrath""".split("|"))


def lookup(pattern, text, default=None):
    m = re.search(pattern, text, re.M)
    return m[1] if m else default


heals.update({"Prayer of Mending", "Health Funnel"})
damage.update("""Wrack|Incinerate|Lava Burst|Ice Lance|Arcane Blast|Chastise|Frostfire Bolt|Chaos Bolt|Arcane Barrage|Mind Spike|Shadow Word: Death|Vampiric Touch|Void Plague|Starsurge|Sunfire|Molten Blast|Arcane Wrath|Conflagrate|Consecration""".split("|"))
# Learn levels from the build 70959 trainer data. Advanced Warding's
# friendly-target replacements occupy the corresponding trained ward ranks.
ward_levels = {"Fire Ward": (20, 30, 40, 50, 60), "Frost Ward": (22, 32, 42, 52, 60),
               "Mana Shield": (20, 28, 36, 44, 52, 60)}
shields = set(ward_levels) | {"Power Word: Shield", "Ice Barrier", "Templar's Bulwark"}
levels = {1312002:20, 400640:28, 1240044:34, 1240045:42, 1240046:48, 1240047:56}
levels.update({11426:40, 13031:46, 13032:52, 13033:58})
levels.update({401859:40, 1240826:50, 1240827:60})  # Prayer of Mending
levels.update({755:12, 3698:20, 3699:28, 3700:36, 11693:44, 11694:52, 11695:60})  # Health Funnel
caps = {}
for line in (spc / "Data.lua").read_text().splitlines():
    match = re.match(r'  \[(\d+)\] = { n=', line)
    if match:
        levels[int(match[1])] = int(lookup(r'\bl=(\d+)', line, 0))
for line in (spc / "BaseValues.lua").read_text().splitlines():
    match = re.match(r'\s*\[(\d+)\]=', line)
    if match:
        for kind, fields in re.findall(r'(\w+)=\{([^{}]+)\}', line):
            nums = [float(x) for x in fields.split(",")]
            caps[int(match[1]), kind] = int(nums[3]), int(nums[4])


class Spell:
    def __init__(self, block):
        self.block = block
        header = re.fullmatch(r"(\d+) (.+?)(?: \(Rank (\d+)\))?", block.splitlines()[0])
        self.id = int(header[1])
        self.name, self.rank = header[2], header[3]
        self.tooltip = lookup(r'^tooltip\s+(.+)', block, "")
        self.school = lookup(r'^school\s+(.+)', block)
        self.duration = float(lookup(r'^duration\s+([.\d]+) s', block, 0))
        # Arcane Shot and Serpent Sting use the export's negative cast-time sentinel.
        self.cast = max(0, float(lookup(r'^cast\s+(-?[.\d]+) s', block, 0)))
        self.gcd = float(lookup(r'^gcd\s+([.\d]+) s', block, 0))
        self.channeled = "channeled" in lookup(r'^attrs\s+(.+)', block, "").split(", ")
        self.effects = []
        for summary, raw in re.findall(r'^effect \d+  (.+)\n\s+(E_.+)$', block, re.M):
            params = {k: float(v) for k, v in re.findall(r'\b(\w+)=(-?[\d.]+)', raw)}
            self.effects.append((raw, summary, params))


book = {}
for path in sorted((game / "spells").glob("*/*.txt")):
    for block in path.read_text().split("======="):
        if block.strip():
            spell = Spell(block.strip())
            book[spell.id] = spell

for spell in book.values():
    trained = ward_levels.get(spell.name)
    if trained and spell.rank and 1 <= int(spell.rank) <= len(trained):
        levels.setdefault(spell.id, trained[int(spell.rank) - 1])


class UnknownEffect(Exception):
    """A required part of the cast cannot be reconstructed from these inputs."""


def measure(spell, parent, raw, summary, p, kind, ticks, curve=False):
    base = p["base"]
    if base <= 0 or not ticks or ticks != int(ticks):
        raise UnknownEffect
    variance = p.get("variance", 0) / 2
    unit = base * (0.01 if curve else 1)
    out = dict(kind=kind, low=unit * (1 - variance), high=unit * (1 + variance))
    if ticks != 1:
        out["ticks"] = int(ticks)
    # Preserve the elapsed time of measured pulses, including a single delayed
    # tick (Bane of Doom). An unrelated aura on a direct hit has no such period.
    if ticks > 1 or p.get("period"):
        out["delivery"] = spell.duration or parent.duration
    for coefficient in ("sp", "ap", "rap"):
        if p.get(coefficient):
            out[coefficient] = p[coefficient]
    if curve:
        variable = "healpower" if kind == "heal" else ("damagepower" if "$<damagepower>" in parent.tooltip else "power")
        pattern = rf'\${variable}=' + r'\$\{([\d.]+)\+([\d.]+)\*\$PL\+([\d.]+)\*\$PL\*\$PL\}'
        m = re.search(pattern, parent.block)
        if not m:
            raise UnknownEffect
        out["curve"] = [float(x) for x in m.groups()]
    if p.get("ppl"):
        key = {"heal": "h", "damage": "d", "absorb": "a"}[kind] + ("t" if "PERIODIC" in raw else "")
        limits = caps.get((spell.id, key))
        if not limits:
            # Pulse spells sometimes store the rank levels on the cast record.
            limits = caps.get((parent.id, key + "t"))
        if not limits:
            # Recover the cap only when the displayed level-60 amount has a
            # unique solution given the rank level, variance and per-level term.
            start = levels.get(parent.id)
            displayed = re.match(r"(?:absorbs )?([\d.]+)(?:–([\d.]+))?", summary)
            candidates = []
            if start and displayed and "at level 60" in summary:
                for cap in range(start, 61):
                    extra = (cap - start) * p["ppl"]
                    if displayed[2]:
                        matches = (math.floor(out["low"] + extra + 1e-5) == float(displayed[1])
                                   and math.ceil(out["high"] + extra - 1e-5) == float(displayed[2]))
                    elif kind == "absorb":
                        # Unlike numeric direct hits, the export renders shield
                        # capacities as whole points (447 for 431 + 6 * 2.8).
                        matches = math.floor(base + extra + 1e-5) == float(displayed[1])
                    else:
                        matches = abs(base + extra - float(displayed[1])) < .006
                    if matches:
                        candidates.append(cap)
            if len(candidates) != 1:
                raise UnknownEffect
            limits = start, candidates[0]
        start, stop = limits
        out.update(perLevel=p["ppl"], baseLevel=start)
        if stop:
            out["maxLevel"] = stop
    return out


def direct_effects(spell, parent, repeats=1):
    output = []
    for raw, summary, p in spell.effects:
        if raw.startswith("E_HEAL ") or " A_PERIODIC_HEAL " in raw:
            kind = "heal"
        elif raw.startswith(("E_SCHOOL_DAMAGE ", "E_HEALTH_LEECH ")) or re.search(r' A_PERIODIC_(DAMAGE|LEECH) ', raw):
            kind = "damage"
        elif (spell.name in shields and raw.startswith(("E_APPLY_AURA A_SCHOOL_ABSORB ", "E_APPLY_AURA A_MANA_SHIELD "))
              and 0 < p.get("misc", 0) <= 127):
            # The school mask restricts incoming hits that can consume this
            # single shield. Each target gets one pool, even for mask 127.
            kind = "absorb"
        else:
            continue
        # Binding Heal duplicates the same amount onto the caster.
        if spell.name == "Binding Heal" and "target=[1,0]" in raw:
            continue
        if spell.name == "Health Funnel" and "target=[1,0]" in raw:
            continue  # The caster pays health. Only the pet receives the spell's heal.
        if p.get("period"):
            period = p["period"] / 1000
            ticks = (spell.duration or parent.duration) / period
        else:
            ticks = repeats
        curve = (parent.name in {"Nourish", "Divine Light", "Circle of Healing", "Healing Rain", "Lifebloom"}
                 and "$<healpower>" in parent.tooltip)
        if kind == "damage" and parent.name in {"Chaos Bolt", "Arcane Barrage", "Mind Spike", "Shadow Word: Death",
                                                 "Vampiric Touch", "Void Plague", "Starsurge", "Sunfire", "Molten Blast"}:
            curve = "$<damagepower>" in parent.tooltip or "$<power>" in parent.tooltip
        effect = measure(spell, parent, raw, summary, p, kind, ticks, curve)
        if kind == "absorb":
            if "$s1% of your maximum health" in spell.tooltip:
                effect = dict(kind=kind, low=0, high=0, health=p["base"] / 100)
            frost_share = lookup(r'\$SPFR\*([\d.]+)', spell.tooltip)
            if frost_share:
                # This explicit tooltip term uses the caster's Frost damage
                # bonus, separate from ordinary ranked spell coefficients.
                effect.update(sp=float(frost_share), school=schools.index("frost") + 1, fullPower=True)
        if raw.startswith("E_HEALTH_LEECH ") or " A_PERIODIC_LEECH " in raw:
            # The client calls this field EffectAmplitude. It multiplies damage
            # actually dealt to obtain the caster's healing on each hit or tick.
            if p.get("amplitude", 0) <= 0:
                raise UnknownEffect
            effect["leech"] = p["amplitude"]
        output.append(effect)
    return output


def components(spell):
    name = spell.name
    if name == "Prayer of Mending":
        # The cast stores the heal for one target in its first dummy effect.
        # Jumps can reach other targets only after subsequent qualifying events.
        return [measure(spell, spell, *spell.effects[0], "heal", 1)]
    if name == "Swiftmend":
        return []  # Depends on which HoT the caster has on this target.
    if name == "Lay on Hands":
        return [dict(kind="heal", low=0, high=0, health=1)]
    if name == "Victory Rush":
        return [dict(kind="damage", low=1, high=1, ap=.15), dict(kind="heal", low=0, high=0, health=.10)]
    if name == "Bloodthirst":
        base, percent = [e[2]["base"] for e in spell.effects[:2]]
        return [dict(kind="damage", low=base, high=base, ap=percent/100)]
    if name in {"Lifebloom", "Regeneration"}:
        if name == "Lifebloom":
            hot, bloom = spell.effects[:2]
            return [measure(spell, spell, *hot, "heal", 7, True),
                    measure(spell, spell, *bloom, "heal", 1, True)]
        return [measure(spell, spell, *spell.effects[0], "heal", 3, True)]
    out = direct_effects(spell, spell)
    if out and name in {"Regrowth", "Rejuvenation"}:
        out.append(dict(kind="heal", low=0, high=0, spirit=1, talent=1328621))
    if out and name == "Arcane Shot":
        out[0]["rap"] = 0.15
    if out and name == "Serpent Sting" and spell.duration == 15:
        out[0]["rap"] = .25 / out[0]["ticks"]
    if out and name == "Molten Blast":
        out[0]["ap"] = spell.effects[1][2]["base"] / 100
    if out and name == "Arcane Wrath":
        out[0]["manaPower"] = spell.effects[1][2]["base"] / 100
    # Resolve the effect-ID references from the cast's localized template
    # (record IDs and effect slots are stable across locales).
    hit_ids = re.findall(r'\$(\d+)[smo]1\b', spell.tooltip)
    if name in {"Holy Nova", "Holy Shock", "Penance", "Lightwell", "Blizzard", "Hurricane",
                "Flamestrike", "Rain of Fire", "Healing Rain", "Healing Stream Totem", "Arcane Missiles", "Consecration"}:
        for hit_id in dict.fromkeys(hit_ids):
            helper = book.get(int(hit_id))
            if not helper:
                raise UnknownEffect
            repeats = {"Penance": 3, "Flamestrike": 4, "Rain of Fire": 4}.get(name, 1)
            if name in {"Blizzard", "Hurricane", "Arcane Missiles", "Healing Rain"}:
                repeats = spell.duration
            if name == "Consecration":
                # A lone enemy receives both the common pulse and the bonus
                # for the first four enemies. Each repeats on the cast's periodic aura.
                repeats = spell.duration / (spell.effects[2][2]["period"] / 1000)
            out.extend(direct_effects(helper, spell, repeats))
    return out


def timing(spell, effects):
    rank = dict(cast=spell.cast, gcd=spell.gcd)
    if spell.channeled:
        channel = spell.duration
        if not channel:
            # Penance's cast references the actual channel aura via $402261d.
            helpers = (book.get(int(ref)) for ref in re.findall(r'\$(\d+)d\b', spell.tooltip))
            durations = {aura.duration for aura in helpers if aura and aura.channeled and aura.duration}
            if len(durations) != 1:
                raise ValueError(f"Unresolved channel duration for {spell.id}")
            channel = durations.pop()
        rank["channel"] = channel

    for effect in effects:
        duration = effect.pop("delivery", 0)
        if duration and not spell.channeled:
            key = effect["kind"] + "Duration"
            rank[key] = max(rank.get(key, 0), duration)
            if effect.get("leech"):
                rank["healDuration"] = max(rank.get("healDuration", 0), duration)

    return rank


def literal(v):
    if isinstance(v, str):
        return '"' + v + '"'
    if v is True:
        return "true"
    if v is False:
        return "false"
    if isinstance(v, dict):
        return "{" + ", ".join(k + "=" + literal(x) for k, x in v.items()) + "}"
    if isinstance(v, list):
        return "{" + ", ".join(map(literal, v)) + "}"
    return format(v, ".7g")


def emit(spell_id, name, rank, record):
    label = f"{name} {rank}" if rank else name
    print(f'    [{spell_id}] = {literal(record)}, -- {label}')


print("""-- Numeric spell effects and base timing (seconds) from the Blizzard Forever 1.60.1.71037 client export:
-- https://github.com/wowsims/gamedata/tree/0c2b3f0dff123ea052afd3dbef43c1490907d419/spells
-- Learn levels and per-level caps from SpellPowerCoefficients 1.0.2 (70888/70862):
-- https://www.curseforge.com/wow/addons/spc-forever/files/9739224
-- Hunter RAP shares (15% Arcane Shot; 25% over 5 Serpent Sting ticks) and supplemental trainer levels:
-- https://www.curseforge.com/wow/addons/dynamictooltips/files/9705865
-- Shadow Ward rank values missing from the primary export: https://foreverdb.net/spell/6229 (71037).
-- Effect and timing: https://db.icy-veins.com/wow-forever/spells/6229 (and the other rank IDs).
-- See THIRD-PARTY.txt for attribution. Regenerate with tools/spell_data.py.
local _, ns = ...
ns.SpellData = {""")
for spell in sorted(book.values(), key=lambda s: (s.name, s.id)):
    if spell.name not in heals | damage | shields or not spell.school or not spell.tooltip:
        continue
    if not re.search(r'^cost |^gcd ', spell.block, re.M):
        continue
    if spell.id not in levels and spell.name not in {"Lifebloom", "Bloodthirst", "Victory Rush", "Arcane Shot",
                                                     "Lay on Hands", "Lightwell", "Swiftmend", "Healing Rain", "Serpent Sting", "Templar's Bulwark"}:
        continue
    if spell.name == "Victory Rush" and spell.id != 402927:
        continue
    try:
        out = components(spell)
    except UnknownEffect:
        out = []
    if not out and spell.name not in heals:
        continue
    kind = "heal" if spell.name in heals else "absorb" if spell.name in shields else "damage"
    indices = [schools.index(name) + 1 for name in spell.school.split("+")]
    record = dict(kind=kind, school=indices[0])
    if len(indices) > 1:
        record["schools"] = indices
    if levels.get(spell.id):
        record["level"] = levels[spell.id]
    if not spell.rank:
        record["ranked"] = False
    if spell.name == "Lay on Hands":
        record["allMana"] = True
    if spell.name == "Mana Shield":
        record["conditionalMana"] = True
    if spell.name == "Prayer of Mending":
        record["triggeredHeal"] = True
        record["healTalents"] = [1225132, 14898]  # $twinD * $spiritualH in all three cast tooltips
    if spell.name == "Renew":
        record["healTalents"] = [14908, 1225132, 14898]  # Improved Renew, Twin Disciplines, Spiritual Healing
    if spell.name == "Arcane Missiles":
        record["channelAura"] = 400589  # Missile Barrage shortens the channel and the missile interval
    if spell.name == "Power Word: Shield":
        record["absorbTalent"] = 14748  # Improved Power Word: Shield
    elif "$11189s3" in spell.tooltip and kind == "absorb":
        record["absorbTalent"] = 11189  # Frost Warding, on its trained spells
    record.update(timing(spell, out))
    for c in out:
        if c["kind"] == kind:
            del c["kind"]
    record["components"] = out
    emit(spell.id, spell.name, spell.rank, record)

# The pinned class export omits this trained Warlock ward. Snapshot the four
# 71037 rank capacities from the source cited above. The 70959 Warlock data
# explicitly gives every rank a zero coefficient; the self-cast shield is instant.
# Matching spell IDs, trainer levels and capacities are also preserved at:
# https://github.com/alcaras/forever-ref/blob/6ea29f802d087e00790645d4b4d7334725fd0515/builds/1.60.1.70532.json.gz
shadow_ward = [(6229, 32, 290), (11739, 42, 470), (11740, 52, 675), (28610, 60, 920)]
for rank, (spell_id, level, capacity) in enumerate(shadow_ward, 1):
    record = dict(kind="absorb", school=schools.index("shadow") + 1, level=level, cast=0, gcd=1.5,
                  components=[dict(low=capacity, high=capacity)])
    emit(spell_id, "Shadow Ward", rank, record)
print("}")
