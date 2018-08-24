local _, ns = ...
local oUF = ns.oUF
local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")

local function Update(self, event)
	local element = self.LeadIndicator

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local unit = self.unit
	local isLeader = (UnitInParty(unit) or UnitInRaid(unit)) and UnitIsGroupLeader(unit)
	if element:IsObjectType('FontString') then
		if(isLeader) then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:Show()
		else
			element:SetText(" ")
			element:SetWidth(1)
			element:Hide()
		end
	else
		if(isLeader) then
			element:Show()
		else
			element:Hide()
		end
	end
	if RUF.db.global.TestMode == true then
		if element:IsObjectType('Texture') then
			element:Show()
		elseif element:IsObjectType('FontString') then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:Show()
		end
	end

	if(element.PostUpdate) then
		return element:PostUpdate(isLeader)
	end
end

local function Path(self, ...)
	return (self.LeadIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self)
	local element = self.LeadIndicator
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('PARTY_LEADER_CHANGED', Path, true)
		self:RegisterEvent('GROUP_ROSTER_UPDATE', Path, true)

		if(element:IsObjectType('Texture') and not element:GetTexture()) then
			element:SetTexture([[Interface\GroupFrame\UI-Group-LeaderIcon]])
		end
		if element:IsObjectType('FontString') then
			element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[self.unit].Frame.Indicators["Lead"].Size, "OUTLINE")
			element:SetText(" ")
			element:SetWidth(1)
			element:SetJustifyH("CENTER")
			element:SetTextColor(1,190/255,25/255)
		end

		return true
	end
end

local function Disable(self)
	local element = self.LeadIndicator
	if(element) then
		element:Hide()

		self:UnregisterEvent('PARTY_LEADER_CHANGED', Path)
		self:UnregisterEvent('GROUP_ROSTER_UPDATE', Path)
	end
end

oUF:AddElement('LeadIndicator', Path, Enable, Disable)
