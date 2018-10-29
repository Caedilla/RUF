local RUF = LibStub("AceAddon-3.0"):GetAddon("RUF")
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")
local _, ns = ...
local oUF = ns.oUF
local tags = oUF.Tags.Methods or oUF.Tags
local events = oUF.TagEvents or oUF.Tags.Events

----------------------------------------------------------------------------------- HEALTH 
tags['RUF:CurHPPerc'] = function(unit) -- Current Health and Percent if below 100%.
	if not UnitName(unit) then return end
	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local r,g,b = RUF:ReturnTextColors(unit, "CurHPPerc", cur, max)
	if RUF.db.global.TestMode == true then
		cur = math.random(7500000)
		max = math.random(7500000,10000000)
	end
	if realunit then
		r,g,b = RUF:ReturnTextColors(realunit, "CurHPPerc", cur, max)
	end
	if UnitIsDead(unit) then
		if RUF.db.profile.Appearance.Text.CurHPPerc.Case == 1 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.upper(L["Dead"]))
		elseif RUF.db.profile.Appearance.Text.CurHPPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(L["Dead"]))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,L["Dead"])
		end		
	elseif UnitIsGhost(unit) then
		if RUF.db.profile.Appearance.Text.CurHPPerc.Case == 1 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.upper(L["Ghost"]))
		elseif RUF.db.profile.Appearance.Text.CurHPPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(L["Ghost"]))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,L["Ghost"])
		end
	elseif not UnitIsConnected(unit) then
		if RUF.db.profile.Appearance.Text.CurHPPerc.Case == 1 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.upper(L["Offline"]))
		elseif RUF.db.profile.Appearance.Text.CurHPPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(L["Offline"]))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,L["Offline"])
		end
	elseif cur == max then -- if we're at full health 
		if RUF.db.profile.Appearance.Text.CurHPPerc.Case == 1 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		elseif RUF.db.profile.Appearance.Text.CurHPPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		end		
	else
		if RUF.db.profile.Appearance.Text.CurHPPerc.Case == 1 then
			return string.format('|cff%02x%02x%02x%s%s%s%%|r',r*255,g*255,b*255,RUF:Short(cur,true), " - ",RUF:Percent(cur,max))
		elseif RUF.db.profile.Appearance.Text.CurHPPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s%s%s%%|r',r*255,g*255,b*255,(RUF:Short(cur,true)), " - ",RUF:Percent(cur,max))
		else
			return string.format('|cff%02x%02x%02x%s%s%s%%|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)), " - ",RUF:Percent(cur,max))
		end		
	end
end
events['RUF:CurHPPerc'] = 'UNIT_HEALTH UNIT_CONNECTION'

tags['RUF:HPPerc'] = function(unit)
	if not UnitName(unit) then return end
	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local r,g,b = RUF:ReturnTextColors(unit, "HPPerc", cur, max)
	if RUF.db.global.TestMode == true then
		cur = math.random(7500000)
		max = math.random(7500000,10000000)
	end
	if realunit then
		r,g,b = RUF:ReturnTextColors(realunit, "HPPerc", cur, max)
	end
	return string.format('|cff%02x%02x%02x%s%%|r',r*255,g*255,b*255,RUF:Percent(cur,max))
end
events['RUF:HPPerc'] = 'UNIT_HEALTH UNIT_CONNECTION'

tags['RUF:CurHP'] = function(unit)
	if not UnitName(unit) then return end
	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local r,g,b = RUF:ReturnTextColors(unit, "CurHP", cur, max)
	if RUF.db.global.TestMode == true then
		cur = math.random(7500000)
		max = math.random(7500000,10000000)
	end
	if realunit then
		r,g,b = RUF:ReturnTextColors(realunit, "CurHP", cur, max)
	end
	if cur == max then -- if we're at full health 
		if RUF.db.profile.Appearance.Text.CurHP.Case == 1 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		elseif RUF.db.profile.Appearance.Text.CurHP.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		end		
	else
		if RUF.db.profile.Appearance.Text.CurHP.Case == 1 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		elseif RUF.db.profile.Appearance.Text.CurHP.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		end	
	end
end
events['RUF:CurHP'] = 'UNIT_HEALTH UNIT_CONNECTION'



----------------------------------------------------------------------------------- POWER
tags['RUF:CurPowerPerc'] = function(unit,realunit)
	if not UnitName(unit) then return end
	local pType,pToken,altr,altg,altb = UnitPowerType(unit)
	local cur, max = UnitPower(unit), UnitPowerMax(unit)
	local r,g,b = RUF:ReturnTextColors(unit, "CurPowerPerc", cur, max)
	if RUF.db.global.TestMode == true then
		cur = math.random(75000)
		max = math.random(75000,100000)
	end
	if realunit and unit ~= string.match(unit, "vehicle") then
		r,g,b = RUF:ReturnTextColors(realunit, "CurPowerPerc", cur, max)
	end
	if RUF.db.profile.Appearance.Text.CurPowerPerc.Enabled == 1 and cur == 0 then
		return ' '
	end
	if cur == max and cur > 0 then
		if RUF.db.profile.Appearance.Text.CurPowerPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		end
	elseif cur < max and cur > 0 then
		if RUF.db.profile.Appearance.Text.CurPowerPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s%s%s%%|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)), " - ",RUF:Percent(cur,max))
		else
			return string.format('|cff%02x%02x%02x%s%s%s%%|r',r*255,g*255,b*255,RUF:Short(cur,true), " - ",RUF:Percent(cur,max))
		end
	else
		if RUF.db.profile.Appearance.Text.CurPowerPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,"0")
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,"0")
		end
	end
end
events['RUF:CurPowerPerc'] = 'UNIT_POWER'

tags['RUF:PowerPerc'] = function(unit,realunit)
	if not UnitName(unit) then return end
	local pType,pToken,altr,altg,altb = UnitPowerType(unit)
	local cur, max = UnitPower(unit), UnitPowerMax(unit)
	local r,g,b = RUF:ReturnTextColors(unit, "PowerPerc", cur, max)
	if RUF.db.global.TestMode == true then
		cur = math.random(75000)
		max = math.random(75000,100000)
	end
	if realunit and unit ~= string.match(unit, "vehicle") then
		r,g,b = RUF:ReturnTextColors(realunit, "PowerPerc", cur, max)
	end
	if RUF.db.profile.Appearance.Text.PowerPerc.Enabled == 1 and cur == 0 then
		return ' '
	end
	return string.format('|cff%02x%02x%02x%s%%|r',r*255,g*255,b*255,RUF:Percent(cur,max))
end
events['RUF:PowerPerc'] = 'UNIT_POWER'

tags['RUF:CurPower'] = function(unit,realunit)
	if not UnitName(unit) then return end
	local pType,pToken,altr,altg,altb = UnitPowerType(unit)
	local cur, max = UnitPower(unit), UnitPowerMax(unit)
	local r,g,b = RUF:ReturnTextColors(unit, "CurPower", cur, max)
	if RUF.db.global.TestMode == true then
		cur = math.random(75000)
		max = math.random(75000,100000)
	end
	if realunit and unit ~= string.match(unit, "vehicle") then
		r,g,b = RUF:ReturnTextColors(realunit, "CurPower", cur, max)
	end
	if RUF.db.profile.Appearance.Text.CurPower.Enabled == 1 and cur == 0 then
		return ' '
	end
	if cur == max and cur > 0 then -- if we're at full health 
		if RUF.db.profile.Appearance.Text.CurPower.Case == 1 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		elseif RUF.db.profile.Appearance.Text.CurPower.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		end		
	else
		if RUF.db.profile.Appearance.Text.CurPower.Case == 1 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		elseif RUF.db.profile.Appearance.Text.CurPower.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		end	
	end
end
events['RUF:CurPower'] = 'UNIT_POWER'



----------------------------------------------------------------------------------- MANA
tags['RUF:CurManaPerc'] = function(unit)
	if not UnitName(unit) then return end
	local pType,pToken,altr,altg,altb = UnitPowerType(unit)
	local cur, max = UnitPower(unit,0), UnitPowerMax(unit,0)
	local r,g,b = RUF:ReturnTextColors(unit, "CurManaPerc", cur, max)
	if RUF.db.global.TestMode == true then
		cur = math.random(75000)
		max = math.random(75000,100000)
	end
	if RUF.db.profile.Appearance.Text.CurManaPerc.HideWhenPrimaryIsMana == true then
		local _,PlayerClass = UnitClass(unit)
		if pToken == "MANA" or PlayerClass == "MONK" then
			return ''
		end
	end

	if RUF.db.profile.Appearance.Text.CurManaPerc.Enabled == 1 and cur == 0 then
		return ''
	end
	if cur == max and cur > 0 then
		if RUF.db.profile.Appearance.Text.CurManaPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		end
	elseif cur < max and cur > 0 then
		if RUF.db.profile.Appearance.Text.CurManaPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s%s%s%%|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)), " - ",RUF:Percent(cur,max))
		else
			return string.format('|cff%02x%02x%02x%s%s%s%%|r',r*255,g*255,b*255,RUF:Short(cur,true), " - ",RUF:Percent(cur,max))
		end
	else
		if RUF.db.profile.Appearance.Text.CurManaPerc.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,"0")
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,"0")
		end
	end
end
events['RUF:CurManaPerc'] = 'UNIT_POWER'

tags['RUF:ManaPerc'] = function(unit)
	if not UnitName(unit) then return end
	local pType,pToken,altr,altg,altb = UnitPowerType(unit)
	local cur, max = UnitPower(unit,0), UnitPowerMax(unit,0)
	local r,g,b = RUF:ReturnTextColors(unit, "ManaPerc", cur, max)
	if RUF.db.global.TestMode == true then
		cur = math.random(75000)
		max = math.random(75000,100000)
	end
	if RUF.db.profile.Appearance.Text.ManaPerc.HideWhenPrimaryIsMana == true then
		local _,PlayerClass = UnitClass(unit)
		if pToken == "MANA" or PlayerClass == "MONK" then
			return ''
		end
	end
	if RUF.db.profile.Appearance.Text.ManaPerc.Enabled == 1 and cur == 0 then
		return ''
	end
	return string.format('|cff%02x%02x%02x%s%%|r',r*255,g*255,b*255,RUF:Percent(cur,max))
end
events['RUF:ManaPerc'] = 'UNIT_POWER'

tags['RUF:CurMana'] = function(unit)
	if not UnitName(unit) then return end
	local pType,pToken,altr,altg,altb = UnitPowerType(unit)
	local cur, max = UnitPower(unit,0), UnitPowerMax(unit,0)
	local r,g,b = RUF:ReturnTextColors(unit, "CurMana", cur, max)
	if RUF.db.global.TestMode == true then
		cur = math.random(75000)
		max = math.random(75000,100000)
	end
	if RUF.db.profile.Appearance.Text.CurMana.HideWhenPrimaryIsMana == true then
		local _,PlayerClass = UnitClass(unit)
		if pToken == "MANA" or PlayerClass == "MONK" then
			return ''
		end
	end
	if RUF.db.profile.Appearance.Text.CurMana.Enabled == 1 and cur == 0 then
		return ''
	end
	if cur == max  and cur > 0 then 
		if RUF.db.profile.Appearance.Text.CurMana.Case == 1 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		elseif RUF.db.profile.Appearance.Text.CurMana.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		end		
	else
		if RUF.db.profile.Appearance.Text.CurMana.Case == 1 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		elseif RUF.db.profile.Appearance.Text.CurMana.Case == 2 then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,string.lower(RUF:Short(cur,true)))
		else
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,RUF:Short(cur,true))
		end	
	end
end
events['RUF:CurMana'] = 'UNIT_POWER'



----------------------------------------------------------------------------------- UNITNAME
tags['RUF:Name'] = function(unit)
	if not UnitName(unit) then return end
	local name
	if RUF.db.profile.Appearance.Text.Name.Case== 1 then 
		name = string.upper(UnitName(unit))
	elseif RUF.db.profile.Appearance.Text.Name.Case == 2 then
		name = string.lower(UnitName(unit))
	else
		name = UnitName(unit)
	end

	local player = string.upper(UnitName("player"))
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
	local r,g,b = RUF:ReturnTextColors(unit, "Name", cur, max)
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
		r,g,b = RUF:ReturnTextColors(unit, "Name", cur, max,val)
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



----------------------------------------------------------------------------------- STATUS
tags['RUF:Level'] = function(unit)
	local l = UnitLevel(unit)
	if RUF.db.global.TestMode == true then
		l = math.random(120)
	end
	local r,g,b = RUF:ReturnTextColors(unit, "Level")
	if l <= 0 then l = "??" end
	if RUF.db.profile.Appearance.Text.Level.HideSameLevel == true then
		if l ~= UnitLevel("player") then
			return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,l)
		else
			return ''
		end
	else
		return string.format('|cff%02x%02x%02x%s|r',r*255,g*255,b*255,l)
	end
end
events['RUF:Level'] = 'UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED'

tags['RUF:AFKDND'] = function(unit)
	local r,g,b = RUF:ReturnTextColors(unit, "AFKDND")
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
