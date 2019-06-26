local _, ns = ...
local oUF = ns.oUF
local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")

local function Update(self, event, unit)
	if(unit ~= self.unit) then return end

	local element = self.PvPCombatIndicator
	if(element.PreUpdate) then
		element:PreUpdate(unit)
	end

	local status
	local factionGroup = UnitFactionGroup(unit)

	if(UnitIsPVPFreeForAll(unit)) then
		status = 'FFA'
	elseif(factionGroup and factionGroup ~= 'Neutral' and UnitIsPVP(unit)) then
		if(unit == 'player' and UnitIsMercenary(unit)) then
			if(factionGroup == 'Horde') then
				factionGroup = 'Alliance'
			elseif(factionGroup == 'Alliance') then
				factionGroup = 'Horde'
			end
		end

		status = factionGroup
	end

	if element:IsObjectType('Texture') then
		if(status) then
			element:Show()
			element:SetTexture([[Interface\TargetingFrame\UI-PVP-]] .. status)
			element:SetTexCoord(0, 0.65625, 0, 0.65625)
		else
			element:Hide()
		end
	end


	if element:IsObjectType('FontString') then
		if status == "FFA" then
			if factionGroup == "Horde" then
				element:SetText("")
			elseif factionGroup == "Alliance" then
				element:SetText("")
			end
			element:Show()
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(1,190/255,25/255)
		elseif status == "Horde" then
			element:Show()
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(1,0/255,25/255)
		elseif status == "Alliance" then
			element:Show()
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(0,158/255,1)
		else
			element:SetText(" ")
			element:SetWidth(1)
			element:Hide()
		end
	end

	if RUF.db.global.TestMode == true then
		if element:IsObjectType('Texture') then
			element:SetTexture([[Interface\TargetingFrame\UI-PVP-]] .. factionGroup)
			element:SetTexCoord(0, 0.65625, 0, 0.65625)
		elseif element:IsObjectType('FontString') then
			if factionGroup == "Horde" then
				element:Show()
				element:SetText("")
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(1,0/255,25/255)
			elseif factionGroup == "Alliance" then
				element:Show()
				element:SetText("")
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(0,158/255,1)
			end
		end
		element:Show()
	end
	
	if(element.PostUpdate) then
		return element:PostUpdate(unit, status)
	end
end

local function Path(self, ...)
	return (self.PvPCombatIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	local element = self.PvPCombatIndicator
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_FACTION', Path)
		--self:RegisterEvent('HONOR_LEVEL_UPDATE', Path)
		if element:IsObjectType('FontString') then
			element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[self.frame].Frame.Indicators["PvPCombat"].Size, "OUTLINE")
			element:SetText(" ")
			element:SetWidth(1)
			element:SetJustifyH("CENTER")
		end

		return true
	end
end

local function Disable(self)
	local element = self.PvPCombatIndicator
	if(element) then
		element:Hide()

		self:UnregisterEvent('UNIT_FACTION', Path)
		--self:UnregisterEvent('HONOR_LEVEL_UPDATE', Path)
	end
end

oUF:AddElement('PvPCombatIndicator', Path, Enable, Disable)
