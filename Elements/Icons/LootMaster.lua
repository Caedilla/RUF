local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local elementName = 'LootMaster'
local elementString = RUF.IndicatorGlyphs['LootMaster']

local function Update(self, event)
	local element = self.LootMasterIndicator
	element.Enabled = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName].Enabled

	if(element.PreUpdate) then
		element:PreUpdate()
	end
	if element.Enabled == true then
		local unit = self.unit
		local isLootMasterant = UnitInRaid(unit) and UnitIsGroupLootMasterant(unit) and not UnitIsGroupLeader(unit)
		if(isLootMasterant) then
			element:SetText(elementString)
			element:SetWidth(element:GetStringWidth()+2)
			element:Show()
		else
			element:Hide()
			element:SetText(' ')
			element:SetWidth(1)
		end
		if RUF.db.global.TestMode == true then
			element:SetText(elementString)
			element:SetWidth(element:GetStringWidth()+2)
			element:Show()
		end
	else
		self:DisableElement('LootMasterIndicator')
		element:Hide()
	end

	if(element.PostUpdate) then
		return element:PostUpdate(isLootMasterant)
	end
end

local function Path(self, ...)
	return (self.LootMasterIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self)
	local element = self.LootMasterIndicator
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		self:RegisterEvent('GROUP_ROSTER_UPDATE', Path, true)

		local profileReference = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName]
		element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], profileReference.Size, 'OUTLINE')
		element:SetText(' ')
		element:SetJustifyH('CENTER')
		element:SetTextColor(1,190/255,25/255)
		element:ClearAllPoints()
		element:SetPoint(
			profileReference.Position.AnchorFrom,
			RUF.GetIndicatorAnchorFrame(self,self.frame,elementName),
			profileReference.Position.AnchorTo,
			profileReference.Position.x,
			profileReference.Position.y
		)


		element:Show()
		return true
	end
end

local function Disable(self)
	local element = self.LootMasterIndicator
	if(element) then
		element:Hide()

		self:UnregisterEvent('GROUP_ROSTER_UPDATE', Path)
	end
end

oUF:AddElement('LootMasterIndicator', Path, Enable, Disable)


function RUF.Indicators.LootMaster(self, unit)
	if unit == 'boss' or unit == 'arena' then return end

	local element = self.Indicators:CreateFontString(self:GetName()..'.LootMasterIndicator', 'OVERLAY')
	element:SetPoint(
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorFrom,
		RUF.GetIndicatorAnchorFrame(self,unit,elementName),
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorTo,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.x,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.y
	)

	element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[unit].Frame.Indicators[elementName].Size, 'OUTLINE')

	self.LootMasterIndicator = element
end