local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF
local _, PlayerClass = UnitClass('player')


function RUF.ClassPostUpdate(element, cur, max, hasMaxChanged, powerType)
	if not _G[element.__owner:GetName() .. ".Class"]:IsShown() then return end
	local r,g,b = RUF:GetClassColor("player")
	local UnitPowerMaxAmount = UnitPowerMax("player", RUF.db.char.ClassPowerID)			
	local Multiplier = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	local BarMult = RUF.db.profile.Appearance.Bars.Class.Color.Multiplier
	local Texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Class.Texture)
	local br,bg,bb	

	for index = 1,UnitPowerMaxAmount do
		local ir = r - (r*(((-index + UnitPowerMaxAmount)*BarMult)/100))
		local ig = g - (g*(((-index + UnitPowerMaxAmount)*BarMult)/100))
		local ib = b - (b*(((-index + UnitPowerMaxAmount)*BarMult)/100))
		if RUF.db.profile.Appearance.Bars.Class.Background.UseBarColor == false then 
			br,bg,bb = unpack(RUF.db.profile.Appearance.Bars.Class.Background.CustomColor)
		else
			br,bg,bb = r,g,b
		end
		if PlayerClass == "DEATHKNIGHT" then
			element.__owner.Runes[index]:SetStatusBarTexture(Texture)
			element.__owner.Runes[index]:SetStatusBarColor(ir,ig,ib)
			element.__owner.Runes.bg[index]:SetVertexColor(br*Multiplier,bg*Multiplier,bb*Multiplier,RUF.db.profile.Appearance.Bars.Class.Background.Alpha)
		else
			element.__owner.ClassPower[index]:SetStatusBarTexture(Texture)
			element.__owner.ClassPower[index]:SetStatusBarColor(ir,ig,ib)
			element.__owner.ClassPower.bg[index]:SetVertexColor(br*Multiplier,bg*Multiplier,bb*Multiplier,RUF.db.profile.Appearance.Bars.Class.Background.Alpha)
		end
	end
end

function RUF.UpdateClassBar(self, event)
	if (RUF.db.char.ClassPowerID) then -- If we're a class that should show a class bar
		if UnitHasVehicleUI('player') then
			if self.Class:IsVisible() == true then
				RUF:BarVisibility(self, "Class", false)
				return
			else
				return
			end
        end
		if RUF.db.profile.unit.player.Frame.Bars.Class.Enabled == false then
			if self.Class:IsVisible() == true then
				RUF:BarVisibility(self, "Class", false)
			else
				return
			end
		elseif(not RUF.db.char.RequireSpec or RUF.db.char.RequireSpec == GetSpecialization()) then -- If the class requires a specific spec, and if so, if we are that spec.
			if(not RUF.db.char.RequireSpell or IsPlayerSpell(RUF.db.char.RequireSpell)) then -- If the class requires a specific spell, druid cat form.
				if PlayerClass == "MONK" then
					local UnitPowerMaxAmount = UnitPowerMax("player", RUF.db.char.ClassPowerID)
					local GroupParent = self:GetName() .. ".Class"
					if UnitPowerMaxAmount == 5 then
						for i = 1,5 do
							local FrameParent = _G["oUF_RUF_Player.Class"..i..".Parent"]
							local Size = (RUF.db.profile.unit["player"].Frame.Size.Width + (UnitPowerMaxAmount-1)) / UnitPowerMaxAmount
							
							-- Set Bar Parent Size
							FrameParent:SetWidth(Size)
							FrameParent:SetHeight(RUF.db.profile.unit["player"].Frame.Bars.Class.Height)
							FrameParent:SetPoint('TOPLEFT', GroupParent, 'TOPLEFT', ((i - 1) * Size - ((i - 1 ) * 1)), 0)
						end
					_G["oUF_RUF_Player.Class6.Parent"]:Hide()
					elseif UnitPowerMaxAmount == 6 then
						for i = 1,6 do
							local FrameParent = _G["oUF_RUF_Player.Class"..i..".Parent"]
							local Size = (RUF.db.profile.unit["player"].Frame.Size.Width + (UnitPowerMaxAmount-1)) / UnitPowerMaxAmount
							
							-- Set Bar Parent Size
							FrameParent:SetWidth(Size)
							FrameParent:SetHeight(RUF.db.profile.unit["player"].Frame.Bars.Class.Height)
							FrameParent:SetPoint('TOPLEFT', GroupParent, 'TOPLEFT', ((i - 1) * Size - ((i - 1 ) * 1)), 0)
						end
					_G["oUF_RUF_Player.Class6.Parent"]:Show()
					end
				end
				if self.Class:IsVisible() == false then
					RUF:BarVisibility(self, "Class", true)
				else
					return
				end
			else
				if self.Class:IsVisible() == true then
					RUF:BarVisibility(self, "Class", false)
				else
					return
				end
			end
		else
			if self.Class:IsVisible() == true then
				RUF:BarVisibility(self, "Class", false)
			else
				return
			end
		end
	else
		if self.Class:IsVisible() == true then
			RUF:BarVisibility(self, "Class", false)
		else
			return
		end
	end


	local FrameIndex = RUF:UnitToIndex(unit)
	RUF:UpdateHealthBackground(FrameIndex)
end

function RUF.SetClassBar(self, unit)
	-- TODO set Class Bar as alternate Power bar for Feral, Guardian, and Restoraion Druids.

	local ClassPowerBar = {}
	local ClassPowerBorder = {}
	local ClassPowerBG = {}
	if not RUF.db.char.ClassPowerID then return end
	local Name = self:GetName() .. ".Class"
	local UnitPowerMaxAmount = UnitPowerMax(unit, RUF.db.char.ClassPowerID)
	if RUF.db.char.ClassPowerID == 12 then
		UnitPowerMaxAmount = 6
		-- TODO: Check talent for additional bar. Hide and resize. Do same check for others.
	end

	local GroupParent = CreateFrame("Frame",Name,self)
	GroupParent:SetPoint("LEFT",self,0,0)
	GroupParent:SetPoint("RIGHT",self,0,0)
	GroupParent:SetPoint("TOP",self,0,0)
	GroupParent:SetPoint("BOTTOM",self,0,0)

	local Texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Class.Texture)
	local r,g,b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[RUF.db.char.ClassPowerID])
	if PlayerClass == "DEATHKNIGHT" then
		local spec = GetSpecialization()
		if spec == 1 then --Blood
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[50])
		elseif spec == 2 then -- Frost
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[51])
		elseif spec == 3 then -- Unholy
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[52])
		else
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[RUF.db.char.ClassPowerID])
		end
	end
	local Multiplier = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	local Constant = RUF.db.profile.Appearance.Bars.Class.Color.Multiplier	
	
	for i = 1,UnitPowerMaxAmount do
		local FrameParent = CreateFrame("Frame",Name..i..".Parent",GroupParent)
		local Border = CreateFrame("Frame",Name..i..".Border",FrameParent)
		local Background = FrameParent:CreateTexture(Name..i..".Background","BACKGROUND")
		local Bar = CreateFrame("StatusBar",Name..i..".Bar",FrameParent)
		local Size = (RUF.db.profile.unit[unit].Frame.Size.Width + (UnitPowerMaxAmount-1)) / UnitPowerMaxAmount
		local Counter = i
		if UnitPowerMaxAmount == 4 then
			Counter = i +1
		end
		
		-- Set Bar Parent Size
		FrameParent:SetWidth(Size)
		FrameParent:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
		FrameParent:SetPoint('TOPLEFT', GroupParent, 'TOPLEFT', ((i - 1) * Size - ((i - 1 ) * 1)), 0)
		FrameParent:SetFrameLevel(5)
		
		-- Set Status Bar
		Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Class.Fill)
		Bar:SetAllPoints(FrameParent)
		Bar:SetFrameLevel(6)		
		Bar:SetStatusBarTexture(Texture)
		local ir = (r*((((Counter+Constant)*6.6667)/100)))
		local ig = (g*((((Counter+Constant)*6.6667)/100)))
		local ib = (b*((((Counter+Constant)*6.6667)/100)))
		Bar:SetStatusBarColor(ir,ig,ib)
		
		-- Set Border
		Border:SetAllPoints(FrameParent)
		Border:SetFrameLevel(7)
		Border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeSize})
		local borderr,borderg,borderb = unpack(RUF.db.profile.Appearance.Bars.Class.Border.Color)
		Border:SetBackdropBorderColor(borderr,borderg,borderb, RUF.db.profile.Appearance.Bars.Class.Border.Alpha)
		
		-- Set Background
		Background:SetAllPoints(FrameParent)		
		Background:SetTexture(LSM:Fetch("background", "Solid"))
		Background:SetVertexColor(r*Multiplier,g*Multiplier,b*Multiplier,RUF.db.profile.Appearance.Bars.Class.Background.Alpha)

		ClassPowerBar[i] = Bar
		ClassPowerBorder[i] = Border
		ClassPowerBG[i] = Background		
	end
	
	-- Register with oUF
	if PlayerClass == "DEATHKNIGHT" then
		self.Class = GroupParent
		self.Runes = ClassPowerBar
		self.Runes.border = ClassPowerBorder	
		self.Runes.bg = ClassPowerBG
		self:RegisterEvent('ACTIONBAR_UPDATE_STATE',RUF.UpdateClassBar)
		self:RegisterEvent('UNIT_POWER_UPDATE',RUF.UpdateClassBar)
		self:RegisterEvent('UNIT_DISPLAYPOWER',RUF.UpdateClassBar)
		self:RegisterEvent('PLAYER_ENTERING_WORLD',RUF.UpdateClassBar)
		self:RegisterEvent('UNIT_ENTERED_VEHICLE', RUF.UpdateClassBar)
		self:RegisterEvent('UNIT_EXITED_VEHICLE', RUF.UpdateClassBar)
		self:RegisterEvent('UNIT_EXITING_VEHICLE', RUF.UpdateClassBar)
	else
		self.Class = GroupParent
		self.ClassPower = ClassPowerBar
		self.ClassPower.border = ClassPowerBorder	
		self.ClassPower.bg = ClassPowerBG
		--self:RegisterEvent('PLAYER_TALENT_UPDATE',RUF.UpdateClassBar)
		self:RegisterEvent('UNIT_POWER_UPDATE',RUF.UpdateClassBar)
		self:RegisterEvent('UNIT_DISPLAYPOWER',RUF.UpdateClassBar)
		self:RegisterEvent('PLAYER_ENTERING_WORLD',RUF.UpdateClassBar)
		self:RegisterEvent('UNIT_ENTERED_VEHICLE', RUF.UpdateClassBar)
		self:RegisterEvent('UNIT_EXITED_VEHICLE', RUF.UpdateClassBar)
		self:RegisterEvent('UNIT_EXITING_VEHICLE', RUF.UpdateClassBar)
	end
	RUF.UpdateClassBar(self)
end
