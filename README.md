# RUF - Raeli's Unit Frames.
A unitframe layout for oUF

## Download

<https://www.curseforge.com/wow/addons/ruf>



## About
**RUF** is a configurable Unit Frame addon using oUF. It is still very much in early development, but I have made it available on curse so that I can get feedback along the way.

RUF isn't as fully featured as some unit frames, but should also use less resources while playing than most unit frame addons too.

## Features
* Supports Player, Pet, Target, Pet's Target, Target's Target, and Party frames.
* Nickname - Like Details! In fact, this is synced with Details! This will sync to other people using RUF or Details! (or any other addon that supports NickTag-1.0)
* Unique custom indicator status icons in place of the standard ones. These are icons such as PvP stats, Target Marks etc. These are made through a font file, so they scale much better and retain clarity better than the normal indicator icons.
* Buff and Debuff icons with optional type and dispellable highlighting and basic filtering. (more advanced filtering coming later)
* Cast Bars for Player and Target frames (as of r182-alpha)
* Several pre-configured layouts to choose from in the profile section.

### Live Only Features
* Supports Focus, Focus's Target, Boss, and Arena frames (In addition to the ones mentioned above)
* Class Resource bar - Holy Power, Runes, Stagger etc.
* Absorb Bar - a semi-transparent bar layered on top of the health bar showing your current absorbs as a percentage of max health.

### Classic Only Features
* Supports [RealMobHealth](https://www.curseforge.com/wow/addons/real-mob-health) if installed (must be installed separately)
* Uses LibClassicDurations to display durations of short buffs and debuffs on units (Use [OmniCC](https://www.curseforge.com/wow/addons/omni-cc) or [TullaCC](https://www.curseforge.com/wow/addons/tullacc) for numbers on the aura icons)
* Uses LibClassicCasterino for Cast Bars to get non-player unit casting information to show enemy cast bars.

## Planned Features
* Copying settings from one unit to another (Started - already functioning for Text elements)
* Classification colouring colors (To colour units if they are Elite, Rare, Boss etc.)
* Range Fading
* Border / Frame highlighting for mouseover and dispellable debuffs (and generally more Border options)
* Buff/Debuff whitelisting / blacklisting
* More tags, and increased options for existing tags

## Classic Support
**RUF** supports Classic, but requires my modified version of oUF to function. This is included with RUF on Curseforge automatically. As such, you should ensure that you do not have oUF installed separately as it's own addon. (This doesn't matter for Live users, only Classic users)

#### RealMobHealth
**RUF** works with [RealMobHealth](https://www.curseforge.com/wow/addons/real-mob-health) in classic to try and estimate an enemy unit's actual health. If you want show actual health instead of only percentages for enemy units, all you need to do is download RealMobHealth.

#### LibClassicDurations
In Classic, UnitAura (how you track buffs/debuffs) returns 0 for the duration of a buff or debuff on a non-group target (enemies or allied players not in your group). LibClassicDuration attempts to solve this. It's included with RUF when you download it from Curseforge and works automatically. If you want to see numbers on RUF's buffs or debuffs, you'll want to grab [OmniCC](https://www.curseforge.com/wow/addons/omni-cc) or [TullaCC](https://www.curseforge.com/wow/addons/tullacc) as well.

#### LibClassicCasterino
In Classic, you cannot reliably determine non-player casting information. RUF uses LibClassicCasterino to try and gather this information from the few events we can track, but it's not perfect. As such, if an enemy player cancels their cast, there's no way of knowing this until they perform another action. This means that once a castbar is created and shown, if the enemy player stops their cast, the cast bar will still display to its normal end. This is of course immediately updated as soon as they begin a new cast.

#### Copying Profiles from Live to Classic
RUF Classic should work with the same profiles you have on live. To do so, you'll want to copy your saved settings from the the retail folder to the classic folder. You'll then need to just set your profile in the RUF config window in game.

Example paths:

`WOW INSTALL LOCATION\_retail_\WTF\Account\ACCOUNT NAME\SavedVariables\RUF.lua`

`WOW INSTALL LOCATION\_classic_\WTF\Account\ACCOUNT NAME\SavedVariables\RUF.lua`


## Known Issues
RUF has been rewritten with the release of Classic, as such, some features are still being worked on. Currently options that affect Buffs/Debuffs or Borders of any type will require a UI Reload to take effect.


## Options
You can configure RUF by typing /ruf in game.
* Usability of the configuration options will improve with time with the ability to copy and paste settings from unit to unit.

## Feedback & Support

You can [report issues on Curseforge](https://wow.curseforge.com/projects/ruf/issues) or contact me directly on [Discord](https://discord.gg/99QZ6sd).

I've setup a Patreon to go toward my WoW subscription. If you'd like to throw me a dollar to keep my addons working, check out the link below. Cheers.

[![Support me on Patreon](https://c5.patreon.com/external/logo/become_a_patron_button.png "")](https://www.patreon.com/join/raeli "")

## Localisation

RUF supports localisation, if you want to help me out by localising RUF, please go to the [localisation page on Curseforge](https://wow.curseforge.com/projects/ruf/localization).
