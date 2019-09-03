local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local _, ns = ...
local oUF = ns.oUF
local tags = oUF.Tags.Methods or oUF.Tags
local events = oUF.TagEvents or oUF.Tags.Events

----------------------------------------------------------------------------------- STATUS
tags['RUF:Level'] = function(unit)
	local profileReference = RUF.db.profile.Appearance.Text.Level
	local l = UnitLevel(unit)
	local elite = UnitClassification(unit) -- worldboss, rareelite, elite, rare, normal, trivial, or minus
	if elite == 'rareelite' then
		elite = '++'
	elseif elite == 'elite' or elite == 'rare' then
		elite = '+'
	elseif elite == 'minus' then
		elite = '-'
	else
		elite = ''
	end
	if RUF.db.global.TestMode == true then
		l = math.random(120)
	end
	local r,g,b = RUF:ReturnTextColors(unit, 'Level')
	if l <= 0 then l = '??' end
	if profileReference.HideSameLevel == true then
		if l == UnitLevel('player') then
			return ''
		end
	end
	if profileReference.HideClassification == true then
		elite = ''
	end
	return string.format('|cff%02x%02x%02x%s%s|r',r*255,g*255,b*255,elite,l)
end
events['RUF:Level'] = 'UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED'

tags['RUF:AFKDND'] = function(unit)
	local r,g,b = RUF:ReturnTextColors(unit, 'AFKDND')
	if RUF.db.global.TestMode == true then
		return string.format('|cff%02x%02x%02x[%s]|r',r*255,g*255,b*255,AFK)
	end
	if UnitIsAFK(unit) then
		return string.format('|cff%02x%02x%02x[%s]|r',r*255,g*255,b*255,AFK)
	end
	if UnitIsDND(unit) then
		return string.format('|cff%02x%02x%02x[%s]|r',r*255,g*255,b*255,DND)
	end
end
events['RUF:AFKDND'] = 'PLAYER_FLAGS_CHANGED'
oUF.Tags.SharedEvents.PLAYER_FLAGS_CHANGED = true
