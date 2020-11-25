# RUF r253-Release
## Fixes
* Party health bars should properly animate again.
* Heal Prediction should no longer show for a split second on target and target's target units when first targetting someone.
### Known Issues
* Toggling on and off Test mode while targetting someone can cause the target portrait to scale incorrectly for the rest of that play session (until you relog or reloadUI). Deselecting your target and then toggling Test Mode on and off again should fix it.
* Joining a group while test mode is enabled will show additional party units while remaining in test mode.
* Test mode Auras display only buffs or debuffs the player currently has, rather than creating a bunch of temp icons.
* There is no preview of frame aura highlighting in test mode.