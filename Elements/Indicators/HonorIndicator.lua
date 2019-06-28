local _, ns = ...
local oUF = ns.oUF
local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")

local function Update(self, event, unit)
	if(unit ~= self.unit) then return end

	local element = self.HonorIndicator

	if(element.PreUpdate) then
		element:PreUpdate(unit)
	end

	local status
	local factionGroup = UnitFactionGroup(unit)
	local honorRewardInfo = C_PvP.GetHonorRewardInfo(UnitHonorLevel(unit))

	if(UnitIsPVPFreeForAll(unit)) then
		status = 'FFA'
	elseif(factionGroup and factionGroup ~= 'Neutral' and UnitIsPVP(unit)) then
		if(unit == 'player' and UnitIsMercenary(unit)) then
			if(factionGroup == 'Horde') then
				factionGroup = 'Alliance'
			elseif(factionGroup == 'Alliance') then
				factionGroup = 'Horde'
			end
		end
		status = factionGroup
	elseif element.AlwaysShow then
		if element.AlwaysShow == true then
			status = factionGroup
		end
	end
	if status then
		if honorRewardInfo then
			element:SetTexture(honorRewardInfo.badgeFileDataID)
			element:SetTexCoord(0, 1, 0, 1)
			element.Badge:SetAtlas('honorsystem-portrait-' .. factionGroup, false)
			element.Badge:Show()
			element:Show()
		else
			element:Hide()
			element.Badge:Hide()
		end
	else
		element:Hide()
		element.Badge:Hide()
	end

	if RUF.db.global.TestMode == true then
		element:SetTexture(1597394)
		element:SetTexCoord(0, 1, 0, 1)
		element.Badge:SetAtlas('honorsystem-portrait-' .. 'Alliance', false)
		element.Badge:Show()
		element:Show()
	end

	if(element.PostUpdate) then
		return element:PostUpdate(unit, status)
	end
end

local function Path(self, ...)
	--[[Override: HonorIndicator.Override(self, event, ...)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* ...   - the arguments accompanying the event
	--]]
	return (self.HonorIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	local element = self.HonorIndicator
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_FACTION', Path)
		--self:RegisterEvent('HONOR_LEVEL_UPDATE', Path)

		return true
	end
end

local function Disable(self)
	local element = self.HonorIndicator
	if(element) then
		element:Hide()

		if(element.Badge) then
			element.Badge:Hide()
		end

		self:UnregisterEvent('UNIT_FACTION', Path)
		--self:UnregisterEvent('HONOR_LEVEL_UPDATE', Path)
	end
end

oUF:AddElement('HonorIndicator', Path, Enable, Disable)
