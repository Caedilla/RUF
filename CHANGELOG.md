# RUF r251-Alpha
## New
* Added Custom Width option for text elements, along with word wrapping and horizontal justification to allow multi-line text elements.

## Fixes
* Pixel Perfect Scaling should now apply regardless of if other addons change the UI scale.
* Fixed a lua error when playing as a DK.
* DK Runes should now properly update colours when changing specs again.

## Changes
* Cast Bar animtaions should update more frequently for smoother changes. Fix from r250 - Should now also be smoother at low framerates too.

### Known Issues
* Toggling on and off Test mode while targetting someone can cause the target portrait to scale incorrectly for the rest of that play session (until you relog or reloadUI). Deselecting your target and then toggling Test Mode on and off again should fix it.
* Joining a group while test mode is enabled will show additional party units while remaining in test mode.
* Test mode Auras display only buffs or debuffs the player currently has, rather than creating a bunch of temp icons.
* There is no preview of frame aura highlighting in test mode.