# RUF r214-Release
### New
* Addded an option to the Level tag to toggle if the Classification text is shown before or after the level text.
* Added an option to desaturate unit Portraits.
* Added option to Unit Buff, Debuff and Portrait settings to copy settings from another unit.

### Changed
* Switched to LibHealComm-4.0 from LibClassicHealComm-1.0 due to licence conflict.
* Class settings are titled by the resource type. For example, they show up as Combo Points if you are playing a rogue.
* The Level tag for Battle Pets now show's the Battle Pet level.

### Known Issues
* Toggling on and off Test mode while targetting someone can cause the target portrait to scale incorrectly for the rest of that play session (until you relog or reloadUI). Deselecting your target and then toggling Test Mode on and off again should fix it.
* Test mode Auras display only buffs or debuffs the player currently has, rather than creating a bunch of temp icons.
* There is no preview of frame aura highlighting in test mode.
* HealComm in classic no longer supports HoT effects since LibHealComm-4.0 doesn't correctly support them, while LibClassicHealComm-1.0 did. HoT support will return in the future when LibHealComm-4.0 correctly supports them.