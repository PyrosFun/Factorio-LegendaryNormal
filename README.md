> [!important]
> To create issues / suggestions please use the unified issue tracker:
> **https://github.com/PyrosFun/IssueTracker**

# Legendary Normal - Customize Normal Quality Stats

Allows you to change the quality stats of normal quality items without breaking other game features.
Fully configurable — by default, normal quality matches legendary stats. Set the level anywhere from 0 (vanilla normal) to 10 if you want to go beyond legendary.

Requires Factorio 2.1.21 or newer, with Space Age and Quality enabled.

## Features

- **Quality Level Setting** — Set the normal quality level from 0 to 10. Level 5 matches legendary, anything above is uncharted territory.
- **Ignore Enemies** — Keeps all enemy stats at their vanilla values. Biters, worms, spawners, pentapods, and demolishers won't benefit from the boosted quality level.
- **Ignore Asteroids** — Keeps asteroid health at vanilla values so space travel difficulty stays the same.

## How It Works

This mod changes the quality level of "normal" quality itself, so crafting, research, and all other game mechanics scale naturally without any hacks. Item identities and recipes stay unchanged. Explicit quality bonuses are set alongside the level so beacon efficiency, mining resource drain, science pack drain, and train stats also match the selected tier. Factorio applies its remaining quality bonuses automatically.

### Enemies
Since changing the quality level affects everything, enemies would also get boosted stats. The **Ignore Enemies** setting counteracts this so enemies retain their vanilla strength.

Ground acid always keeps its vanilla damage and slowdown, including vehicle friction, regardless of this setting. Sticker duration stays close to vanilla, with at most a few ticks of rounding because Factorio requires whole ticks.

> Note: Enabling this technically makes enemies much weaker than normal, since you're essentially fighting them with legendary weapons from the start.


### Asteroids
Same idea — the **Ignore Asteroids** setting ensures asteroid health stays at vanilla values, keeping space platform defense balanced.

> Note: Enabling this technically makes asteroids much weaker than normal, since your turrets will be doing legendary-tier damage against vanilla-health asteroids.

### Mining Drills
Resource drain uses the quality API, so it applies to all mining drills, including drills added by other mods. At level 5, normal drills use one sixth of their base resource drain: about 16.67% for standard drills and 8.33% for big mining drills. Resource drain and beacon power usage stop improving at level 5. Other bonuses continue scaling through level 10; wagon capacity interpolates between epic and legendary and continues at the same rate above legendary. Actual uncommon, rare, epic, and legendary qualities keep their own bonuses instead of stacking the normal-quality drain reduction.

## Contact
For bug reports and suggestions, please open a work item on my personal git server.
https://git.pyrosfun.com/pyrosfun/legendarynormal

Discord at:
[dsc.PyrosFun.com](https://dsc.PyrosFun.com)
