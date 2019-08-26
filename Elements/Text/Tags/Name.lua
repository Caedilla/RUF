local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local _, ns = ...
local oUF = ns.oUF
local tags = oUF.Tags.Methods or oUF.Tags
local events = oUF.TagEvents or oUF.Tags.Events

----------------------------------------------------------------------------------- UNITNAME
tags['RUF:Name'] = function(unit, realUnit)
	if not UnitName(unit) then return end
	local name
	if RUF.db.profile.Appearance.Text.Name.Case == 1 then
		name = string.upper(UnitName(unit))
	elseif RUF.db.profile.Appearance.Text.Name.Case == 2 then
		name = string.lower(UnitName(unit))
	else
		name = UnitName(unit)
	end

	local player = string.upper(UnitName('player'))
	if RUF.db.char.NickName and string.upper(name) == player and string.len(RUF.db.char.NickName) > 0 then
		if RUF.db.profile.Appearance.Text.Name.Case == 1 then
			name = string.upper(RUF.db.char.NickName)
		elseif RUF.db.profile.Appearance.Text.Name.Case == 2 then
			name = string.lower(RUF.db.char.NickName)
		else
			name = RUF.db.char.NickName
		end
	end

	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local r,g,b = RUF:ReturnTextColors(unit, 'Name', cur, max)
	if RUF.db.global.TestMode == true then
		cur = math.random(75)
		max = math.random(75,100)
		--[[val = math.random(RUF.db.char.GuildNum)
		if RUF.db.profile.Appearance.Text.Name.Case== 1 then
			name = string.upper(RUF.db.char.Guild[val].Name)
		elseif RUF.db.profile.Appearance.Text.Name.Case == 2 then
			name = string.lower(RUF.db.char.Guild[val].Name)
		else
			name = RUF.db.char.Guild[val].Name
		end]]--
		r,g,b = RUF:ReturnTextColors(unit, 'Name', cur, max,val)
	end
	local CharLimit = RUF.db.profile.Appearance.Text.Name.CharLimit
	if CharLimit == 0 then CharLimit = 5000 end

	-- Return Text String
	if UnitIsPlayer(unit) then
		return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.sub(name,1,CharLimit))
	else
		return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.sub(name,1,CharLimit))
	end
end
events['RUF:Name'] = 'UNIT_NAME_UPDATE'