local _, ns = ...
local oUF = ns.oUF
local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")

local MAINTANK_ICON = [[Interface\GROUPFRAME\UI-GROUP-MAINTANKICON]]
local MAINASSIST_ICON = [[Interface\GROUPFRAME\UI-GROUP-MAINASSISTICON]]

local function Update(self, event)
	local unit = self.unit

	local element = self.MainTankAssistIndicator

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local role, isShown
	if element:IsObjectType('Texture') then
		if(UnitInRaid(unit) and not UnitHasVehicleUI(unit)) then
			if(GetPartyAssignment('MAINTANK', unit)) then
				isShown = true
				element:SetTexture(MAINTANK_ICON)
				role = 'MAINTANK'
			elseif(GetPartyAssignment('MAINASSIST', unit)) then
				isShown = true
				element:SetTexture(MAINASSIST_ICON)
				role = 'MAINASSIST'
			end
		end
	end
	if element:IsObjectType('FontString') then
		if(UnitInRaid(unit) and not UnitHasVehicleUI(unit)) then
			if(GetPartyAssignment('MAINTANK', unit)) then
				isShown = true
				element:SetText("")
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(1,190/255,25/255)
				role = 'MAINTANK'
			elseif(GetPartyAssignment('MAINASSIST', unit)) then
				isShown = true
				element:SetText("")
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(1,190/255,25/255)
				role = 'MAINASSIST'
			end
		end
		if not isShown then
			element:SetText(" ")
			element:SetWidth(1)
		end
	end

	element:SetShown(isShown)


	if RUF.db.global.TestMode == true then
		if element:IsObjectType('Texture') then
			element:SetTexture(MAINASSIST_ICON)
			element:Show()
		elseif element:IsObjectType('FontString') then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(1,190/255,25/255)
		end
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
		if element:IsObjectType('FontString') then
			element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[self.frame].Frame.Indicators["MainTankAssist"].Size, "OUTLINE")
			element:SetText(" ")
			element:SetWidth(1)
			element:SetJustifyH("CENTER")
		end

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
