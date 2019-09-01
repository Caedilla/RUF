# RUF - Raeli's Unit Frames.
A unitframe layout for oUF

## Download

<https://www.curseforge.com/wow/addons/ruf>



## About
**RUF** is a configurable Unit Frame addon using oUF. It is still very much in early development, but I have made it available on curse so that I can get feedback along the way.

RUF isn't as fully featured as some unit frames, but should also use less resources while playing than most unit frame addons too.

## Planned Features
* Copying settings from one unit to another (Started - already functioning for Text elements)
* NickTag library support so your Nickname can sync to other addons that use it (Such as Details!)
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

#### Copying Profiles from Live to Classic
RUF Classic should work with the same profiles you have on live. To do so, you'll want to copy your saved settings from the the retail folder to the classic folder. You'll then need to just set your profile in the RUF config window in game.

Example paths:

`WOW INSTALL LOCATION\_retail_\WTF\Account\ACCOUNT NAME\SavedVariables\RUF.lua`

`WOW INSTALL LOCATION\_classic_\WTF\Account\ACCOUNT NAME\SavedVariables\RUF.lua`


## Known Issues
RUF has been rewritten with the release of Classic, as such, some features are still being worked on. Currently options that affect Buffs/Debuffs or Borders of any type will require a UI Reload to take effect. 


## Features
* Includes Player, Pet, Pet's Target, Target, Target's Target, Party for both Live & Classic, and also Focus, Focus's Target, Boss, and Arena units for Live
* Class Resources (Live Only) - this includes Runes, Stagger, Holy Power etc. 
* Absorb Bar (Live Only) - an overlay bar that shows over the health bar semi transparent showing your current absorbs as a percentage of max health. 
* Give yourself a Nickname, and your nickname will show up across all RUF frames with this nickname instead.
* Custom class and resource colouring, coloring of all elements bars, and text through various criteria such as class colour, health percent, reaction colour etc. 
* Unique custom indicator icons (placement, size etc. configurable) in place of the standard ones. These are the icons such as your PvP status, Target Marks etc. They are also scalable without losing detail (since it's done via a font, rather than rasterised textures)
* Several different pre-configured layouts to chose from in the profile section.
* Buff & Debuff icons with highlighting for types and if they're dispellable or not.


## Options
You can configure RUF by typing /ruf in game.
* Usability of the configuration options will improve with time with the ability to copy and paste settings from unit to unit.

## Feedback & Support

You can [report issues on Curseforge](https://wow.curseforge.com/projects/ruf/issues) or contact me directly on [Discord](https://discord.gg/99QZ6sd).

I've setup a Patreon to go toward my WoW subscription. If you'd like to throw me a dollar to keep my addons working, check out the link below. Cheers.

[![Support me on Patreon](https://c5.patreon.com/external/logo/become_a_patron_button.png "")](https://www.patreon.com/join/raeli "")

## Localisation

RUF supports localisation, if you want to help me out by localising RUF, please go to the [localisation page on Curseforge](https://wow.curseforge.com/projects/ruf/localization).
