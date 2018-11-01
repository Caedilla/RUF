local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF
local _, PlayerClass = UnitClass('player')
local ShouldEnable, pType, UnitSettingsDone


function RUF:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("RUFDB", RUF.Layout.cfg, true) -- Setup Saved Variables
	local LibDualSpec = LibStub('LibDualSpec-1.0')
	LibDualSpec:EnhanceDatabase(self.db, "RUF")
	
	-- Register /RUF command
	self:RegisterChatCommand("RUF", "ChatCommand")

	-- Profile Management
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")

	-- Register Media
	LSM:Register("font", "RUF", [[Interface\Addons\RUF\Media\TGL.ttf]],LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
	LSM:Register("statusbar", "RUF 1", [[Interface\Addons\RUF\Media\Raeli 1.tga]])
	LSM:Register("statusbar", "RUF 2", [[Interface\Addons\RUF\Media\Raeli 2.tga]])
	LSM:Register("statusbar", "RUF 3", [[Interface\Addons\RUF\Media\Raeli 3.tga]])
	LSM:Register("statusbar", "RUF 4", [[Interface\Addons\RUF\Media\Raeli 4.tga]])
	LSM:Register("statusbar", "RUF 5", [[Interface\Addons\RUF\Media\Raeli 5.tga]])
	LSM:Register("statusbar", "RUF 6", [[Interface\Addons\RUF\Media\Raeli 6.tga]])
	LSM:Register("statusbar", "Armory",[[Interface\Addons\RUF\Media\Extra\Armory.tga]])
	LSM:Register("statusbar", "Cabaret 2", [[Interface\Addons\RUF\Media\Extra\Cabaret 2.tga]]) 
	LSM:Register("border","RUF Pixel", [[Interface\ChatFrame\ChatFrameBackground]])
	LSM:Register("border","RUF Glow", [[Interface\Addons\RUF\Media\InternalGlow.tga]])
	LSM:Register("border","RUF Glow Small", [[Interface\Addons\RUF\Media\InternalGlowSmall.tga]])
	LSM:Register("font","Overwatch Oblique",[[Interface\Addons\RUF\Media\Extra\BigNoodleTooOblique.ttf]])
	LSM:Register("font","Overwatch",[[Interface\Addons\RUF\Media\Extra\BigNoodleToo.ttf]])
	LSM:Register("font","Futura",[[Interface\Addons\RUF\Media\Extra\Futura.ttf]])
	LSM:Register("font","Semplicita Light",[[Interface\Addons\RUF\Media\Extra\semplicita.light.otf]])
	LSM:Register("font","Semplicita Light Italic",[[Interface\Addons\RUF\Media\Extra\semplicita.light-italic.otf]])
	LSM:Register("font","Semplicita Medium",[[Interface\Addons\RUF\Media\Extra\semplicita.medium.otf]])
	LSM:Register("font","Semplicita Medium Italic",[[Interface\Addons\RUF\Media\Extra\semplicita.medium-italic.otf]])
	
	RUF.db.global.TestMode = false
	RUF.db.global.Lock = true
	if RUF.db.global.Version then
		if tonumber(RUF.db.global.Version) < 75 then
			RUF.db:ResetDB()
			RUF:PopUp("RUF_Upgrade","RUF |c5500DBBDRaeli's Unit Frames|r has had significant changes since that last version you have installed. \nUnfortunately, I have had to reset all settings. This shouldn't have to happen again in the future.\n\n I apologise for the inconvenience.","Ok, Reload my UI")
			StaticPopup_Show("RUF_Upgrade")
		end
	end

	--project-revision
	RUF.db.global.Version = string.match(GetAddOnMetadata("RUF","Version"),"%d+")


	do -- Register Class Bar Variable Values
		if(PlayerClass == 'MONK') then
			RUF.db.char.ClassPowerID = 12
			RUF.db.char.ClassPowerType = "CHI"
			RUF.db.char.RequireSpec = SPEC_MONK_WINDWALKER
		elseif(PlayerClass == 'PALADIN') then
			RUF.db.char.ClassPowerID = 9
			RUF.db.char.ClassPowerType = "HOLY_POWER"
			RUF.db.char.RequireSpec = SPEC_PALADIN_RETRIBUTION
		elseif(PlayerClass == 'WARLOCK') then
			RUF.db.char.ClassPowerID = 7
			RUF.db.char.ClassPowerType = "SOUL_SHARDS"
		elseif(PlayerClass == 'ROGUE' or PlayerClass == 'DRUID') then
			RUF.db.char.ClassPowerID = 4
			RUF.db.char.ClassPowerType = 'COMBO_POINTS'
			if(PlayerClass == 'DRUID') then
				RUF.db.char.RequireSpell = 5221 -- Shred
			end
		elseif(PlayerClass == 'MAGE') then
			RUF.db.char.ClassPowerID = 16
			RUF.db.char.ClassPowerType = 'ARCANE_CHARGES'
			RUF.db.char.RequireSpec = SPEC_MAGE_ARCANE
		elseif(PlayerClass == 'DEATHKNIGHT') then
			RUF.db.char.ClassPowerID = 5
			RUF.db.char.ClassPowerType = 'RUNES'
		else
			RUF.db.char.ClassPowerID = nil
			RUF.db.char.ClassPowerType = nil
			RUF.db.char.RequireSpec = nil
			RUF.db.char.RequireSpell = nil
		end
	end

	
	RUF.db.global.UnitList = { -- Store Unit List in DB for easy reference.
		[1] = {
			name = "player",
			group = "",
			frame = "oUF_RUF_Player",
			order = 1,
		},
		[2] = {
			name = "pet",
			group = "",
			frame = "oUF_RUF_Pet",
			order = 2,
		},
		[3] = {
			name = "target",
			group = "",
			frame = "oUF_RUF_Target",
			order = 3,
		},
		[4] = {
			name = "targettarget",
			group = "",
			frame = "oUF_RUF_TargetTarget",
			order = 4,
		},
		[5] = {
			name = "focus",
			group = "",
			frame = "oUF_RUF_Focus",
			order = 5,
		},
		[6] = {
			name = "boss1",
			group = "boss",
			frame = "oUF_RUF_Boss1",
		},
		[7] = {
			name = "boss2",
			group = "boss",
			frame = "oUF_RUF_Boss2",
		},
		[8] = {
			name = "boss3",
			group = "boss",
			frame = "oUF_RUF_Boss3",
		},
		[9] = {
			name = "boss4",
			group = "boss",
			frame = "oUF_RUF_Boss4",
		},
		[10] = {
			name = "boss5",
			group = "boss",
			frame = "oUF_RUF_Boss5",
		},
		[11] = {
			name = "arena1",
			group = "arena",
			frame = "oUF_RUF_Arena1",
		},
		[12] = {
			name = "arena2",
			group = "arena",
			frame = "oUF_RUF_Arena2",
		},
		[13] = {
			name = "arena3",
			group = "arena",
			frame = "oUF_RUF_Arena3",
		},
		[14] = {
			name = "arena4",
			group = "arena",
			frame = "oUF_RUF_Arena4",
		},
		[15] = {
			name = "arena5",
			group = "arena",
			frame = "oUF_RUF_Arena5",
		},
		[16] = {
			name = "party1",
			group = "party",
			frame = "oUF_RUF_PartyUnitButton1",
		},
		[17] = {
			name = "party2",
			group = "party",
			frame = "oUF_RUF_PartyUnitButton2",
		},
		[18] = {
			name = "party3",
			group = "party",
			frame = "oUF_RUF_PartyUnitButton3",
		},
		[19] = {
			name = "party4",
			group = "party",
			frame = "oUF_RUF_PartyUnitButton4",
		},
		[20] = {
			name = "focustarget",
			group = "",
			frame = "oUF_RUF_FocusTarget",
			order = 5,
		},
		[21] = {
			name = "pettarget",
			group = "",
			frame = "oUF_RUF_PetTarget",
			order = 2,
		},
		[22] = {
			name = "bosstarget1",
			group = "bosstarget",
			frame = "oUF_RUF_BossTarget1",
		},
		[23] = {
			name = "bosstarget2",
			group = "bosstarget",
			frame = "oUF_RUF_BossTarget2",
		},
		[24] = {
			name = "bosstarget3",
			group = "bosstarget",
			frame = "oUF_RUF_Boss3Target3",
		},
		[25] = {
			name = "bosstarget4",
			group = "bosstarget",
			frame = "oUF_RUF_Boss4Target4",
		},
		[26] = {
			name = "bosstarget5",
			group = "bosstarget",
			frame = "oUF_RUF_Boss5Target5",
		},
		[27] = {
			name = "arenatarget1",
			group = "arenatarget",
			frame = "oUF_RUF_ArenaTarget1",
		},
		[28] = {
			name = "arenatarget2",
			group = "arenatarget",
			frame = "oUF_RUF_ArenaTarget2",
		},
		[29] = {
			name = "arenatarget3",
			group = "arenatarget",
			frame = "oUF_RUF_ArenaTarget3",
		},
		[30] = {
			name = "arenatarget4",
			group = "arenatarget",
			frame = "oUF_RUF_ArenaTarget4",
		},
		[31] = {
			name = "arenatarget5",
			group = "arenatarget",
			frame = "oUF_RUF_ArenaTarget5",
		},
		[32] = {
			name = "partytarget1",
			group = "partytarget",
			frame = "oUF_RUF_PartyTarget1",
		},
		[33] = {
			name = "partytarget2",
			group = "partytarget",
			frame = "oUF_RUF_PartyTarget2",
		},
		[34] = {
			name = "partytarget3",
			group = "partytarget",
			frame = "oUF_RUF_PartyTarget3",
		},
		[35] = {
			name = "partytarget4",
			group = "partytarget",
			frame = "oUF_RUF_PartyTarget4",
		},
	}

	if not RUFDB.profiles["Alidie's Layout"] then
		RUFDB.profiles["Alidie's Layout"] = RUF.Layout.Alidie
	end
	if not RUFDB.profiles["Raeli's Layout"] then
		RUFDB.profiles["Raeli's Layout"] = RUF.Layout.Raeli
	end
end

local function SetClassColors()
	local function customClassColors()
		if(CUSTOM_CLASS_COLORS) and RUF.db.profile.Appearance.Colors.UseClassColors then
			local function updateColors()
				for classToken, color in next, CUSTOM_CLASS_COLORS do
					RUF.db.profile.Appearance.Colors.ClassColors[classToken] = {(color.r), (color.g), (color.b)}				
				end
				for _, obj in next, oUF.objects do
					obj:UpdateAllElements('CUSTOM_CLASS_COLORS')
				end
			end
			updateColors()
			CUSTOM_CLASS_COLORS:RegisterCallback(updateColors)
			return true
		end
	end
	if(not customClassColors()) then
		local eventHandler = CreateFrame('Frame')
		eventHandler:RegisterEvent('ADDON_LOADED')
		eventHandler:SetScript('OnEvent', function(self)
			if(customClassColors()) then
				self:UnregisterEvent('ADDON_LOADED')
				self:SetScript('OnEvent', nil)
			end
		end)
	end
end

local function SetupFrames(self, unit)
	unit = unit:match('^(.-)%d+') or unit
	self.frame = unit

	-- Set Colors
	SetClassColors()
	RUF:FrameAttributes(self)

	if UnitSettingsDone ~= true then 
		RUF:UpdateUnitSettings()
		UnitSettingsDone = true
	end

	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	-- Frame Border
	local Border = CreateFrame("Frame",self:GetName()..".Border",self)
	local BorderOffsetx = RUF.db.profile.Appearance.Border.Offset
	local BorderOffsety = RUF.db.profile.Appearance.Border.Offset

	if BorderOffsetx == 0 then
		Border:SetPoint("TOPLEFT",self,"TOPLEFT",0,0)
		Border:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",0,0)			
	elseif BorderOffsetx > 0 then
		Border:SetPoint("TOPLEFT",self,"TOPLEFT",-BorderOffsetx,BorderOffsety)
		Border:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",BorderOffsetx,-BorderOffsety)
	elseif BorderOffsetx < 0 then
		Border:SetPoint("TOPLEFT",self,"TOPLEFT",-BorderOffsetx,BorderOffsety)
		Border:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",BorderOffsetx,-BorderOffsety)
	end
	--Border:SetPoint("TOPLEFT",self,"TOPLEFT",-1,1)
	--Border:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",1,-1)
	Border:SetFrameLevel(10)
	Border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Border.Style.edgeSize})
	local borderr,borderg,borderb = unpack(RUF.db.profile.Appearance.Border.Color)
	Border:SetBackdropBorderColor(borderr,borderg,borderb, RUF.db.profile.Appearance.Border.Alpha)
	self.border = Border
	self:SetHeight(RUF.db.profile.unit[unit].Frame.Size.Height)
	self:SetWidth(RUF.db.profile.unit[unit].Frame.Size.Width)
	self:SetClampedToScreen(true)

	-- Setup Bars
	RUF.SetHealth(self, unit)
	self.Health.PreUpdate = RUF.HealthPreUpdate
	self.Health.PostUpdate = RUF.HealthPostUpdate	

	RUF.SetPower(self, unit)
	self.Power.PostUpdate = RUF.PowerPostUpdate

	
	if RUF.db.profile.Appearance.Bars.Absorb.Type == 1 then -- Set Absorb Bar Type
		RUF.SetAbsorbBar(self, unit)
	elseif RUF.db.profile.Appearance.Bars.Absorb.Type == 2 then
		-- TODO: Create Separate Bar option - probably just use SetAbsorbBar and then move it.
		-- SetAbsorbBar(self, unit)
	end
	
	if (unit == 'player') then -- Setup Class Power and Additional Power for Player.
		self.Power.frequentUpdates = true
		if PlayerClass == "MONK" then
			RUF.SetStagger(self, unit)
			self.Stagger.PostUpdate = RUF.StaggerPostUpdate
		end

		if PlayerClass == "PRIEST" or PlayerClass == "SHAMAN" or PlayerClass == "DRUID" then
			RUF.SetAdditionalPower(self, unit)
			self.AdditionalPower.PostUpdate = RUF.PowerPostUpdate
			self.AdditionalPower.OverrideVisibility = RUF.OverrideVisibility		
		elseif RUF.db.char.ClassPowerID then	
			RUF.SetClassBar(self, unit)
			if PlayerClass == "DEATHKNIGHT" then
				self.Runes.PostUpdate = RUF.ClassPostUpdate
			else
				self.ClassPower.PostUpdate = RUF.ClassPostUpdate
			end
		end		
	end

	-- Setup Text Areas
	RUF.SetTextParent(self, unit)
	local Texts = {} 
	for k,v in pairs(RUF.db.profile.unit[unit].Frame.Text) do
		if v ~= "" then
			table.insert(Texts,k)
		end
	end
	for i = 1,#Texts do
		RUF.CreateTextArea(self,unit,Texts[i])
		if RUF.db.profile.unit[unit].Frame.Text[Texts[i]].Enabled == false then
			self.TextParent[Texts[i]]:Hide()
			self.TextParent[Texts[i]].Text:UpdateTag()
			self:Untag(Text)
			-- TODO: Unregister events.
		end
	end
	for i = 1,#Texts do
		RUF.SetTextPoints(self,unit,Texts[i])
	end


	-- Setup Auras
	RUF.SetBuffs(self,unit)
	RUF.SetDebuffs(self,unit)

	-- Setup Indicators
	RUF.SetIndicators(self, unit)

	if unit == 'targettarget' then
		self.onUpdateFrequency	= 0.25 -- TODO Option
	else
		self.onUpdateFrequency	= 1
	end

	-- Update Health Background based on displayed bars and location.
	local FrameIndex = RUF:UnitToIndex(unit)
	RUF:UpdateHealthBackground(FrameIndex)
end

function RUF:OnEnable()	
	oUF:RegisterStyle('RUF_', SetupFrames)
	oUF:Factory(function(self)
		self:SetActiveStyle('RUF_')
		self:Spawn('player'):SetPoint(
			RUF.db.profile.unit["player"].Frame.Position.AnchorFrom,
			RUF.db.profile.unit["player"].Frame.Position.AnchorFrame,
			RUF.db.profile.unit["player"].Frame.Position.AnchorTo,
			RUF.db.profile.unit["player"].Frame.Position.x,
			RUF.db.profile.unit["player"].Frame.Position.y)
		self:Spawn('pet'):SetPoint(
			RUF.db.profile.unit["pet"].Frame.Position.AnchorFrom,
			RUF.db.profile.unit["pet"].Frame.Position.AnchorFrame,
			RUF.db.profile.unit["pet"].Frame.Position.AnchorTo,
			RUF.db.profile.unit["pet"].Frame.Position.x,
			RUF.db.profile.unit["pet"].Frame.Position.y)
		self:Spawn('focus'):SetPoint(
			RUF.db.profile.unit["focus"].Frame.Position.AnchorFrom,
			RUF.db.profile.unit["focus"].Frame.Position.AnchorFrame,
			RUF.db.profile.unit["focus"].Frame.Position.AnchorTo,
			RUF.db.profile.unit["focus"].Frame.Position.x,
			RUF.db.profile.unit["focus"].Frame.Position.y)
		self:Spawn('target'):SetPoint(
			RUF.db.profile.unit["target"].Frame.Position.AnchorFrom,
			RUF.db.profile.unit["target"].Frame.Position.AnchorFrame,
			RUF.db.profile.unit["target"].Frame.Position.AnchorTo,
			RUF.db.profile.unit["target"].Frame.Position.x,
			RUF.db.profile.unit["target"].Frame.Position.y)
		self:Spawn('targettarget'):SetPoint(
			RUF.db.profile.unit["targettarget"].Frame.Position.AnchorFrom,
			RUF.db.profile.unit["targettarget"].Frame.Position.AnchorFrame,
			RUF.db.profile.unit["targettarget"].Frame.Position.AnchorTo,
			RUF.db.profile.unit["targettarget"].Frame.Position.x,
			RUF.db.profile.unit["targettarget"].Frame.Position.y)
		self:Spawn('pettarget'):SetPoint(
			RUF.db.profile.unit["pettarget"].Frame.Position.AnchorFrom,
			RUF.db.profile.unit["pettarget"].Frame.Position.AnchorFrame,
			RUF.db.profile.unit["pettarget"].Frame.Position.AnchorTo,
			RUF.db.profile.unit["pettarget"].Frame.Position.x,
			RUF.db.profile.unit["pettarget"].Frame.Position.y)
		self:Spawn('focustarget'):SetPoint(
			RUF.db.profile.unit["focustarget"].Frame.Position.AnchorFrom,
			RUF.db.profile.unit["focustarget"].Frame.Position.AnchorFrame,
			RUF.db.profile.unit["focustarget"].Frame.Position.AnchorTo,
			RUF.db.profile.unit["focustarget"].Frame.Position.x,
			RUF.db.profile.unit["focustarget"].Frame.Position.y)

		local AnchorFrom
		if RUF.db.profile.unit["party"].Frame.Position.growth == "BOTTOM" then
			AnchorFrom = "TOP"
		elseif RUF.db.profile.unit["party"].Frame.Position.growth == "TOP" then
			AnchorFrom = "BOTTOM"
		end
		local party = oUF:SpawnHeader(
			'oUF_RUF_Party', nil, 'party',
			'showSolo', false,
			'showParty', true,
			'showRaid', false,
			'showPlayer', false,
			'yOffset', RUF.db.profile.unit["party"].Frame.Position.offsety,
			'Point', AnchorFrom
		):SetPoint(
			RUF.db.profile.unit["party"].Frame.Position.AnchorFrom,
			RUF.db.profile.unit["party"].Frame.Position.AnchorFrame,
			RUF.db.profile.unit["party"].Frame.Position.AnchorTo,
			RUF.db.profile.unit["party"].Frame.Position.x,
			RUF.db.profile.unit["party"].Frame.Position.y)

		for index = 1,5 do
			local AnchorFrom
			if RUF.db.profile.unit.boss.Frame.Position.growth == "BOTTOM" then
				AnchorFrom = "TOP"
			elseif RUF.db.profile.unit.boss.Frame.Position.growth == "TOP" then
				AnchorFrom = "BOTTOM"
			end
			local boss = self:Spawn('boss' .. index)
			--local bosstarget = self:Spawn('bosstarget' .. index)
			if(index == 1) then
				boss:SetPoint(
					RUF.db.profile.unit.boss.Frame.Position.AnchorFrom,
					RUF.db.profile.unit.boss.Frame.Position.AnchorFrame,
					RUF.db.profile.unit.boss.Frame.Position.AnchorTo,
					RUF.db.profile.unit.boss.Frame.Position.x,
					RUF.db.profile.unit.boss.Frame.Position.y)
				--[[bosstarget:SetPoint(
					RUF.db.profile.unit.bosstarget.Frame.Position.AnchorFrom,
					RUF.db.profile.unit.bosstarget.Frame.Position.AnchorFrame,
					RUF.db.profile.unit.bosstarget.Frame.Position.AnchorTo,
					RUF.db.profile.unit.bosstarget.Frame.Position.x,
					RUF.db.profile.unit.bosstarget.Frame.Position.y)]]--
			else
				boss:SetPoint(
					AnchorFrom,
					_G['oUF_RUF_Boss' .. index -1],
					RUF.db.profile.unit.boss.Frame.Position.growth,
					RUF.db.profile.unit.boss.Frame.Position.offsetx,
					RUF.db.profile.unit.boss.Frame.Position.offsety)
				--bosstarget:SetPoint('TOP', _G['oUF_RUF_BossTarget' .. index - 1], 'BOTTOM', 0, -4)
			end
		end
		for index = 1, 5 do
			local AnchorFrom
			if RUF.db.profile.unit.arena.Frame.Position.growth == "BOTTOM" then
				AnchorFrom = "TOP"
			elseif RUF.db.profile.unit.arena.Frame.Position.growth == "TOP" then
				AnchorFrom = "BOTTOM"
			end
			local arena = self:Spawn('arena' .. index)
			--local arenatarget = self:Spawn('arenatarget' .. index)
			if(index == 1) then
				arena:SetPoint(
					RUF.db.profile.unit.arena.Frame.Position.AnchorFrom,
					RUF.db.profile.unit.arena.Frame.Position.AnchorFrame,
					RUF.db.profile.unit.arena.Frame.Position.AnchorTo,
					RUF.db.profile.unit.arena.Frame.Position.x,
					RUF.db.profile.unit.arena.Frame.Position.y)
				--[[arenatarget:SetPoint(
					RUF.db.profile.unit.arenatarget.Frame.Position.AnchorFrom,
					RUF.db.profile.unit.arenatarget.Frame.Position.AnchorFrame,
					RUF.db.profile.unit.arenatarget.Frame.Position.AnchorTo,
					RUF.db.profile.unit.arenatarget.Frame.Position.x,
					RUF.db.profile.unit.arenatarget.Frame.Position.y)]]--
			else
				arena:SetPoint(
					AnchorFrom,
					_G['oUF_RUF_Arena' .. index -1],
					RUF.db.profile.unit.arena.Frame.Position.growth,
					RUF.db.profile.unit.arena.Frame.Position.offsetx,
					RUF.db.profile.unit.arena.Frame.Position.offsety)
				--arenatarget:SetPoint('TOP', _G['oUF_RUF_ArenaTarget' .. index - 1], 'BOTTOM', 0, -4)
			end
		end
	end)

	local PartyNum = GetNumGroupMembers() -1
	if PartyNum == -1 then PartyNum = 0 end
	if IsInRaid() then
		PartyNum = GetNumSubgroupMembers()
	end
	oUF_RUF_Party:SetAttribute('startingIndex', -3 + PartyNum)
	oUF_RUF_Party:Show()
	oUF_RUF_Party:SetAttribute('startingIndex', 1)
	oUF_RUF_Party:SetClampedToScreen(true)
	RegisterAttributeDriver(oUF_RUF_Party,'state-visibility',oUF_RUF_Party.visibility)


	-- Create Party Holder for dragging.
	local MoveBG = CreateFrame("Frame",oUF_RUF_Party:GetName()..".MoveBG",oUF_RUF_Party)
	MoveBG:SetAllPoints(oUF_RUF_Party)
	local Background = MoveBG:CreateTexture(oUF_RUF_Party:GetName()..".MoveBG.BG","BACKGROUND")
	Background:SetTexture(LSM:Fetch("background", "Solid"))	
	Background:SetAllPoints(MoveBG)
	Background:SetVertexColor(0,0,0,0)
	MoveBG:SetFrameStrata("BACKGROUND")

	for i = 1,#RUF.db.global.UnitList do
		if _G[RUF.db.global.UnitList[i].frame] then
			if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Enabled == false then
				_G[RUF.db.global.UnitList[i].frame]:Disable()
			elseif RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Enabled == true then
				_G[RUF.db.global.UnitList[i].frame]:Enable()
			end
		end
	end
end
