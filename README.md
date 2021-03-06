# RUF - Raeli's Unit Frames
A unitframe layout for oUF

## Download
<https://www.curseforge.com/wow/addons/ruf>

# About
**RUF** is a configurable Unit Frame addon using oUF. RUF isn't as fully featured as some unit frames, but should also use less resources while playing than most unit frame addons too.

# Examples
![Some more recent examples](https://i.imgur.com/XW5C31d.png "Some more recent examples")

# Features
* Supports Player, Pet, Target, Pet's Target, Target's Target, Target's Target's Target, Party, Party Targets, and Party Pets.
* Nickname - Like Details! In fact, this is synced with Details! This will sync to other people using RUF or Details! (or any other addon that supports NickTag-1.0)
* Custom indicator status icons in place of the standard ones. These are icons such as PvP stats, Target Marks etc.
* Buff and Debuff icons with optional type and dispellable highlighting and basic filtering. (more advanced filtering coming later)
* Frame Highlighting for dispellable auras (debuffs on friendly units, or buffs on enemy units)
* Cast Bars for Player, Target, and Focus frames.
* Class Resource bar - Holy Power, Runes, Stagger etc. (Combo Points in Classic)
* Range Fading & Combat Fading
* Heal Prediction
* 3D animated portraits
* Several pre-configured layouts to choose from in the profile section.
* Optional RGB Rainbows! (Currently in alpha testing!)

![](https://i.imgur.com/043L1lf.gif) ![](https://i.imgur.com/x1ogx6z.gif)

### Live Only Features
* Supports Focus, Focus's Target, Boss, Boss Targets, Arena, Arena Targets (In addition to the ones mentioned above)
* Absorb Bar - a semi-transparent bar layered on top of the health bar showing your current absorbs as a percentage of max health.

### Classic Only Features
* Uses [LibClassicDurations](https://www.curseforge.com/wow/addons/libclassicdurations) to display durations of short buffs and debuffs on units (Use [OmniCC](https://www.curseforge.com/wow/addons/omni-cc) or [TullaCC](https://www.curseforge.com/wow/addons/tullacc) for numbers on the aura icons)
* Uses [LibClassicCasterino](https://github.com/rgd87/LibClassicCasterino) for Cast Bars to get non-player unit casting information to show enemy cast bars.
* Uses [LibHealComm-4.0](https://www.curseforge.com/wow/addons/libhealcomm-4-0) for Heal Prediction.

## Planned Features
* Classification colouring colors (To colour units if they are Elite, Rare, Boss etc.)
* Frame highlighting for mouseover
* Buff/Debuff whitelisting / blacklisting
* More tags, and increased options for existing tags

## Future Possibilities
* Raid unit support.
* Layout designer to quickly setup multiple units.

# Classic Support
### oUF
**RUF** supports Classic, but requires my modified version of oUF to function. This is included with RUF on Curseforge automatically. As such, you should ensure that you do not have oUF installed separately as it's own addon. (This doesn't matter for Live users, only Classic users)

### LibClassicDurations
Buffs & Debuffs do not return information about their duration in classic, so **RUF** uses [LibClassicDurations](https://www.curseforge.com/wow/addons/libclassicdurations) in Classic to provide this information. It's included with RUF when you download it from Curseforge and works automatically. If you want to see numbers on RUF's buffs or debuffs, you'll want to grab [OmniCC](https://www.curseforge.com/wow/addons/omni-cc) or [TullaCC](https://www.curseforge.com/wow/addons/tullacc) as well.

Any issues with auras showing incorrect durations should be directed to LibClassicDurations.

### LibClassicCasterino
In Classic, you cannot reliably determine non-player casting information. **RUF** uses [LibClassicCasterino](https://github.com/rgd87/LibClassicCasterino) in Classic to provide this information. It's included with RUF when you download it from Curseforge and works automatically.

Any issues with castbars showing incorrect cast durations should be directed to LibClassicCasterino.

### LibHealComm-4.0
Heal Prediction isn't part of the classic API, so **RUF** uses [LibHealComm-4.0](https://www.curseforge.com/wow/addons/libhealcomm-4-0) in Classic to provide this information.

Any issues with heal prediction showing incorrect values should be directed to LibHealComm-4.0.

# Copying Profiles from Live to Classic
RUF Classic should work with the same profiles you have on live. To do so, you'll want to copy your saved settings from the the retail folder to the classic folder. You'll then need to just set your profile in the RUF config window in game.

Example paths:

`WOW INSTALL LOCATION\_retail_\WTF\Account\ACCOUNT NAME\SavedVariables\RUF.lua`

`WOW INSTALL LOCATION\_classic_\WTF\Account\ACCOUNT NAME\SavedVariables\RUF.lua`


# Known Issues
RUF has been rewritten with the release of Classic, as such, some features are still being worked on. Currently options that affect Buffs/Debuffs or Borders of any type will require a UI Reload to take effect.


# Options
You can configure RUF by typing /ruf in game.
* Usability of the configuration options will improve with time with the ability to copy and paste settings from unit to unit.

# Feedback & Support

You can [report issues on Curseforge](https://wow.curseforge.com/projects/ruf/issues) or contact me directly on [Discord](https://discord.gg/99QZ6sd).

I've setup a Patreon to go toward my WoW subscription. If you'd like to throw me a dollar to keep my addons working, check out the link below. Cheers.

[![Support me on Patreon](https://c5.patreon.com/external/logo/become_a_patron_button.png "")](https://www.patreon.com/join/raeli "")

# Localisation

RUF supports localisation, if you want to help me out by localising RUF, please go to the [localisation page on Curseforge](https://wow.curseforge.com/projects/ruf/localization).
