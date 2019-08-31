local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF

function RUF.SetPowerBar(self, unit) -- Mana, Rage, Insanity, Maelstrom etc.
	local Texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Power.Texture)
	local Bar = CreateFrame("StatusBar",nil,self)
	local Border = CreateFrame("Frame",nil,Bar)
	local Background = Bar:CreateTexture(nil,"BACKGROUND")

	if RUF.db.profile.unit[unit].Frame.Bars.Power.Position.Anchor == 'TOP' then
		Bar:SetPoint('TOP',0,0)
		Bar:SetPoint('LEFT',0,0)
		Bar:SetPoint('RIGHT',0,0)
		Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Power.Height)
		Bar.anchorTo = 'TOP'
	else
		Bar:ClearAllPoints()
		Bar:SetPoint('BOTTOM',0,0)
		Bar:SetPoint('LEFT',0,0)
		Bar:SetPoint('RIGHT',0,0)
		Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Power.Height)
		Bar.anchorTo = 'BOTTOM'
	end

	Bar.Smooth = RUF.db.profile.Appearance.Bars.Power.Animate
	Bar.frequentUpdates = true -- Is there an option for this? CHECK IT.
	Bar.hideAtZero = RUF.db.profile.unit[unit].Frame.Bars.Power.Enabled == 1
	Bar.barHeight = RUF.db.profile.unit[unit].Frame.Bars.Power.Height
	Bar:SetStatusBarTexture(Texture)
	Bar:SetFrameLevel(5)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Power.Fill)

	-- Border
	Border:SetAllPoints(Bar)
	Border:SetFrameLevel(7)
	Border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Bars.Power.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Power.Border.Style.edgeSize})
	local borderr,borderg,borderb = unpack(RUF.db.profile.Appearance.Bars.Power.Border.Color)
	Border:SetBackdropBorderColor(borderr,borderg,borderb, RUF.db.profile.Appearance.Bars.Power.Border.Alpha)

	-- Background
	local r,g,b = unpack(RUF.db.profile.Appearance.Bars.Power.Background.CustomColor)
	local Multiplier = RUF.db.profile.Appearance.Bars.Power.Background.Multiplier
	Background:SetTexture(LSM:Fetch("background", "Solid"))
	Background:SetVertexColor(r*Multiplier,g*Multiplier,b*Multiplier,RUF.db.profile.Appearance.Bars.Power.Background.Alpha)
	Background:SetAllPoints(Bar)
	Background.colorSmooth = false

	-- Register with oUF
	self.Power = Bar
	self.Power.Border = Border
	self.Power.Background = Background

	--self.Background.Power:SetAllPoints(self.Power)

	self.Power.UpdateOptions = RUF.PowerUpdateOptions
end

function RUF.PowerUpdate(self, event, unit)
	if(self.unit ~= unit) then return end
	local element = self.Power

	local disconnected = not UnitIsConnected(unit)
	local tapped = not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)
	local _,pType = UnitPowerType(unit)
	local cur,max,r,g,b,a,bgMult

	element.disconnected = disconnected
	element.tapped = tapped

	-- Update Statusbar colour
	if UnitIsUnit("player",unit) and (self.frame == "player") and (pType == "INSANITY" or pType == "MAELSTROM" or pType == "LUNAR_POWER") then
		cur,max = UnitPower(unit,0), UnitPowerMax(unit,0)
		r,g,b = RUF:GetBarColor(element, unit, "Power", 0)
		element:SetStatusBarColor(r,g,b)
		a = RUF.db.profile.Appearance.Bars.Class.Background.Alpha
		bgMult = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	else
		cur, max = UnitPower(unit), UnitPowerMax(unit)
		r,g,b = RUF:GetBarColor(element, unit, "Power")
		element:SetStatusBarColor(r,g,b)
		a = RUF.db.profile.Appearance.Bars.Power.Background.Alpha
		bgMult = RUF.db.profile.Appearance.Bars.Power.Background.Multiplier
	end

	-- Update background
	if RUF.db.profile.Appearance.Bars.Power.Background.UseBarColor == false then
		r,g,b = unpack(RUF.db.profile.Appearance.Bars.Power.Background.CustomColor)
	end
	element.Background:SetVertexColor(r*bgMult,g*bgMult,b*bgMult,a)

	if RUF.db.global.TestMode == true then
		cur = math.random(25,75)
		max = 100
	end

	-- Set Statusbar Value
	element:SetMinMaxValues(0, max)
	if(disconnected) then
		element:SetValue(max)
	else
		element:SetValue(cur)
	end


	if element.hideAtZero == true and not disconnected then
		if cur < 1 then
			if element:IsVisible() then
				element:Hide()
				--element.__owner.Background.Power:Show()
			end
			RUF:UpdateBarLocation(self,unit,element,cur)
		else
			if not element:IsVisible() then
				element:Show()
				--element.__owner.Background.Power:Hide()
			end
			RUF:UpdateBarLocation(self,unit,element,cur)
		end
	end

	-- TODO Set random value for test mode and random colour, make sure to sync this with tags.
end

function RUF.PowerUpdateOptions(self)
	local unit = self.__owner.frame
	local Bar = self

	local Texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Power.Texture)
	Bar.Smooth = RUF.db.profile.Appearance.Bars.Power.Animate
	Bar.frequentUpdates = true -- Is there an option for this? CHECK IT.
	Bar.hideAtZero = RUF.db.profile.unit[unit].Frame.Bars.Power.Enabled == 1
	Bar.barHeight = RUF.db.profile.unit[unit].Frame.Bars.Power.Height
	Bar:SetStatusBarTexture(Texture)
	Bar:SetFrameLevel(5)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Power.Fill)

	RUF:SetBarLocation(self.__owner,unit)

	self:ForceUpdate() -- Runs Update function for everything else.


end