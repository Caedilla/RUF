NickTag is a library that allows the player to set a nickname, addons using this library can get the nickname and use it instead of the player name.
The nickname is shared among guild members and used instead of the regular player name.

Installing:
Install NickTag as you install any other library, but make sure to load NickTag after AceComm-3.0, AceSerializer-3.0, AceTimer-3.0 and CallbackHandler-1.0.

As an alternative you may use: _G.LibStub("NickTag-1.0"):Embed(YourAddonObject)

Cache Setup:
- After install, set a cache to store nicknames data received from others guild members.
- For this, call YourAddonObject:NickTagSetCache ( MyTable ), where "MyTable" is any table within your SavedVariablesPerCharacter.
- Is important to call NickTagSetCache right after your addon loads saved variables data.

Handle Player Nicknames:
- YourAddonObject:SetNickname(string), returns true if the string is a valid nickname.

The nickname must follow some rules:
- Can't be large then 12 characters.
- Isn't allowed numbers and others special characters.
- Can't repeat more then 2 times the same characters in a row.
- Can't have more then 2 spaces.
- Nickname is formated to fit title case, for instance, "SussY HArLey" is automatically formated to "Sussy Harley", "frank roger" to "Frank Roger".
- Trim.

Player Avatars:

The library also has support for player avatar and avatar background, see the example:

    --this function runs when the player hit the okay button on the avatar pick frame
    local avatarCallback = function (avatarTexture, avatarTextureTexCoord, avatarBackground, avatarBackgroundTexCoord, avatarBackgroundColor) 
        YourAddonObject:SetNicknameBackground (avatarBackground, avatarBackgroundTexCoord, avatarBackgroundColor) 
        YourAddonObject:SetNicknameAvatar (avatarTexture, avatarTextureTexCoord) 
        _G.AvatarPickFrame.callback = nil 
    end 

    --set the callback function
    _G.AvatarPickFrame.callback = AvatarCallBack 
    --show the atatar pick frame
    _G.AvatarPickFrame:Show()


Getting Nicknames and Avatars:

- @playerGUID: target player GUID.
- @default: a default if the player does not has a nickname
- @silent: show no errors if something goes wrong.

YourAddonObject:GetNickname (playerGUID, default, silent)

- @playerGUID: target player GUID.
- @default: a default texture if the player does not has an avatar, can be an empty string for no avatars.
- @silent: show no errors if something goes wrong.

YourAddonObject:GetNicknameAvatar (playerGUID, default, silent)

- @playerGUID: target player GUID.
- @defaultPath: returns this value texture path if no background is found.
- @defaultTexCoord: returns this value texture path if no background is found.
- @defaultColor: returns this value texture path if no background is found.
- @silent: show no errors if something goes wrong.

YourAddonObject:GetNicknameBackground (playerGUID, defaultPath, defaultTexCoord, defaultColor, silent)

