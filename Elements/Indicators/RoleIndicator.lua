local _, ns = ...
local oUF = ns.oUF
local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")

local function Update(self, event)
	local element = self.RoleIndicator

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local role = UnitGroupRolesAssigned(self.unit)
	if(role == 'TANK' or role == 'HEALER' or role == 'DAMAGER') and element:IsObjectType('Texture') then
		element:SetTexCoord(GetTexCoordsForRoleSmallCircle(role))
		element:Show()
	else
		element:Hide()
	end

	if element:IsObjectType('FontString') then
		if role == "TANK" then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(115/255,142/255,153/255)
			element:Show()
		elseif role == "HEALER" then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(38/255,190/255,65/255)
			element:Show()
		elseif role == "DAMAGER" then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(207/255,55/255,77/255)
			element:Show()
		else
			element:SetText(" ")
			element:SetWidth(1)
			element:Hide()
		end
	end

	if RUF.db.global.TestMode == true then
		if element:IsObjectType('Texture') then
			element:SetTexCoord(GetTexCoordsForRoleSmallCircle("HEALER"))
		end
		if element:IsObjectType('FontString') then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(38/255,190/255,65/255)
		end
		element:Show()
	end

	if(element.PostUpdate) then
		return element:PostUpdate(role)
	end
end

local function Path(self, ...)
	return (self.RoleIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self)
	local element = self.RoleIndicator
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		if(self.unit == 'player') then
			self:RegisterEvent('PLAYER_ROLES_ASSIGNED', Path, true)
		else
			self:RegisterEvent('GROUP_ROSTER_UPDATE', Path, true)
		end

		if(element:IsObjectType('Texture') and not element:GetTexture()) then
			element:SetTexture([[Interface\LFGFrame\UI-LFG-ICON-PORTRAITROLES]])
		end
		if element:IsObjectType('FontString') then
			element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[self.frame].Frame.Indicators["Role"].Size, "OUTLINE")
			element:SetText(" ")
			element:SetJustifyH("CENTER")
			element:SetWidth(1)
		end

		return true
	end
end

local function Disable(self)
	local element = self.RoleIndicator
	if(element) then
		element:Hide()

		self:UnregisterEvent('PLAYER_ROLES_ASSIGNED', Path)
		self:UnregisterEvent('GROUP_ROSTER_UPDATE', Path)
	end
end

oUF:AddElement('RoleIndicator', Path, Enable, Disable)
