# RUF - Raeli's Unit Frames.
A unitframe layout for oUF

## Download

<https://www.curseforge.com/wow/addons/ruf>



## About
**RUF** is a configurable Unit Frame addon using oUF. It is still very much in early development, but I have made it available on curse so that I can get feedback along the way.

RUF isn't as fully featured as some unit frames, but should also use less resources while playing than most unit frame addons too.

## Classic Support
**RUF** supports Classic as of r148-alpha, but requires my modified version of oUF to function. This is included with RUF here on Curseforge automatically. As such, you should ensure that you do not have oUF installed separately as it's own addon. (This doesn't matter for Live users, only Classic users)



#### Copying Profiles
RUF Classic should work with the same profiles you have on live. To do so, you'll want to copy your saved settings from the the retail folder to the classic folder. You'll then need to just set your profile in the RUF config window in game.

Example paths:

`WOW INSTALL LOCATION\_retail_\WTF\Account\ACCOUNT NAME\SavedVariables\RUF.lua`

`WOW INSTALL LOCATION\_classic_\WTF\Account\ACCOUNT NAME\SavedVariables\RUF.lua`

#### RealMobHealth
**RUF** works with [RealMobHealth](https://www.curseforge.com/wow/addons/real-mob-health) in classic to try and estimate an enemy unit's actual health. If you want show actual health instead of only percentages for enemy units, all you need to do is download RealMobHealth.

#### Known Issues
RUF has been rewritten with the release of Classic - versions from this point on (for both BFA and Classic) currently have the following known issues (that will be fixed soon), the TLDR though is that a UI Reload fixes these issues, and they should mostly only crop up when configuring RUF.

* Certain options require a UI reload to take effect - attempting to change some of them can also trigger a Lua error (though the values will be changed and everything should work as expected after a UI reload) Notably these are Buff/Debuff settings and settings that change element borders. Adding or Removing text is also a little iffy right now too (Does work, again, a UI Reload is required to take full effect of changes)
* In Classic the Master Looter icon is currently missing, but will be available shortly.
* When switching profiles, text elements that are 'new' to the profile you are switching to will not work properly. This is only an issue if you have added text elements, if you use the default ones (even if you have different settings for those ones), this shouldn't be an issue. Again, a UI Reload fixes this.


## Features
* Currently supports Player, Pet, Pet's Target, Target, Target's Target, Focus, Focus's Target, Boss, Party, and Arena units
* Class Resource bars - soul shards, runes etc.
* Absorb Bar - show all the unit's absorbs as a percentage of their maximum health, overlaid over the health bar. (In the future, you can also have this as it's own separate bar)
* Stagger Bar (Obviously not in Classic)
* Personal Nickname - you can change the name displayed of your character. As shown below, my warlock's name is Raerae, but the displayed name is Raeli - this is displayed on other units too (Target frames for example)
* You can color health bar, power, class resources, absorb, text by various criteria such as class colors, reaction colors, power colors, and health gradients.
* Several different pre-configured layouts to chose from in the profile section.
* Configurable unit state icons (such as Target Mark, Ready Check status, Dungeon Role etc.)
* Unique state icons, a custom font is used to display icons which means they scale to any size great, and can easily be coloured in any way (Config options pending on that last part)
* Buff & Debuff icons, (Whitelist/Blacklisting coming later, though basic filtering currently exists)


## Options
You can configure RUF by typing /ruf in game.
* Usability of the configuration options will improve with time with the ability to copy and paste settings from unit to unit.

## Feedback & Support

You can [report issues on Curseforge](https://wow.curseforge.com/projects/ruf/issues) or contact me directly on [Discord](https://discord.gg/99QZ6sd).

I've setup a Patreon to go toward my WoW subscription. If you'd like to throw me a dollar to keep my addons working, check out the link below. Cheers.

[![Support me on Patreon](https://c5.patreon.com/external/logo/become_a_patron_button.png "")](https://www.patreon.com/join/raeli "")

## Localisation

RUF supports localisation, if you want to help me out by localising RUF, please go to the [localisation page on Curseforge](https://wow.curseforge.com/projects/ruf/localization).
