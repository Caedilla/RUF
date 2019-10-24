# RUF r215-alpha
### New
* Added an option to set how names are trimmed or abbreviated a name is longer than the character limit setting.

### Changed
* Frame level has been increased for all elements and the unit frame as a whole, so you should be able to anchor other frames behind the unit frames more easily now if you desire. Anything with a Frame Strata of LOW and Frame Level under 5 should end up behind all of the unit frames, with no part of the frame being on the BACKGROUND frame strata any longer, so a Frame Strata of BACKGROUND should also be enough alone to be below the frame.

### Known Issues
* Toggling on and off Test mode while targetting someone can cause the target portrait to scale incorrectly for the rest of that play session (until you relog or reloadUI). Deselecting your target and then toggling Test Mode on and off again should fix it.
* Test mode Auras display only buffs or debuffs the player currently has, rather than creating a bunch of temp icons.
* There is no preview of frame aura highlighting in test mode.
* HealComm in classic no longer supports HoT effects since LibHealComm-4.0 doesn't correctly support them, while LibClassicHealComm-1.0 did. HoT support will return in the future when LibHealComm-4.0 correctly supports them.