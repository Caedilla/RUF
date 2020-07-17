# RUF r239-Alpha
### New
* Added option to enable showing the player in the party frames.
* Added option to toggle NickTag-1.0 Nicknames in Name tag settings.
* Added new portrait style - Attached, similar to free floating, but locked to the left or right of the unitframe instead - Portraits in this mode are interactable unlike free floating portraits.
	* As a note: Free floating portraits will continue to remain uninteractable as an intentional choice from this point forward. The attached style is a compromise between truly free-floating, and having interactable portraits.

### Fixed
* Party Pets should now spawn in their proper locations (i.e the third party member's pet should spawn in the third place of the party pets, not the first position) - This change means that you may need to re-adjust your positioning for Party Pet units.
* Russian (and presumably other non-latin characterset names?) names should no longer disappear with certain name abbreviation settings.
* When in a vehicle with the player frame set to be the vehicle frame rather than the pet, cast bars should no longer cause lua errors.
* Fixed NickTag related Lua error from r234-alpha.
* Fixed attempt to call a string value lua error from r238-alpha.

### Updates
* Updated localisations.

### Known Issues
* Toggling on and off Test mode while targetting someone can cause the target portrait to scale incorrectly for the rest of that play session (until you relog or reloadUI). Deselecting your target and then toggling Test Mode on and off again should fix it.
* Test mode Auras display only buffs or debuffs the player currently has, rather than creating a bunch of temp icons.
* There is no preview of frame aura highlighting in test mode.