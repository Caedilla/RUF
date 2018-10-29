local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF


function RUF.HealthPreUpdate(element, unit)
	-- TODO:
	-- None, fine for now.
	RUF:FrameAttributes(element.__owner)
	element.__owner.Health.colorClass = RUF.db.profile.Appearance.Bars.Health.Color.Class
	element.__owner.Health.colorDisconnected = RUF.db.profile.Appearance.Bars.Health.Color.Disconnected
	element.__owner.Health.colorSmooth = RUF.db.profile.Appearance.Bars.Health.Color.Percentage
	element.__owner.Health.smoothGradient = RUF.db.profile.Appearance.Bars.Health.Color.PercentageGradient
	element.__owner.Health.colorReaction = RUF.db.profile.Appearance.Bars.Health.Color.Reaction
	element.__owner.Health.colorTapping = RUF.db.profile.Appearance.Bars.Health.Color.Tapped
	element.__owner.Health.colorHealth = true
	element.__owner.Health.Smooth = RUF.db.profile.Appearance.Bars.Health.Animate
end

function RUF.HealthPostUpdate(element, unit, cur, max)
	-- TODO:
	-- None, fine for now.
	local r,g,b = unpack(RUF.db.profile.Appearance.Bars.Health.Background.CustomColor)
	local Multiplier = 1
	if RUF.db.profile.Appearance.Bars.Health.Background.UseBarColor then 
		r,g,b = _G[element.__owner:GetName() .. ".Health.Bar"]:GetStatusBarColor()
		Multiplier = RUF.db.profile.Appearance.Bars.Health.Background.Multiplier
	end
	_G[element.__owner:GetName() .. ".Health.Background"]:SetVertexColor(r*Multiplier,g*Multiplier,b*Multiplier,RUF.db.profile.Appearance.Bars.Health.Background.Alpha)
	if RUF.db.profile.Appearance.Bars.Health.Color.Reaction then
		if UnitPlayerControlled(unit) and not UnitCanAttack(unit,"player") and not UnitIsPlayer(unit) then  -- If the unit is an allied pet then show as blue.
			local r,g,b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[10])
			_G[element.__owner:GetName() .. ".Health.Bar"]:SetStatusBarColor(r,g,b)		
		end
	end
end

function RUF.SetHealth(self, unit)
	-- TODO:
	-- None, fine for now.

	local Texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Health.Texture)	
	local Name = self:GetName()
	local Bar = CreateFrame("StatusBar",Name..".Health.Bar",self)
	local BGParent = CreateFrame("Frame",Name..".Health.BGParent",Bar)
	local Background = BGParent:CreateTexture(Name..".Health.Background","BACKGROUND")	

	BGParent:SetAllPoints(self)
	BGParent:SetFrameStrata("BACKGROUND")
	
	-- Bar
	Bar.colorClass = RUF.db.profile.Appearance.Bars.Health.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Health.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Health.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Health.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Health.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Health.Color.Tapped
	Bar.colorHealth = true -- BaseColor, always enabled, so if none of the other colors match, it falls back to this.
	Bar.Smooth = RUF.db.profile.Appearance.Bars.Health.Animate
	Bar:SetStatusBarTexture(Texture)
	Bar:SetAllPoints(self)
	Bar:SetFrameLevel(2)
	Bar:SetFillStyle(RUF.db.profile.unit[self.frame].Frame.Bars.Health.Fill)
	
	-- Background
	local r,g,b = unpack(RUF.db.profile.Appearance.Bars.Health.Background.CustomColor)
	local Multiplier = RUF.db.profile.Appearance.Bars.Health.Background.Multiplier
	Background:SetTexture(LSM:Fetch("background", "Solid"))
	Background:SetVertexColor(r*Multiplier,g*Multiplier,b*Multiplier,RUF.db.profile.Appearance.Bars.Health.Background.Alpha)
	Background:SetAllPoints(Bar)

	-- Register with oUF
	self.Health = Bar
	self.Health.Background = Background
end
