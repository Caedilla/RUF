local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local elementName = 'MainTankAssist'
local elementStringMAINASSIST = RUF.IndicatorGlyphs['MainAssist']
local elementStringMAINTANK = RUF.IndicatorGlyphs['MainTank']


local function Update(self, event)
	local element = self.MainTankAssistIndicator
	element.Enabled = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName].Enabled

	if(element.PreUpdate) then
		element:PreUpdate()
	end
	if element.Enabled == true then
		local role, isShown
		local unit = self.unit
		if(UnitInRaid(unit) and not UnitHasVehicleUI(unit)) then
			if(GetPartyAssignment('MAINTANK', unit)) then
				isShown = true
				element:SetText(elementStringMAINTANK)
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(1,190/255,25/255)
				role = 'MAINTANK'
			elseif(GetPartyAssignment('MAINASSIST', unit)) then
				isShown = true
				element:SetText(elementStringMAINASSIST)
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(1,190/255,25/255)
				role = 'MAINASSIST'
			end
		end
		if not isShown then
			element:SetText(' ')
			element:SetWidth(1)
		end
		element:SetShown(isShown)
		if RUF.db.global.TestMode == true then
			if element:IsObjectType('Texture') then
				element:SetTexture(MAINASSIST_ICON)
				element:Show()
			elseif element:IsObjectType('FontString') then
				element:SetText(elementStringMAINASSIST)
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(1,190/255,25/255)
			end
		end
	else
		self:DisableElement('MainTankAssistIndicator')
		element:Hide()
	end

	if(element.PostUpdate) then
		return element:PostUpdate(role)
	end
end

local function Path(self, ...)
	return (self.MainTankAssistIndicator.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self)
	local element = self.MainTankAssistIndicator
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
	local element = self.MainTankAssistIndicator
	if(element) then
		element:Hide()
		self:UnregisterEvent('GROUP_ROSTER_UPDATE', Path)
	end
end

oUF:AddElement('MainTankAssistIndicator', Path, Enable, Disable)


function RUF.Indicators.MainTankAssist(self, unit)
	if unit == 'pet' or unit == 'boss' or unit == 'arena' then return end

	local element = self.Indicators:CreateFontString(self:GetName()..'.MainTankAssistIndicator', 'OVERLAY')
	element:SetPoint(
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorFrom,
		RUF.GetIndicatorAnchorFrame(self,unit,elementName),
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorTo,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.x,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.y
	)

	element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[unit].Frame.Indicators[elementName].Size, 'OUTLINE')

	self.MainTankAssistIndicator = element
end
