# RUF r217-alpha
### New
* Added options to control appearance of the castbar text and time. Available under each unit's castbar settings.

### Known Issues
* Toggling on and off Test mode while targetting someone can cause the target portrait to scale incorrectly for the rest of that play session (until you relog or reloadUI). Deselecting your target and then toggling Test Mode on and off again should fix it.
* Test mode Auras display only buffs or debuffs the player currently has, rather than creating a bunch of temp icons.
* There is no preview of frame aura highlighting in test mode.
* HealComm in classic no longer supports HoT effects since LibHealComm-4.0 doesn't correctly support them, while LibClassicHealComm-1.0 did. HoT support will return in the future when LibHealComm-4.0 correctly supports them.