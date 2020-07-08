# RUF r235-Alpha
### New
* Added option to toggle NickTag-1.0 Nicknames in Name tag settings.
* Added new portrait style - Attached, similar to free floating, but locked to the left or right of the unitframe instead - Portraits in this mode are interactible unlike free floating portraits.
	* As a note: Free floating portraits will continue to remain uninteractible as an intentional choice from this point forward. The attached style is a compromise between truly free-floating, and having interactible portraits.

### Fixed
* Russian (and presumably other non-latin characterset names?) names should no longer disappear with certain name abbreviation settings.
* When in a vehicle with the player frame set to be the vehicle frame rather than the pet, cast bars should no longer cause lua errors.
* Fixed NickTag related Lua error from r234-alpha.

### Known Issues
* Toggling on and off Test mode while targetting someone can cause the target portrait to scale incorrectly for the rest of that play session (until you relog or reloadUI). Deselecting your target and then toggling Test Mode on and off again should fix it.
* Test mode Auras display only buffs or debuffs the player currently has, rather than creating a bunch of temp icons.
* There is no preview of frame aura highlighting in test mode.