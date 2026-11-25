# SpellStats

💾 **[Download the latest version](https://www.curseforge.com/wow/addons/spellstats) on CurseForge** or download from [releases](https://github.com/elithrar/spellstats/releases).

<img src="icon.png" alt="A pixel-art mana crystal with an emerald eye" width="96" height="96" align="right">

SpellStats shows healing, shield absorbs, damage, and mana costs on your World of Warcraft: Forever action buttons, including EllesmereUI Action Bars. By default, heals and shields show the estimated amount on top and the percentage of your maximum mana spent on the bottom, both in and out of combat.

<img width="451" height="340" alt="image" src="https://github.com/user-attachments/assets/c4327e9f-a67e-4f78-b787-0c161c5b65f5" />
<img width="857" height="880" alt="image" src="https://github.com/user-attachments/assets/b51fd26a-5bbe-459d-88bc-b0937a8e00ae" />

## Installation

For a manual install, extract the ZIP into your Forever client’s `Interface/AddOns/` directory and restart WoW. SomethingNeedDoing is bundled.

Open settings with `/spellstats`, `/spellstats opts` or `/spellstats options`. Click the preview button in the upper right to try spells such as Power Word: Shield, Renew, or Fireball, even with empty action bars. Editing a line highlights it on the preview.

| Setting | Choices |
| --- | --- |
| Top and bottom stats | Choose Heal/Damage (the estimated median), HPM/DPM (per mana), HPS/DPS (per second), mana cost, mana percentage, or None for each row. Spells that both heal and deal damage show their healing when available. |
| Profiles | Characters start on Shared. Use the profile menu to give a character its own copy or select an existing profile. Hover over the selector to see who shares the active settings. |
| Spells and combat | Show heals only or all spells. Keep numbers visible always, in combat, or out of combat. |
| Text style | Choose a font and outline. The font menu previews each typeface, including installed LibSharedMedia fonts. |
| Size and alignment | Drag each row’s slider or type a font size from 1 to 64 and press Enter. Both rows start left-aligned. You can center or right-align either row. |

Estimates use rank-specific coefficients and assume a noncritical cast on one target with all ticks completed. If WoW hides a player attribute such as spell power during combat, SpellStats uses its last readable out-of-combat value. Target mitigation, overhealing, and some talent modifiers can change the result.

Power Word: Shield, Ice Barrier, Fire Ward, Frost Ward, Shadow Ward, Mana Shield, and Templar’s Bulwark count as heals. The amount is how much damage a fresh shield can absorb. Power Word: Shield includes bonus healing and your rank of Improved Power Word: Shield when available. An instant shield on the global cooldown uses that cooldown for HPS. Mana Shield shows its upfront mana cost and leaves HPM blank because it spends additional mana as it absorbs damage.

HPS/DPS averages one cast over the time it takes to deliver its healing or damage. Renew uses all 15 seconds and includes Improved Renew. Both Renew and Prayer of Mending account for Twin Disciplines and Spiritual Healing. Prayer of Mending shows one trigger and leaves HPS blank because the next qualifying hit or heal determines when it triggers. Lightwell shows the healing from one charge and leaves HPS blank because the recipient chooses when to use it. Health Funnel counts healing delivered to your pet.

Rates use the current cast time when available and otherwise use the rank’s base timing. Missile Barrage halves the channel time for Arcane Missiles. If WoW restricts access to the proc, its DPS row stays blank. Arcane Wrath includes the contribution from maximum mana, and Consecration shows all eight pulses on one enemy.

## License

SpellStats code is licensed under [Apache 2.0](LICENSE). For bundled components, see the [SomethingNeedDoing license](https://github.com/elithrar/spellstats/blob/main/SpellStats/Libs/SomethingNeedDoing/LICENSE) and [spell data notice](https://github.com/elithrar/spellstats/blob/main/SpellStats/THIRD-PARTY.txt). The [release tooling](https://github.com/elithrar/spellstats/blob/main/tools/XPISLAND-LICENSE.txt) uses the BSD 3-Clause license.
