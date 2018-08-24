local _, ns = ...
local oUF = ns.oUF
local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")

local function Update(self, event)
	local element = self.RestIndicator

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local isResting = IsResting()
	if element:IsObjectType('FontString') then
		if(isResting) then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:Show()
		else
			element:SetText(" ")
			element:Hide()
		end
	else
		if(isResting) then
			element:Show()
		else
			element:Hide()
		end
	end
	if RUF.db.global.TestMode == true then
		if element:IsObjectType('Texture') then
			element:Show()
		elseif element:IsObjectType('FontString') then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:Show()
		end
	end

	if(element.PostUpdate) then
		return element:PostUpdate(isResting)
	end
end

local function Path(self, ...)
	return (self.RestIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self, unit)
	local element = self.RestIndicator
	if(element and unit == 'player') then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('PLAYER_UPDATE_RESTING', Path, true)

		if(element:IsObjectType('Texture') and not element:GetTexture()) then
			element:SetTexture([[Interface\CharacterFrame\UI-StateIcon]])
			element:SetTexCoord(0, 0.5, 0, 0.421875)
		end
		if element:IsObjectType('FontString') then
			element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[self.unit].Frame.Indicators["Rest"].Size, "OUTLINE")
			element:SetText(" ")
			element:SetJustifyH("CENTER")
			element:SetTextColor(242/255,230/255,153/255)
		end

		return true
	end
end

local function Disable(self)
	local element = self.RestIndicator
	if(element) then
		element:Hide()

		self:UnregisterEvent('PLAYER_UPDATE_RESTING', Path)
	end
end

oUF:AddElement('RestIndicator', Path, Enable, Disable)
