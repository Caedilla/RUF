local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local elementName = 'Phased'
local elementString = RUF.IndicatorGlyphs['Phased']

local function Update(self, event)
	local element = self.PhasedIndicator
	element.Enabled = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName].Enabled

	if(element.PreUpdate) then
		element:PreUpdate()
	end
	if element.Enabled == true then
		self:EnableElement(elementName..'Indicator')

		local isInSamePhase
		if RUF.IsRetail() then
			if UnitPlayerOrPetInParty(self.unit) or UnitInRaid(self.unit) then
				if UnitPhaseReason(self.unit) then
					isInSamePhase = false
				else
					isInSamePhase = true
				end
			else
				isInSamePhase = true
			end
		else
			isInSamePhase = UnitInPhase(self.unit)
		end

		if element:IsObjectType('FontString') then
			if(isInSamePhase) then
				element:SetText(' ')
				element:SetWidth(1)
				element:Hide()
			else
				element:SetText(elementString)
				element:SetWidth(element:GetStringWidth()+2)
				element:Show()
			end
		else
			if(isInSamePhase) then
				element:Hide()
			else
				element:Show()
			end
		end
		if RUF.db.global.TestMode == true then
			element:SetText(elementString)
			element:SetWidth(element:GetStringWidth()+2)
			element:Show()
		end
	else
		self:DisableElement('PhasedIndicator')
		element:Hide()
	end

	if(element.PostUpdate) then
		return element:PostUpdate()
	end
end

local function Path(self, ...)
	return (self.PhasedIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self)
	local element = self.PhasedIndicator
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		self:RegisterEvent('UNIT_PHASE', Path, true)
		-- CHECK OTHER EVENTS THAT FIRE WHEN TOGGLING WARMODE

		local profileReference = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName]
		element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], profileReference.Size, 'OUTLINE')
		element:SetText(' ')
		element:SetJustifyH('CENTER')
		element:SetTextColor(96/255,167/255,191/255)
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
	local element = self.PhasedIndicator
	if(element) then
		element:Hide()

		self:UnregisterEvent('UNIT_PHASE', Path)
	end
end

oUF:AddElement('PhasedIndicator', Path, Enable, Disable)


function RUF.Indicators.Phased(self, unit)
	if unit == 'player' or unit == 'pet' then return end

	local element = self.Indicators:CreateFontString(self:GetName()..'.PhasedIndicator', 'OVERLAY')
	element:SetPoint(
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorFrom,
		RUF.GetIndicatorAnchorFrame(self,unit,elementName),
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorTo,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.x,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.y
	)

	element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[unit].Frame.Indicators[elementName].Size, 'OUTLINE')

	self.PhasedIndicator = element
end
