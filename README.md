# SpellStats

<img src="icon.png" alt="A pixel-art mana crystal with an emerald eye" width="96" height="96" align="right">

SpellStats shows what a cast will heal or damage and how much mana it will cost, right on your World of Warcraft: Forever action buttons. By default, healing spells show the estimated median heal on top and the percentage of your maximum mana spent on the bottom, both in and out of combat.

## Installation

Extract the ZIP into your Forever client’s `Interface/AddOns/` directory and restart WoW. Open settings with `/spellstats opts` or `/spellstats options`. SomethingNeedDoing is bundled. [Download SpellStats](https://github.com/elithrar/spellstats/raw/refs/heads/main/dist/SpellStats-0.1.0.zip)

| Setting | Choices |
| --- | --- |
| Top and bottom stats | Choose each row independently. Show median heal, median damage, heal or damage as appropriate, healing per mana (HPM), damage per mana (DPM), mana cost, mana percentage, or None. |
| Spells and combat | Show heals only or all spells. Keep numbers visible always, in combat, or out of combat. |
| Appearance | Choose a font and outline, and set the size of each row. Installed LibSharedMedia fonts also appear in the font menu. |

Estimates use rank-specific coefficients and assume a noncritical cast on one target with all ticks completed. Target mitigation, overhealing, and some talent modifiers can change the result.

**Upgrading from SpellInsight?** To keep your settings, exit WoW before your first SpellStats login. Copy `SpellInsight.lua` to `SpellStats.lua` in `_forever_/WTF/Account/<account>/SavedVariables/` and disable the old add-on. SpellStats imports your saved choices. `/spellinsight options` also opens the panel.

## Development

Build the installable ZIP with `python3 tools/package.py`. Push an annotated version tag matching the TOC (for example, `v0.1.0`) on a commit reachable from `main` to publish a GitHub release. The tag message supplies the release notes. Set the Actions variable `CF_PROJECT_ID` and secret `CF_API_TOKEN` (or `CF_API_KEY`) to upload the same ZIP to CurseForge for WoW Forever.

## License

SpellStats code is licensed under [Apache 2.0](LICENSE). For bundled components, see the [SomethingNeedDoing license](SpellStats/Libs/SomethingNeedDoing/LICENSE) and [spell data notice](SpellStats/THIRD-PARTY.txt). The [release tooling](tools/XPISLAND-LICENSE.txt) uses the BSD 3-Clause license.
