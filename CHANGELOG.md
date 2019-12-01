# RUF r218-beta
### New
* Added Party Targets - defaults still need adjustment, especially for alternate layouts.
* Added options to control appearance of the castbar text and time. Available under each unit's castbar settings.
* Added options to control border insets for resource bars.

### Fixed
* Portrait in Unitframe overlay style is now inset by 0.15px from the frame edge to prevent the portrait from being drawn over the edge of the frame in some situations.

### Known Issues
* Toggling on and off Test mode while targetting someone can cause the target portrait to scale incorrectly for the rest of that play session (until you relog or reloadUI). Deselecting your target and then toggling Test Mode on and off again should fix it.
* Test mode Auras display only buffs or debuffs the player currently has, rather than creating a bunch of temp icons.
* There is no preview of frame aura highlighting in test mode.