# Legendary Normal - Customize Normal Quality Stats

Allows you to change the quality stats of normal quality items without breaking other game features.
Fully configurable — by default, normal quality matches legendary stats. Set the level anywhere from 0 (vanilla normal) to 10 if you want to go beyond legendary.

## Features

- **Quality Level Setting** — Set the normal quality level from 0 to 10. Level 5 matches legendary, anything above is uncharted territory.
- **Ignore Enemies** — Keeps all enemy stats at their vanilla values. Biters, worms, spawners, pentapods, and demolishers won't benefit from the boosted quality level.
- **Ignore Asteroids** — Keeps asteroid health at vanilla values so space travel difficulty stays the same.

## How It Works

This mod changes the quality level of "normal" quality itself, so crafting, research, and all other game mechanics scale naturally without any hacks. No items or recipes are modified — just the quality definition.

### Enemies
Since changing the quality level affects everything, enemies would also get boosted stats. The **Ignore Enemies** setting counteracts this so enemies retain their vanilla strength.

> Note: Enabling this technically makes enemies much weaker than normal, since you're essentially fighting them with legendary weapons from the start.


### Asteroids
Same idea — the **Ignore Asteroids** setting ensures asteroid health stays at vanilla values, keeping space platform defense balanced.

> Note: Enabling this technically makes asteroids much weaker than normal, since your turrets will be doing legendary-tier damage against vanilla-health asteroids.

### Mining Drills
Mining drill resource drain is hard-coded and doesn't respond to quality level changes, so the mod manually sets drain values to match the selected quality level. The drain caps at 8% for any level above 3, matching legendary behavior. If you craft an actual legendary drill on top of this, the drain will drop below 1% — extremely powerful, but hey, it's your game. If you find any other objects that have issues with their stats please let me know.

## Contact
For bug reports and suggestions, please open a work item on my personal git server.
https://git.pyrosfun.com/pyrosfun/legendarynormal

Discord at:
[dsc.PyrosFun.com](https://dsc.PyrosFun.com)
