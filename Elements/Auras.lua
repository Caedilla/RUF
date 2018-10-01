local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF

--[[
    ## Options
.disableMouse       - Disables mouse events (boolean)
.disableCooldown    - Disables the cooldown spiral (boolean)
.size               - Aura icon size. Defaults to 16 (number)
.onlyShowPlayer     - Shows only auras created by player/vehicle (boolean)
.showStealableBuffs - Displays the stealable texture on buffs that can be stolen (boolean)
.spacing            - Spacing between each icon. Defaults to 0 (number)
.['spacing-x']      - Horizontal spacing between each icon. Takes priority over `spacing` (number)
.['spacing-y']      - Vertical spacing between each icon. Takes priority over `spacing` (number)
.['growth-x']       - Horizontal growth direction. Defaults to 'RIGHT' (string)
.['growth-y']       - Vertical growth direction. Defaults to 'UP' (string)
.initialAnchor      - Anchor point for the icons. Defaults to 'BOTTOMLEFT' (string)
.filter             - Custom filter list for auras to display. Defaults to 'HELPFUL' for buffs and 'HARMFUL' for
                      debuffs (string)

    ## Options Auras
.numBuffs     - The maximum number of buffs to display. Defaults to 32 (number)
.numDebuffs   - The maximum number of debuffs to display. Defaults to 40 (number)
.numTotal     - The maximum number of auras to display. Prioritizes buffs over debuffs. Defaults to the sum of
                .numBuffs and .numDebuffs (number)
.gap          - Controls the creation of an invisible icon between buffs and debuffs. Defaults to false (boolean)
.buffFilter   - Custom filter list for buffs to display. Takes priority over `filter` (string)
.debuffFilter - Custom filter list for debuffs to display. Takes priority over `filter` (string)

    ## Options Buffs
.num - Number of buffs to display. Defaults to 32 (number)

    ## Options Debuffs
.num - Number of debuffs to display. Defaults to 40 (number)

## Attributes
button.caster   - the unit who cast the aura (string)
button.filter   - the filter list used to determine the visibility of the aura (string)
button.isDebuff - indicates if the button holds a debuff (boolean)
button.isPlayer - indicates if the aura caster is the player or their vehicle (boolean)
]]--
local _, PlayerClass
local Specialization

local BuffDispel = {-- PURGES
	["DEATHKNIGHT"] = {
		[1] = {"None"},
		[2] = {"None"},
		[3] = {"None"},
	},
	["DEMONHUNTER"] = {
		[1] = {"Magic"},
		[2] = {"Magic"},
	},
	["DRUID"] = {
		[1] = {"Enrage"},
		[2] = {"Enrage"},
		[3] = {"Enrage"},
		[4] = {"Enrage"},		
	},
	["HUNTER"] = {
		[1] = {"Enrage"},
		[2] = {"Enrage"},
		[3] = {"Enrage"},
	},
	["MAGE"] = {
		[1] = {"Magic"},
		[2] = {"Magic"},
		[3] = {"Magic"},
	},
	["MONK"] = {
		[1] = {"None"},
		[2] = {"None"},
		[3] = {"None"},
	},
	["PALADIN"] = {
		[1] = {"None"},
		[2] = {"None"},
		[3] = {"None"},
	},
	["PRIEST"] = {
		[1] = {"Magic"},
		[2] = {"Magic"},
		[3] = {"Magic"},
	},
	["ROGUE"] = {
		[1] = {"None"},
		[2] = {"None"},
		[3] = {"None"},
	},
	["SHAMAN"] = {
		[1] = {"Magic"},
		[2] = {"Magic"},
		[3] = {"Magic"},
	},
	["WARLOCK"] = {
		[1] = {"Magic"},
		[2] = {"Magic"},
		[3] = {"Magic"},
	},
	["WARRIOR"] = {
		[1] = {"None"},
		[2] = {"None"},
		[3] = {"None"},
	},
}

local DebuffDispel = {-- DISPELLING ALLIES
	["DEATHKNIGHT"] = {
		[1] = {"None"},
		[2] = {"None"},
		[3] = {"None"},
	},
	["DEMONHUNTER"] = {
		[1] = {"None"},
		[2] = {"None"},
	},
	["DRUID"] = {
		[1] = {"Curse","Poison"},
		[2] = {"Curse","Poison"},
		[3] = {"Curse","Poison"},
		[4] = {"Curse","Magic","Poison"},		
	},
	["HUNTER"] = {
		[1] = {"None"},
		[2] = {"None"},
		[3] = {"None"},
	},
	["MAGE"] = {
		[1] = {"Curse"},
		[2] = {"Curse"},
		[3] = {"Curse"},
	},
	["MONK"] = {
		[1] = {"Disease","Poison"},
		[2] = {"Disease","Magic","Poison"},
		[3] = {"Disease","Poison"},
	},
	["PALADIN"] = {
		[1] = {"Disease","Magic","Poison"},
		[2] = {"Disease","Poison"},
		[3] = {"Disease","Poison"},
	},
	["PRIEST"] = {
		[1] = {"Disease","Magic"},
		[2] = {"Disease","Magic"},
		[3] = {"Disease"},
	},
	["ROGUE"] = {
		[1] = {"None"},
		[2] = {"None"},
		[3] = {"None"},
	},
	["SHAMAN"] = {
		[1] = {"Curse"},
		[2] = {"Curse"},
		[3] = {"Curse","Magic"},
	},
	["WARLOCK"] = {
		[1] = {"Magic"},
		[2] = {"Magic"},
		[3] = {"Magic"},
	},
	["WARRIOR"] = {
		[1] = {"None"},
		[2] = {"None"},
		[3] = {"None"},
	},
}


local function GetCurrentSpec()
	Specialization = GetSpecialization()
end

local TalenMonitor = CreateFrame("Frame")
TalenMonitor:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
TalenMonitor:SetScript("OnEvent",GetCurrentSpec)


function RUF.GetAuraAnchorFrame(self,unit,aura)    
    local AnchorFrame = "Frame"
    if RUF.db.profile.unit[unit][aura].Icons.Position.AnchorFrame == "Frame" then
        AnchorFrame = self:GetName()
	else
		--AnchorFrame = self:GetName().."."..RUF.db.profile.unit[unit].Frame.Indicators[indicator].Position.AnchorFrame.."Indicator"
        AnchorFrame = self:GetName()
        if not _G[AnchorFrame] then
            AnchorFrame = self:GetName()
        end
    end
    return AnchorFrame
end

local function CustomBuffFilter(element, unit, button, ...)
	--[[ Override: Auras:CustomFilter(unit, button, ...)
	Defines a custom filter that controls if the aura button should be shown.

	* self   - the widget holding the aura buttons
	* unit   - the unit on which the aura is cast (string)
	* button - the button displaying the aura (Button)
	* ...    - the return values from [UnitAura](http://wowprogramming.com/docs/api/UnitAura.html)

	## Returns

	* show - indicates whether the aura button should be shown (boolean)
	--]]


	-- If the unit is in a vehicle etc.
	local frame = element:GetParent()
	if frame.realUnit then
		unit = frame.realUnit
	end


	if RUF.db.profile.unit[unit].Buffs.Icons.Enabled == false then 
		button.shoudShow = false
		return false
	end

	local name, icon, count, debuffType, duration, expirationTime, source, isStealable, 
	nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, nameplateShowAll, timeMod, value1, value2, value3 = ...

	if button.AuraName then
		if button.AuraName == name and button.expirationTime == expirationTime and button.shoudShow then
			return button.shoudShow
		end
	end
	
	button.AuraName = name
	button.expirationTime = expirationTime



	local BuffTypes
	if UnitIsFriend("player",unit) then
		BuffTypes = "None" -- Cannot dispel friendly buffs
	else
		BuffTypes = BuffDispel[PlayerClass][Specialization]
	end
	local removable = false
	if BuffTypes == "None" then
		removable = false
	else
		for k,v in pairs(BuffTypes) do
			if v == debuffType then
				removable = true
			end
		end
	end
	if not source or source == nil then source = unit end
	local affiliation 
	if source == "player" then affiliation = "player"
	elseif source == unit then affiliation = "unit"
	elseif IsInGroup() and UnitPlayerOrPetInParty(source) then affiliation = "group"
	elseif IsInRaid() and UnitInRaid(source) then affiliation = "group"
	else affiliation = "other"
	end


	if duration == 0 and RUF.db.profile.unit[unit].Buffs.Icons.Filter.Time.Unlimited == false then
		-- Unlimited
		button.shoudShow = false
		return false
	elseif duration ~= 0 and duration < RUF.db.profile.unit[unit].Buffs.Icons.Filter.Time.Min and RUF.db.profile.unit[unit].Buffs.Icons.Filter.Time.Min > 0 then
		-- Shorter than Minimum duration.
		button.shoudShow = false
		return false
	elseif duration > RUF.db.profile.unit[unit].Buffs.Icons.Filter.Time.Max and RUF.db.profile.unit[unit].Buffs.Icons.Filter.Time.Max > 0 then
		-- Longer than Max duration.
		button.shoudShow = false
		return false
	end

	if (RUF.db.profile.unit[unit].Buffs.Icons.Filter.Dispellable == true and removable == true) or RUF.db.profile.unit[unit].Buffs.Icons.Filter.Dispellable == false then
		if RUF.db.profile.unit[unit].Buffs.Icons.Filter.Caster.Player == true then
			if affiliation == "player" then
				button.shoudShow = true
				return true 
			end
		end
		if RUF.db.profile.unit[unit].Buffs.Icons.Filter.Caster.Unit == true then
			if affiliation == "unit" then
				button.shoudShow = true
				return true
			end
		end
		if RUF.db.profile.unit[unit].Buffs.Icons.Filter.Caster.Group == true then
			if affiliation == "group" then
				button.shoudShow = true
				return true
			end
		end
		if RUF.db.profile.unit[unit].Buffs.Icons.Filter.Caster.Other == true then
			if affiliation == "other" then
				button.shoudShow = true
				return true
			end
		end
	else
		button.shoudShow = false
		return false
	end

	button.shoudShow = false
	return false
end

local function CustomDebuffFilter(element, unit, button, ...)
	--[[ Override: Auras:CustomFilter(unit, button, ...)
	Defines a custom filter that controls if the aura button should be shown.

	* self   - the widget holding the aura buttons
	* unit   - the unit on which the aura is cast (string)
	* button - the button displaying the aura (Button)
	* ...    - the return values from [UnitAura](http://wowprogramming.com/docs/api/UnitAura.html)

	## Returns

	* show - indicates whether the aura button should be shown (boolean)
	--]]

	-- If the unit is in a vehicle etc.
	local frame = element:GetParent()
	if frame.realUnit then
		unit = frame.realUnit
	end
	
	if RUF.db.profile.unit[unit].Debuffs.Icons.Enabled == false then 
		button.shoudShow = false
		return false
	end

	local name, icon, count, debuffType, duration, expirationTime, source, isStealable, 
	nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, nameplateShowAll, timeMod, value1, value2, value3 = ...

	if button.AuraName then
		if button.AuraName == name and button.expirationTime == expirationTime and button.shoudShow then
			return button.shoudShow
		end
	end
	
	button.AuraName = name
	button.expirationTime = expirationTime

	local BuffTypes
	if UnitIsFriend("player",unit) then
		BuffTypes = DebuffDispel[PlayerClass][Specialization]
	else
		BuffTypes = "None" -- Can't dispel a debuff from an enemy. 
	end
	local removable = false
	if BuffTypes == "None" then
		removable = false
	else
		for k,v in pairs(BuffTypes) do
			if v == debuffType then
				removable = true
			end
		end
	end

	if not source or source == nil then source = unit end
	local affiliation 
	if source == "player" then affiliation = "player"
	elseif UnitName(source) == UnitName(unit) then affiliation = "unit"
	elseif IsInGroup() and UnitPlayerOrPetInParty(source) then affiliation = "group"
	elseif IsInRaid() and UnitInRaid(source) then affiliation = "group"
	--elseif isBossDebuff then affiliation = "boss"
	else affiliation = "other"
	end

	if duration == 0 and RUF.db.profile.unit[unit].Debuffs.Icons.Filter.Time.Unlimited == false then
		-- Unlimited
		button.shoudShow = false
		return false
	elseif duration ~= 0 and duration < RUF.db.profile.unit[unit].Debuffs.Icons.Filter.Time.Min and RUF.db.profile.unit[unit].Debuffs.Icons.Filter.Time.Min > 0 then
		-- Shorter than Minimum duration.
		button.shoudShow = false
		return false
	elseif duration > RUF.db.profile.unit[unit].Debuffs.Icons.Filter.Time.Max and RUF.db.profile.unit[unit].Debuffs.Icons.Filter.Time.Max > 0 then
		-- Longer than Max duration.
		button.shoudShow = false
		return false
	end

	if (RUF.db.profile.unit[unit].Debuffs.Icons.Filter.Dispellable == true and removable == true) or RUF.db.profile.unit[unit].Debuffs.Icons.Filter.Dispellable == false then
		if RUF.db.profile.unit[unit].Debuffs.Icons.Filter.Caster.Player == true then
			if affiliation == "player" then
				button.shoudShow = true
				return true
			end
		end
		if RUF.db.profile.unit[unit].Debuffs.Icons.Filter.Caster.Unit == true then
			if affiliation == "unit" then
				button.shoudShow = true
				return true
			end
		end
		if RUF.db.profile.unit[unit].Debuffs.Icons.Filter.Caster.Group == true then
			if affiliation == "group" then
				button.shoudShow = true
				return true
			end
		end
		if RUF.db.profile.unit[unit].Debuffs.Icons.Filter.Caster.Other == true then
			if affiliation == "other" then
				button.shoudShow = true
				return true
			end
		end
	else
		button.shoudShow = false
		return false
	end

	button.shoudShow = false
	return false
end

local function UpdateTooltip(self)
	GameTooltip:SetUnitAura(self:GetParent().__owner.unit, self:GetID(), self.filter)
end

local function onEnter(self)
	if(not self:IsVisible()) then return end

	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
	self:UpdateTooltip()
end

local function onLeave()
	GameTooltip:Hide()
end

local function createAuraIcon(element, index)
	local button = CreateFrame('Button', element:GetDebugName() .. 'Button' .. index, element)
	button:RegisterForClicks('RightButtonUp')

	local cd = CreateFrame('Cooldown', '$parentCooldown', button, 'CooldownFrameTemplate')
	cd:SetAllPoints()

	local icon = button:CreateTexture(nil, 'BORDER')
	icon:SetTexCoord(0.05,0.95,0.05,0.95)
	icon:SetAllPoints()

	local pixel = CreateFrame("Frame",nil,button)
	pixel:SetAllPoints()
	pixel:SetFrameLevel(7)
	pixel:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Aura.Pixel.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Aura.Pixel.Style.edgeSize})
	local pixelr,pixelg,pixelb,pixela = unpack(RUF.db.profile.Appearance.Colors.Aura.Pixel)
	pixel:SetBackdropBorderColor(pixelr,pixelg,pixelb,pixela)	
	if RUF.db.profile.Appearance.Aura.Pixel.Enabled == true then
		pixel:Show()
	else
		pixel:Hide()
	end
	local PixelOffset = RUF.db.profile.Appearance.Aura.Pixel.Offset
	if PixelOffset == 0 then
		pixel:SetPoint("TOPLEFT",button,"TOPLEFT",0,0)
		pixel:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",0,0)			
	elseif PixelOffset > 0 then
		pixel:SetPoint("TOPLEFT",button,"TOPLEFT",-PixelOffset,PixelOffset)
		pixel:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",PixelOffset,-PixelOffset)
	elseif PixelOffset < 0 then
		pixel:SetPoint("TOPLEFT",button,"TOPLEFT",-PixelOffset,PixelOffset)
		pixel:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",PixelOffset,-PixelOffset)
	end
	button.pixel = pixel

	local border = CreateFrame("Frame",nil,button)
	border:SetAllPoints()
	border:SetFrameLevel(8)
	border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Aura.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Aura.Border.Style.edgeSize})
	local borderr,borderg,borderb,bordera = unpack(RUF.db.profile.Appearance.Colors.Aura.DefaultBuff)
	border:SetBackdropBorderColor(borderr,borderg,borderb,bordera)	

	local BorderOffset = RUF.db.profile.Appearance.Aura.Border.Offset
	if BorderOffset == 0 then
		border:SetPoint("TOPLEFT",button,"TOPLEFT",0,0)
		border:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",0,0)			
	elseif BorderOffset > 0 then
		border:SetPoint("TOPLEFT",button,"TOPLEFT",-BorderOffset,BorderOffset)
		border:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",BorderOffset,-BorderOffset)
	elseif BorderOffset < 0 then
		border:SetPoint("TOPLEFT",button,"TOPLEFT",-BorderOffset,BorderOffset)
		border:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",BorderOffset,-BorderOffset)
	end
	button.border = border

	local count = button:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
	count:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -1, 0)

	local stealable = button:CreateTexture(nil, 'OVERLAY')
	stealable:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
	stealable:SetPoint('TOPLEFT', -3, 3)
	stealable:SetPoint('BOTTOMRIGHT', 3, -3)
	stealable:SetBlendMode('ADD')
	button.stealable = stealable

	button.UpdateTooltip = UpdateTooltip
	button:SetScript('OnEnter', onEnter)
	button:SetScript('OnLeave', onLeave)

	button.icon = icon
	button.count = count
	button.cd = cd

	--[[ Callback: Auras:PostCreateIcon(button)
	Called after a new aura button has been created.

	* self   - the widget holding the aura buttons
	* button - the newly created aura button (Button)
	--]]
	if(element.PostCreateIcon) then element:PostCreateIcon(button) end

	return button
end

local function PostUpdateBuffIcon(self,unit,button,index,position,duration,expiration,debuffType,isStealable)
	--[[ Callback: Auras:PostUpdateIcon(unit, button, index, position)
	Called after the aura button has been updated.

	* self        - the widget holding the aura buttons
	* unit        - the unit on which the aura is cast (string)
	* button      - the updated aura button (Button)
	* index       - the index of the aura (number)
	* position    - the actual position of the aura button (number)
	* duration    - the aura duration in seconds (number?)
	* expiration  - the point in time when the aura will expire. Comparable to GetTime() (number)
	* debuffType  - the debuff type of the aura (string?)['Curse', 'Disease', 'Magic', 'Poison']
	* isStealable - whether the aura can be stolen or purged (boolean)
	--]]
	if button.shoudShow and button.shoudShow == false then return end
	if button.AuraName then
		if button.AuraName == name and button.expirationTime == expirationTime and button.updated then
			if button.updated == true then return end
		end
	end
	button.updated = false
	local r,g,b,a = unpack(RUF.db.profile.Appearance.Colors.Aura.DefaultBuff)

	local BuffTypes
	if UnitIsFriend("player",unit) then
		BuffTypes = "None" -- Cannot dispel friendly buffs
	else
		BuffTypes = BuffDispel[PlayerClass][Specialization]
	end
	local removable = false
	if BuffTypes == "None" then
		removable = false
	else
		for k,v in pairs(BuffTypes) do
			if v == debuffType then
				removable = true
			end
		end
	end
	if (RUF.db.profile.Appearance.Aura.OnlyDispellable == true and removable == true) or RUF.db.profile.Appearance.Aura.OnlyDispellable == false  then
		if debuffType and (debuffType == "Magic" or debuffType == "Curse" or debuffType == "Disease" or debuffType == "Poison") then
			if self.visibleBuffs and RUF.db.profile.Appearance.Aura.Buff == true then -- Buff
				r,g,b,a = unpack(RUF.db.profile.Appearance.Colors.Aura[debuffType])
			elseif self.visibleDebuffs and RUF.db.profile.Appearance.Aura.Debuff == true then -- Debuffs
				r,g,b,a = unpack(RUF.db.profile.Appearance.Colors.Aura[debuffType])
			end
		end
	end
	
	if self[position] then
		self[position].border:SetBackdropBorderColor(r,g,b,a)
	end

	button.updated = true
end

local function PostUpdateDebuffIcon(self,unit,button,index,position,duration,expiration,debuffType,isStealable)
	--[[ Callback: Auras:PostUpdateIcon(unit, button, index, position)
	Called after the aura button has been updated.

	* self        - the widget holding the aura buttons
	* unit        - the unit on which the aura is cast (string)
	* button      - the updated aura button (Button)
	* index       - the index of the aura (number)
	* position    - the actual position of the aura button (number)
	* duration    - the aura duration in seconds (number?)
	* expiration  - the point in time when the aura will expire. Comparable to GetTime() (number)
	* debuffType  - the debuff type of the aura (string?)['Curse', 'Disease', 'Magic', 'Poison']
	* isStealable - whether the aura can be stolen or purged (boolean)
	--]]
	if button.shoudShow and button.shoudShow == false then return end
	if button.AuraName then
		if button.AuraName == name and button.expirationTime == expirationTime and button.updated then
			if button.updated == true then return end
		end
	end
	button.updated = false

	local r,g,b,a = unpack(RUF.db.profile.Appearance.Colors.Aura.DefaultBuff)

	if self.visibleDebuffs then
		r,g,b,a = unpack(RUF.db.profile.Appearance.Colors.Aura.DefaultDebuff)
	end
	local BuffTypes
	if UnitIsFriend("player",unit) then
		BuffTypes = DebuffDispel[PlayerClass][Specialization]
	else
		BuffTypes = "None" -- Can't dispel a debuff from an enemy. 
	end
	local removable = false
	if BuffTypes == "None" then
		removable = false
	else
		for k,v in pairs(BuffTypes) do
			if v == debuffType then
				removable = true
			end
		end
	end
	if (RUF.db.profile.Appearance.Aura.OnlyDispellable == true and removable == true) or RUF.db.profile.Appearance.Aura.OnlyDispellable == false  then
		if debuffType and (debuffType == "Magic" or debuffType == "Curse" or debuffType == "Disease" or debuffType == "Poison") then
			if self.visibleBuffs and RUF.db.profile.Appearance.Aura.Buff == true then -- Buff
				r,g,b,a = unpack(RUF.db.profile.Appearance.Colors.Aura[debuffType])
			elseif self.visibleDebuffs and RUF.db.profile.Appearance.Aura.Debuff == true then -- Debuffs
				r,g,b,a = unpack(RUF.db.profile.Appearance.Colors.Aura[debuffType])
			end
		else
			r,g,b,a = unpack(RUF.db.profile.Appearance.Colors.Aura.DefaultDebuff)
		end
	end
	
	if self[position] then
		self[position].border:SetBackdropBorderColor(r,g,b,a)
	end

	button.updated = true
end

function RUF.SetBuffs(self, unit)
	_, PlayerClass = UnitClass('player')
	Specialization = GetSpecialization()	
	local Buffs = CreateFrame('Frame', self:GetName()..".Buffs", self)
    Buffs:SetPoint(
        RUF.db.profile.unit[unit].Buffs.Icons.Position.AnchorFrom,
        RUF.GetAuraAnchorFrame(self,unit,"Buffs"),
        RUF.db.profile.unit[unit].Buffs.Icons.Position.AnchorTo,
        RUF.db.profile.unit[unit].Buffs.Icons.Position.x,
        RUF.db.profile.unit[unit].Buffs.Icons.Position.y)

	Buffs:SetSize((RUF.db.profile.unit[unit].Buffs.Icons.Size * RUF.db.profile.unit[unit].Buffs.Icons.Columns), (RUF.db.profile.unit[unit].Buffs.Icons.Size * RUF.db.profile.unit[unit].Buffs.Icons.Rows) + 2) -- x,y size of buff holder frame
	Buffs.size = RUF.db.profile.unit[unit].Buffs.Icons.Size
	Buffs["growth-x"] = RUF.db.profile.unit[unit].Buffs.Icons.Growth.x
	Buffs["growth-y"] = RUF.db.profile.unit[unit].Buffs.Icons.Growth.y
	Buffs.initialAnchor = RUF.db.profile.unit[unit].Buffs.Icons.Position.AnchorFrom -- Where icons spawn from in the buff frame
	Buffs["spacing-x"] = RUF.db.profile.unit[unit].Buffs.Icons.Spacing.x
	Buffs["spacing-y"] = RUF.db.profile.unit[unit].Buffs.Icons.Spacing.y

	if RUF.db.profile.unit[unit].Buffs.Icons.ClickThrough == true then
		Buffs.disableMouse = true
	else
		Buffs.disableMouse = false
	end

	if RUF.db.profile.unit[unit].Buffs.Icons.CooldownSpiral == true then
		Buffs.disableCooldown = false
	else
		Buffs.disableCooldown = true
	end

	Buffs.num = RUF.db.profile.unit[unit].Buffs.Icons.Max

	Buffs.CustomFilter = CustomBuffFilter
	Buffs.CreateIcon = createAuraIcon
	Buffs.PostUpdateIcon = PostUpdateBuffIcon

	if RUF.db.profile.unit[unit].Buffs.Icons.Enabled == false then
		Buffs:Hide()
	end
	self.Buffs = Buffs
end

function RUF.SetDebuffs(self, unit)
	_, PlayerClass = UnitClass('player')
	Specialization = GetSpecialization()
	local Debuffs = CreateFrame('Frame', nil, self)
    Debuffs:SetPoint(
        RUF.db.profile.unit[unit].Debuffs.Icons.Position.AnchorFrom,
        RUF.GetAuraAnchorFrame(self,unit,"Debuffs"),
        RUF.db.profile.unit[unit].Debuffs.Icons.Position.AnchorTo,
        RUF.db.profile.unit[unit].Debuffs.Icons.Position.x,
        RUF.db.profile.unit[unit].Debuffs.Icons.Position.y)

	Debuffs:SetSize((RUF.db.profile.unit[unit].Debuffs.Icons.Size * RUF.db.profile.unit[unit].Debuffs.Icons.Columns), (RUF.db.profile.unit[unit].Debuffs.Icons.Size * RUF.db.profile.unit[unit].Debuffs.Icons.Rows) + 2) -- x,y size of buff holder frame
	Debuffs.size = RUF.db.profile.unit[unit].Debuffs.Icons.Size
	Debuffs["growth-x"] = RUF.db.profile.unit[unit].Debuffs.Icons.Growth.x
	Debuffs["growth-y"] = RUF.db.profile.unit[unit].Debuffs.Icons.Growth.y
	Debuffs.initialAnchor = RUF.db.profile.unit[unit].Debuffs.Icons.Position.AnchorFrom -- Where icons spawn from in the buff frame
	Debuffs["spacing-x"] = RUF.db.profile.unit[unit].Debuffs.Icons.Spacing.x
	Debuffs["spacing-y"] = RUF.db.profile.unit[unit].Debuffs.Icons.Spacing.y
	if RUF.db.profile.unit[unit].Debuffs.Icons.ClickThrough == true then
		Debuffs.disableMouse = true
	else
		Debuffs.disableMouse = false
	end

	if RUF.db.profile.unit[unit].Debuffs.Icons.CooldownSpiral == true then
		Debuffs.disableCooldown = false
	else
		Debuffs.disableCooldown = true
	end

	Debuffs.num = RUF.db.profile.unit[unit].Debuffs.Icons.Max

	Debuffs.CustomFilter = CustomDebuffFilter
	Debuffs.CreateIcon = createAuraIcon
	Debuffs.PostUpdateIcon = PostUpdateDebuffIcon

	if RUF.db.profile.unit[unit].Debuffs.Icons.Enabled == false then
		Debuffs:Hide()
	end
	self.Debuffs = Debuffs
end


-- TODO:
-- AURA Bars, use oUF_Lumen.
--[[
      if self.cfg.auras.barTimers.show then
    local barTimers = auras:CreateBarTimer(self, 12, 12, 24, 2)
    barTimers:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -2, cfg.frames.secondary.height + 16)
    barTimers.initialAnchor = "BOTTOMLEFT"
    barTimers["growth-y"] = "UP"
    barTimers.CustomFilter = PlayerCustomFilter
    barTimers.PostUpdateIcon = PostUpdateBarTimer
    self.Buffs = barTimers
  end
]]--

--[[-- Post Update BarTimer Aura
local PostUpdateBarTimer = function(element, unit, button, index)
  local name, _, count, dtype, duration, expirationTime = UnitAura(unit, index, button.filter)

  if duration and duration > 0 then
    button.timeLeft = expirationTime - GetTime()
    button.bar:SetMinMaxValues(0, duration)
    button.bar:SetValue(button.timeLeft)

    if button.isDebuff then -- bar color
      button.bar:SetStatusBarColor(1, 0.1, 0.2)
    else
      button.bar:SetStatusBarColor(0, 0.4, 1)
    end
  else
    button.timeLeft = math.huge
    button.bar:SetStatusBarColor(0.6, 0, 0.8) -- permenant buff / debuff
  end

  button.spell:SetText(name) -- set spell name

  button:SetScript('OnUpdate', function(self, elapsed)
    auras:BarTimer_OnUpdate(self, elapsed)
  end)
end]]--

--[[local _, ns = ...

local auras = ns.auras
local core, cfg, m, oUF = ns.core, ns.cfg, ns.m, ns.oUF

local max = max

-- ------------------------------------------------------------------------
-- > BARTIME AURAS RELATED FUNCTIONS
-- ------------------------------------------------------------------------

function auras:BarTimer_OnUpdate(icon, elapsed)
	if icon.timeLeft then
		icon.timeLeft = max(icon.timeLeft - elapsed, 0)
		icon.bar:SetValue(icon.timeLeft) -- update the statusbar

		-- text color
		if icon.timeLeft > 0 and icon.timeLeft < 60 then
			icon.time:SetFormattedText(core:formatTime(icon.timeLeft))
			if icon.timeLeft < 6 then
				icon.time:SetTextColor(1, 0.25, 0.25)
			elseif icon.timeLeft < 10 then
					icon.time:SetTextColor(1, 0.9, 0.5)
			else
				icon.time:SetTextColor(1, 1, 1)
			end
		elseif icon.timeLeft > 60 and icon.timeLeft < 60 * 5 then
			icon.time:SetTextColor(1, 1, 1)
			icon.time:SetFormattedText(core:formatTime(icon.timeLeft))
		else
			icon.time:SetText()
		end
	end
end

local SortAuras = function(a, b)
    if a and b and a.timeLeft and b.timeLeft then
    	return a.timeLeft > b.timeLeft
    end
end

local PreSetPosition = function(Auras)
	table.sort(Auras, SortAuras)
	return 1
end

local PostCreateBar = function(Auras, button)
  button.icon:SetTexCoord(0, 1, 0, 1)

  button.overlay:SetTexture(m.textures.border)
  button.overlay:SetTexCoord(0, 1, 0, 1)
  button.overlay.Hide = function(self) self:SetVertexColor(0.3, 0.3, 0.3) end

	button.bar = CreateFrame('StatusBar', nil, button)
	button.bar:SetStatusBarTexture(m.textures.status_texture)
	button.bar:SetPoint("TOPLEFT", button, 'TOPRIGHT', 4, -2)
	button.bar:SetHeight(Auras.size - 4)
	button.bar:SetWidth(cfg.frames.main.width - Auras.size - 2)
	core:setBackdrop(button.bar, 2, 2, 2, 2)

	button.bar.bg = button.bar:CreateTexture(nil, 'BORDER')
	button.bar.bg:SetAllPoints()
	button.bar.bg:SetAlpha(0.3)
	button.bar.bg:SetTexture(m.textures.bg_texture)
	button.bar.bg:SetColorTexture(1/3, 1/3, 1/3)

	button.spell = button.bar:CreateFontString(nil, 'OVERLAY')
	button.spell:SetPoint("LEFT", button.bar, "LEFT", 4, 0)
	button.spell:SetFont(m.fonts.font_big, 16, "THINOUTLINE")
	button.spell:SetWidth(button.bar:GetWidth() - 25)
	button.spell:SetTextColor(1, 1, 1)
	button.spell:SetShadowOffset(1, -1)
	button.spell:SetShadowColor(0, 0, 0, 1)
	button.spell:SetJustifyH("LEFT")
	button.spell:SetWordWrap(false)

	button.time = button.bar:CreateFontString(nil, 'OVERLAY')
	button.time:SetPoint("RIGHT", button.bar, "RIGHT", -4, 0)
	button.time:SetFont(m.fonts.font, 12, "THINOUTLINE")
	button.time:SetTextColor(1, 1, 1)
	button.time:SetShadowOffset(1, -1)
	button.time:SetShadowColor(0, 0, 0, 1)
	button.time:SetJustifyH('RIGHT')

	button.count:ClearAllPoints()
	button.count:SetFont(m.fonts.font, 12, 'OUTLINE')
	button.count:SetPoint('TOPRIGHT', button, 3, 3)
end

function auras:CreateBarTimer(self, num, rows, size, spacing)
	local auras = CreateFrame("Frame", nil, self)
	auras:SetSize( (num * (size + 9)) / rows, (size + 9) * rows)
	auras.num = num
	auras.size = size
	auras.spacing = spacing or 4
	auras.disableCooldown = true
	auras.PreSetPosition = PreSetPosition  -- sort auras by time remaining
	auras.PostCreateIcon = PostCreateBar -- set overlay, cd, count, timer
	return auras
end
]]--

