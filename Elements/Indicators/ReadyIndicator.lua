local _, ns = ...
local oUF = ns.oUF
local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")

local function OnFinished(self)
	local element = self:GetParent()
	element:Hide()

	if(element.PostUpdateFadeOut) then
		element:PostUpdateFadeOut()
	end
end

local function Update(self, event)
	local element = self.ReadyIndicator

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local unit = self.unit
	local status = GetReadyCheckStatus(unit)
	if(UnitExists(unit) and status and element:IsObjectType('Texture')) then
		if(status == 'ready') then
			element:SetTexture(element.readyTexture)
		elseif(status == 'notready') then
			element:SetTexture(element.notReadyTexture)
		else
			element:SetTexture(element.waitingTexture)
		end

		element.status = status
		element:Show()
	elseif(event ~= 'READY_CHECK_FINISHED') then
		element.status = nil
		element:Hide()
	end
	if(event == 'READY_CHECK_FINISHED') then
		if(element.status == 'waiting' and element:IsObjectType('Texture')) then
			element:SetTexture(element.notReadyTexture)
		end
		element.Animation:Play()
	end

	if(UnitExists(unit) and status and element:IsObjectType('FontString')) then
		if(status == 'ready') then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(46/255,255/255,0)
		elseif(status == 'notready') then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(1,0,55/255)
		else
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(1,216/255,0)
		end
		element.status = status
		element:Show()
	elseif(event ~= 'READY_CHECK_FINISHED') then
		element.status = nil
		element:SetText(" ")
		element:SetWidth(1)
		element:Hide()
	end
	if(event == 'READY_CHECK_FINISHED') then
		if(element.status == 'waiting' and element:IsObjectType('FontString')) then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(1,0,55/255)
		end
		element.Animation:Play()
	end

	if RUF.db.global.TestMode == true then
		if element:IsObjectType('Texture') then
			element.status = "ready"
			element:SetTexture(READY_CHECK_READY_TEXTURE)
			element:Show()
		elseif element:IsObjectType('FontString') then
			element:SetText("")
			element:SetWidth(element:GetStringWidth()+2)
			element:SetTextColor(46/255,255/255,0)
		end
	end

	if(element.PostUpdate) then
		return element:PostUpdate(status)
	end
end

local function Path(self, ...)
	return (self.ReadyIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self, unit)
	local element = self.ReadyIndicator
	--if(element and (unit and (unit:sub(1, 5) == 'party' or unit:sub(1,4) == 'raid'))) then
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		element.readyTexture = element.readyTexture or READY_CHECK_READY_TEXTURE
		element.notReadyTexture = element.notReadyTexture or READY_CHECK_NOT_READY_TEXTURE
		element.waitingTexture = element.waitingTexture or READY_CHECK_WAITING_TEXTURE

		local AnimationGroup = element:CreateAnimationGroup()
		AnimationGroup:HookScript('OnFinished', OnFinished)
		element.Animation = AnimationGroup

		local Animation = AnimationGroup:CreateAnimation('Alpha')
		Animation:SetFromAlpha(1)
		Animation:SetToAlpha(0)
		Animation:SetDuration(element.fadeTime or 1.5)
		Animation:SetStartDelay(element.finishedTime or 10)

		self:RegisterEvent('READY_CHECK', Path, true)
		self:RegisterEvent('READY_CHECK_CONFIRM', Path, true)
		self:RegisterEvent('READY_CHECK_FINISHED', Path, true)

		if element:IsObjectType('FontString') then
			element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[self.unit].Frame.Indicators["Ready"].Size, "OUTLINE")
			element:SetText(" ")
			element:SetWidth(1)
			element:SetJustifyH("CENTER")
		end

		return true
	end
end

local function Disable(self)
	local element = self.ReadyIndicator
	if(element) then
		element:Hide()

		self:UnregisterEvent('READY_CHECK', Path)
		self:UnregisterEvent('READY_CHECK_CONFIRM', Path)
		self:UnregisterEvent('READY_CHECK_FINISHED', Path)
	end
end

oUF:AddElement('ReadyIndicator', Path, Enable, Disable)
