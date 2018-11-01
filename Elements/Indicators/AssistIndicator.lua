local _, ns = ...
local oUF = ns.oUF
local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")

local function Update(self, event)
	local element = self.AssistIndicator

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local unit = self.unit
	local isAssistant = UnitInRaid(unit) and UnitIsGroupAssistant(unit) and not UnitIsGroupLeader(unit)
	if element:IsObjectType('FontString') then
		if(isAssistant) then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:Show()
		else
			element:Hide()
			element:SetText(" ")
			element:SetWidth(1)
		end
		if(isAssistant) then
			element:Show()
		else
			element:Hide()
		end
	end
	if RUF.db.global.TestMode == true then
		if element:IsObjectType('Texture') then
			element:Show()
		elseif element:IsObjectType('FontString') then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:Show()
		end
	end

	if(element.PostUpdate) then
		return element:PostUpdate(isAssistant)
	end
end

local function Path(self, ...)
	return (self.AssistIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self)
	local element = self.AssistIndicator
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('GROUP_ROSTER_UPDATE', Path, true)

		if(element:IsObjectType('Texture') and not element:GetTexture()) then
			element:SetTexture([[Interface\GroupFrame\UI-Group-AssistantIcon]])
		end
		if element:IsObjectType('FontString') then
			element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[self.frame].Frame.Indicators["Assist"].Size, "OUTLINE")
			element:SetText(" ")
			element:SetJustifyH("CENTER")
			element:SetTextColor(191/255,178/255,143/255)
		end

		return true
	end
end

local function Disable(self)
	local element = self.AssistIndicator
	if(element) then
		element:Hide()

		self:UnregisterEvent('GROUP_ROSTER_UPDATE', Path)
	end
end

oUF:AddElement('AssistIndicator', Path, Enable, Disable)
