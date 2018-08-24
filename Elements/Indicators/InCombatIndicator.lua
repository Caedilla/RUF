local _, ns = ...
local oUF = ns.oUF
local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")

local function Update(self, event)
	local element = self.InCombatIndicator

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local inCombat = UnitAffectingCombat(self.unit)
	if element:IsObjectType('FontString') then
		if(inCombat) then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:Show()
		else
			element:SetText(" ")
			element:SetWidth(1)
			element:Hide()
		end
	else
		if(inCombat) then
			element:Show()
		else
			element:Hide()
		end
	end

	if RUF.db.global.TestMode == true then
		if element:IsObjectType('Texture') then
			element:Show()
		elseif element:IsObjectType('FontString') then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:Show()
		end
	end

	if(element.PostUpdate) then
		return element:PostUpdate(inCombat)
	end
end

local function Path(self, ...)
	return (self.InCombatIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self, unit)
	local element = self.InCombatIndicator
	if(element and unit == 'player') then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('PLAYER_REGEN_DISABLED', Path, true)
		self:RegisterEvent('PLAYER_REGEN_ENABLED', Path, true)

		if(element:IsObjectType('Texture') and not element:GetTexture()) then
			element:SetTexture([[Interface\CharacterFrame\UI-StateIcon]])
			element:SetTexCoord(.5, 1, 0, .49)
		end
		if element:IsObjectType('FontString') then
			element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[self.unit].Frame.Indicators["InCombat"].Size, "OUTLINE")
			element:SetText(" ")
			element:SetJustifyH("RIGHT")
			element:SetWidth(1)
			--element:SetTextColor(1,0,55/255) -- Magenta
			element:SetTextColor(195/255,209/255,229/255) -- Blue Silver
		end

		return true
	end
end

local function Disable(self)
	local element = self.InCombatIndicator
	if(element) then
		element:Hide()

		self:UnregisterEvent('PLAYER_REGEN_DISABLED', Path)
		self:UnregisterEvent('PLAYER_REGEN_ENABLED', Path)
	end
end

oUF:AddElement('InCombatIndicator', Path, Enable, Disable)
