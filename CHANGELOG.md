# RUF r209-Release
### New
* It's taken almost two weeks to get this to a state I'm almost happy with but 3D Portraits are now available! You can thank Alex(Plad)#5855 on discord for the long way, and delay with adding other new features such as HealComm support!
    * Portraits can be freely anchored, or layered over the health bar. You can also set them to cut away or clip with the health bar so that the health bar is not obscured by the model. The cutaway effect looks best with the Freeze Animations option selected, and the health bar smoothing disabled.
* Added HealPrediction. Settings can be found in Global Appearance Options -> Bars -> Heal Prediction.
    * Split into two parts, one showing incoming heals on the unit by the player, the other showing incoming heals from other units (i.e other healers in your group)
    * Classic version uses LibClassicHealComm to determine incoming heals and has the ability to order the heals based on which will land first.
* RUF now checks to ensure you are using the correct release type for the version of WoW you are playing (i.e checks to make sure that you are using an RUF-Classic release if you are playing Classic WoW).
    * RUF will warn you if you are using an incompatible version with your client and prevent itself from continuing to load. If you see this warning, it is likely that Your Twitch client has bugged out and installed the wrong release type.

### Changed
* Horizontal Spacing options have been hidden from Party/Party Pet units as they currently do not support it. (They are created in a special manner that requires a different implementation that I'll do later)
* Bar Animation options have returned and can be found in Unit Options -> Unit -> Bars -> Bar
* Bar Animation is now handled by RUF rather than via the oUF_Smooth plugin and so oUF_Smooth is no longer included.


### Known Issues
* Toggling on and off Test mode while targetting someone can cause the target portrait to scale incorrectly for the rest of that play session (until you relog or reloadUI). Deselecting your target and then toggling Test Mode on and off again should fix it.
* Test mode Auras display only buffs or debuffs the player currently has, rather than creating a bunch of temp icons.
* There is no preview of frame aura highlighting in test mode.