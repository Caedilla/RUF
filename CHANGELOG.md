# RUF r205-Release
### New
* Castbars can now be coloured a different colour if the cast is not interruptible. (Color set in global appeaance options -> Bars -> Cast Bar -> Foreground Style)
* Text elements now have two separate anchor points (Anchor From and Anchor To), allowing finer control over text positioning. You may find that some of your existing elements are out of place due to this change.
* Added Party Pets as a supported Unit.
* Added Show in raid option for Party & Party Pets to enable showing these units in a raid group.

### Changed
* Castbar updates are throttled slightly to reduce performance impact further. Shouldn't result in any noticeable difference in smoothness.

* The Default profile, Raeli's Layout, and Alidie's Layout have been updated to better suit all of the recent additions and changes. You may find that some of your settings have changed due to this. Apologies for any inconvenience.


### Fixed
* Combo Points are now properly supported under Class Power options in Classic.
* Castbars should properly enable and disable themselves now.
* Latency indicator now only displays on the player cast bar.
* Buffs and Debuffs should properly when one is disabled.
* Range Fading should be far more accurate for assistable, friendly units (i.e party members or friendly NPCs that you can buff or heal).
* Boss and Arena units should properly update all their elements on a profile change.
* Frames now re-anchor to their 'parent' anchors when you stop dragging a frame when the frames are unlocked. So frames anchored to other frames will continue to move with their 'parent'.
* Fixed numerous indicators incorrectly spawning on units they shouldn't be.
* Text elements now once again properly update their list of viable anchor elements when you change the anchor.


### Known Issues
* Test mode Auras display only buffs or debuffs the player currently has, rather than creating a bunch of temp icons.
* There is no preview of frame aura highlighting in test mode.