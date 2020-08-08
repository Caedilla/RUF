# RUF r241-Alpha
### New
* Added a Rainbow Mode option to the health bar settings of each unit frame. This turns health bars into a gradient cycling through RGB colours - if you have RGB peripherals from Corsair/Razer etc. you'll be familiar with this effect.

### Known Issues
* Toggling on and off Test mode while targetting someone can cause the target portrait to scale incorrectly for the rest of that play session (until you relog or reloadUI). Deselecting your target and then toggling Test Mode on and off again should fix it.
* Joining a group while test mode is enabled will show additional party units while remaining in test mode.
* Test mode Auras display only buffs or debuffs the player currently has, rather than creating a bunch of temp icons.
* There is no preview of frame aura highlighting in test mode.
* Changing the width of the player frame will not correctly result in the class resource bar from updating width with it. A UI reload or toggling the class power bar on and off will fix this.