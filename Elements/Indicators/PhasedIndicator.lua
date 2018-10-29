local _, ns = ...
local oUF = ns.oUF
local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")

local function Update(self, event)
	local element = self.PhasedIndicator

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local isInSamePhase = UnitInPhase(self.unit)
	if element:IsObjectType('FontString') then
		if(isInSamePhase) then
			element:SetText(" ")
			element:SetWidth(1)
			element:Hide()
		else
			element:SetText("")
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
		if element:IsObjectType('Texture') then
			element:Show()
		elseif element:IsObjectType('FontString') then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:Show()
		end
	end

	if(element.PostUpdate) then
		return element:PostUpdate(isInSamePhase)
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

		if(element:IsObjectType('Texture') and not element:GetTexture()) then
			element:SetTexture([[Interface\TargetingFrame\UI-PhasingIcon]])
		end
		if element:IsObjectType('FontString') then
			element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[self.frame].Frame.Indicators["Phased"].Size, "OUTLINE")
			element:SetText(" ")
			element:SetWidth(1)
			element:SetJustifyH("CENTER")
			element:SetTextColor(96/255,167/255,191/255)
		end

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
