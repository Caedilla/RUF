# RUF r224-Release
### New
* Added Target's Target's Target.

### Bug Fixes
* Fixed an issue where some profile elements would not be correctly loaded when first entering the game.
* Fixed an issue with anchoring units to other units, due to the load order and creation of units. You should now be able to anchor any unit to another unit without issue.

### Known Issues
* Toggling on and off Test mode while targetting someone can cause the target portrait to scale incorrectly for the rest of that play session (until you relog or reloadUI). Deselecting your target and then toggling Test Mode on and off again should fix it.
* Test mode Auras display only buffs or debuffs the player currently has, rather than creating a bunch of temp icons.
* There is no preview of frame aura highlighting in test mode.