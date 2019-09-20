local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local _, PlayerClass = UnitClass('player')
local UnitSettingsDone


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
	local profileReference = RUF.db.profile.unit[unit]

	-- Set Colors
	if RUF.Client == 1 then
		SetClassColors()
	end

	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	-- Frame Size
	self:SetHeight(profileReference.Frame.Size.Height)
	self:SetWidth(profileReference.Frame.Size.Width)
	self:SetClampedToScreen(true)

	-- Frame Border
	RUF.SetFrameBorder(self,unit)

	-- Aura Highlight Border
	if not unit:match('%w+target') then
	--if unit ~= 'targettarget' and unit ~= 'pettarget' and unit ~= 'focustarget' then
		RUF.SetGlowBorder(self,unit)
	end

	-- Frame Background
	RUF.SetFrameBackground(self, unit)


	-- Setup Bars
	RUF.SetHealthBar(self, unit)
	self.Health.Override = RUF.HealthUpdate
	self.Health.UpdateColor = RUF.HealthUpdateColor

	RUF.SetPowerBar(self, unit)
	self.Power.Override = RUF.PowerUpdate

	if RUF.Client == 1 then
		-- Prevents trying to load these elements for Classic since they don't exist in Classic.
		RUF.SetAbsorbBar(self, unit)
		self.Absorb.Override = RUF.AbsorbUpdate

		if unit == 'player' then
			self:SetAttribute('toggleForVehicle', false) -- TODO Implement option for this
			RUF.SetClassBar(self, unit) -- Normal Class Power bar
			RUF.SetFakeClassBar(self, unit) -- Fake Clone Bar for Insanity/Maelstrom/Lunar Power
			RUF.SetRunes(self, unit)
			RUF.SetStagger(self, unit)
		end
		if unit == 'pet' then
			self:SetAttribute('toggleForVehicle', false)
		end

	end


	if unit == 'player' or unit == 'target' then
		RUF.SetCastBar(self, unit)
	end
	if RUF.Client == 1 and unit == 'focus' then
		RUF.SetCastBar(self, unit)
	end

	RUF.SetTextParent(self,unit)
	local texts = {}
	for k,v in pairs(profileReference.Frame.Text) do
		if v ~= '' then
			table.insert(texts,k)
		end
	end
	for i = 1,#texts do
		RUF.CreateTextArea(self,unit,texts[i])
		if profileReference.Frame.Text[texts[i]].Enabled == false then
			self.Text[texts[i]].String:UpdateTag()
			self:Untag(self.Text[texts[i]].String)
			self.Text[texts[i]].String:Hide()
		end
	end
	for i = 1,#texts do
		RUF.SetTextPoints(self,unit,texts[i])
	end

	-- Setup Auras
	RUF.SetBuffs(self,unit)
	RUF.SetDebuffs(self,unit)
	if RUF.db.profile.unit[self.frame].Buffs.Icons.Enabled == false then
		self.Buff.Enabled = false
		self:DisableElement('Aura_Plugin')
	end
	if RUF.db.profile.unit[self.frame].Debuffs.Icons.Enabled == false then
		self.Debuff.Enabled = false
		self:DisableElement('Aura_Plugin')
	end

	-- Indicators
	RUF.SetIndicators(self, unit)

	if unit == 'player' and RUF.Client == 1 then
		self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', RUF.SetBarLocation, true)
		self:RegisterEvent('PLAYER_ENTERING_WORLD', RUF.SetBarLocation, true)
	end

	RUF.SetBarLocation(self,unit)

	if unit ~= 'player' then
		self.RangeCheck = {
			enabled = profileReference.Frame.RangeFading.Enabled,
			insideAlpha = 1,
			outsideAlpha = profileReference.Frame.RangeFading.Alpha or 1,
		}
	end

end


function RUF:OnEnable()
	if RUF.FirstRun then
		local function FirstRunReload()
			C_UI.Reload()
		end
		RUF:PopUp('RUFFirstRun',L["RUF [|c5500DBBDRaeli's Unit Frames|r] needs to reload your UI to properly finish installing on first use. Please do this now."],L["Accept"],nil,FirstRunReload)
		StaticPopup_Show('RUFFirstRun')
	end

	-- Set RUF stored nickname to one from NickTag so we can have the options menu display correctly (displaying blank if a nickname is not set)
	RUF:NickTagSetCache(RUF.db.char.NickCache)
	local nickName = RUF:GetNickname(UnitName('player'),false,true) or UnitName('player')
	if RUF.db.char.Nickname ~= '' then
		if nickName ~= UnitName('player') then
			RUF.db.char.Nickname = nickName
		else
			RUF.db.char.Nickname = ""
		end
	end

	-- Register Combat Fader
	if RUF.db.profile.Appearance.CombatFader.Enabled == true then
		if RUF.Client == 1 then
			self:RegisterEvent('PLAYER_TARGET_CHANGED', RUF.CombatFader, true)
		else
			self:RegisterEvent('UNIT_TARGET', RUF.CombatFader, true)
		end
		self:RegisterEvent('PLAYER_REGEN_DISABLED', RUF.CombatFader, true)
		self:RegisterEvent('PLAYER_REGEN_ENABLED', RUF.CombatFader, true)
		self:RegisterEvent('PLAYER_ENTERING_WORLD', RUF.CombatFader, true)
	end

	oUF:RegisterStyle('RUF_', SetupFrames)
	oUF:Factory(function(self)
		self:SetActiveStyle('RUF_')

		-- Spawn single unit frames
		local frames = RUF.frameList.frames
		local groupFrames = RUF.frameList.groupFrames
		local headers = RUF.frameList.headers

		for i = 1,#frames do
			local profile = string.lower(frames[i])
			self:Spawn(profile):SetPoint(
				RUF.db.profile.unit[profile].Frame.Position.AnchorFrom,
				RUF.db.profile.unit[profile].Frame.Position.AnchorFrame,
				RUF.db.profile.unit[profile].Frame.Position.AnchorTo,
				RUF.db.profile.unit[profile].Frame.Position.x,
				RUF.db.profile.unit[profile].Frame.Position.y)

			if RUF.db.profile.unit[profile].Enabled == false then
				_G['oUF_RUF_' .. frames[i]]:Disable()
			end
		end


		-- Spawn Headers
		for i = 1,#headers do
			local profile = RUF.db.profile.unit[string.lower(headers[i])]
			local anchorFrom
			if profile.Frame.Position.growth == 'BOTTOM' then
				anchorFrom = 'TOP'
			elseif profile.Frame.Position.growth == 'TOP' then
				anchorFrom = 'BOTTOM'
			end
			self:SpawnHeader(
				'oUF_RUF_' .. headers[i], nil, 'party',
				'showSolo', false,
				'showParty', true,
				'showRaid', false,
				'showPlayer', false,
				'yOffset', profile.Frame.Position.offsety,
				'Point', anchorFrom
			):SetPoint(
				profile.Frame.Position.AnchorFrom,
				profile.Frame.Position.AnchorFrame,
				profile.Frame.Position.AnchorTo,
				profile.Frame.Position.x,
				profile.Frame.Position.y)

			local partyNum = GetNumSubgroupMembers()
			local currentHeader = _G['oUF_RUF_' .. headers[i]]
			currentHeader.Enabled = profile.Enabled
			currentHeader:SetAttribute('startingIndex', -3 + partyNum)
			currentHeader:Show()
			currentHeader:SetAttribute('startingIndex', 1)
			currentHeader:SetClampedToScreen(true)
			RegisterAttributeDriver(currentHeader,'state-visibility',currentHeader.visibility)
			if profile.Enabled == false then
				for j = 1,4 do
					_G[currentHeader .. 'UnitButton' .. j]:Disable()
				end
			end

			-- Create Party Holder for dragging.
			local MoveBG = CreateFrame('Frame',currentHeader:GetName()..'.MoveBG',currentHeader)
			MoveBG:SetAllPoints(currentHeader)
			local Background = MoveBG:CreateTexture(currentHeader:GetName()..'.MoveBG.BG','BACKGROUND')
			Background:SetTexture(LSM:Fetch('background', 'Solid'))
			Background:SetAllPoints(MoveBG)
			Background:SetVertexColor(0,0,0,0)
			MoveBG:SetFrameStrata('HIGH')
			MoveBG:Hide()

		end

		-- Spawn single frames for Boss and Arena units
		for i = 1, #groupFrames do
			local frameName = 'oUF_RUF_' .. groupFrames[i]
			local profile = string.lower(groupFrames[i])
			local AnchorFrom
			if RUF.db.profile.unit[profile].Frame.Position.growth == 'BOTTOM' then
				AnchorFrom = 'TOP'
			elseif RUF.db.profile.unit[profile].Frame.Position.growth == 'TOP' then
				AnchorFrom = 'BOTTOM'
			end
			for u = 1,5 do
				local frame = self:Spawn(profile..u)
				if(u == 1) then
					frame:SetPoint(
						RUF.db.profile.unit[profile].Frame.Position.AnchorFrom,
						RUF.db.profile.unit[profile].Frame.Position.AnchorFrame,
						RUF.db.profile.unit[profile].Frame.Position.AnchorTo,
						RUF.db.profile.unit[profile].Frame.Position.x,
						RUF.db.profile.unit[profile].Frame.Position.y)
				else
					frame:SetPoint(
						AnchorFrom,
						_G[frameName .. u -1],
						RUF.db.profile.unit[profile].Frame.Position.growth,
						RUF.db.profile.unit[profile].Frame.Position.offsetx,
						RUF.db.profile.unit[profile].Frame.Position.offsety)
				end
				if RUF.db.profile.unit[profile].Enabled == false then
					_G['oUF_RUF_' .. groupFrames[i]..u]:Disable()
				end
			end
		end
	end)


	if PlayerClass == 'DEATHKNIGHT' then
		-- I don't know why, but this only seems to work here.
		if RUF.db.profile.unit['player'].Frame.Bars.Class.Enabled == false then
			oUF_RUF_Player:DisableElement('Runes')
		end
	end
end