# SpellStats

💾 **[Download the latest version](https://www.curseforge.com/wow/addons/spellstats) on CurseForge** or download from [releases](https://github.com/elithrar/spellstats/releases).

<img src="icon.png" alt="A pixel-art mana crystal with an emerald eye" width="96" height="96" align="right">

SpellStats shows what a cast will heal or damage and how much mana it will cost, right on your World of Warcraft: Forever action buttons, including EllesmereUI Action Bars. By default, healing spells show the estimated median heal on top and the percentage of your maximum mana spent on the bottom, both in and out of combat.

## Installation

For a manual install, extract the ZIP into your Forever client’s `Interface/AddOns/` directory and restart WoW. SomethingNeedDoing is bundled.

Open settings with `/spellstats`, `/spellstats opts` or `/spellstats options`. Click the preview button in the upper right to try Holy Nova, Heal, Renew or Fireball, even with empty action bars. Editing a line highlights it on the preview.

| Setting | Choices |
| --- | --- |
| Top and bottom stats | Choose Heal/Damage (the estimated median), HPM/DPM (per mana), HPS/DPS (per second), mana cost, mana percentage, or None for each row. Spells that both heal and deal damage show their healing when available. |
| Profiles | Characters start on Shared. Use the profile menu to give a character its own copy or select an existing profile. Hover over the selector to see who shares the active settings. |
| Spells and combat | Show heals only or all spells. Keep numbers visible always, in combat, or out of combat. |
| Text style | Choose a font and outline. The font menu previews each typeface, including installed LibSharedMedia fonts. |
| Size and alignment | Drag each row’s slider or type a font size from 1 to 64 and press Enter. Both rows start left-aligned. You can center or right-align either row. |

Estimates use rank-specific coefficients and assume a noncritical cast on one target with all ticks completed. If WoW hides a player attribute such as spell power during combat, SpellStats uses its last readable out-of-combat value. Target mitigation, overhealing, and some talent modifiers can change the result.

HPS/DPS averages one cast over the time it takes to deliver its healing or damage. It uses the current cast time when available, otherwise the rank’s base cast time. Global cooldowns, channels and periodic effects use their base durations. For example, a Renew that heals 930 over 15 seconds shows 62 HPS. If there is no measurable time window, the row stays blank.

## License

SpellStats code is licensed under [Apache 2.0](LICENSE). For bundled components, see the [SomethingNeedDoing license](SpellStats/Libs/SomethingNeedDoing/LICENSE) and [spell data notice](SpellStats/THIRD-PARTY.txt). The [release tooling](tools/XPISLAND-LICENSE.txt) uses the BSD 3-Clause license.
