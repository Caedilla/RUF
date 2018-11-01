local _, ns = ...
local oUF = ns.oUF
local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")

local function Update(self, event, unit)
	if(unit ~= self.unit) then return end

	local element = self.ObjectiveIndicator

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local isQuestBoss = UnitIsQuestBoss(unit)
	if element:IsObjectType('FontString') then
		if(isQuestBoss) then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:Show()
		else
			element:SetText(" ")
			element:SetWidth(1)
			element:Hide()
		end
	else
		if(isQuestBoss) then
			element:Show()
		else
			element:Hide()
		end
	end
	if RUF.db.global.TestMode == true then
		if element:IsObjectType('Texture') then
			element:Show()
		elseif element:IsObjectType('FontString') then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:Show()
		end
	end

	if(element.PostUpdate) then
		return element:PostUpdate(isQuestBoss)
	end
end

local function Path(self, ...)
	return (self.ObjectiveIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	local element = self.ObjectiveIndicator
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_CLASSIFICATION_CHANGED', Path)

		if(element:IsObjectType('Texture') and not element:GetTexture()) then
			element:SetTexture([[Interface\TargetingFrame\PortraitQuestBadge]])
		end
		if element:IsObjectType('FontString') then
			element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[self.frame].Frame.Indicators["Objective"].Size, "OUTLINE")
			element:SetText(" ")
			element:SetWidth(1)
			element:SetJustifyH("CENTER")
			element:SetTextColor(1,190/255,25/255)
		end

		return true
	end
end

local function Disable(self)
	local element = self.ObjectiveIndicator
	if(element) then
		element:Hide()

		self:UnregisterEvent('UNIT_CLASSIFICATION_CHANGED', Path)
	end
end

oUF:AddElement('ObjectiveIndicator', Path, Enable, Disable)
