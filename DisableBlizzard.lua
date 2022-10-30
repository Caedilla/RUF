local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF

-- Override oUF:DisableBlizzard so we only disable frames that are actually set to be disabled by the config options.

-- sourced from Blizzard_ArenaUI/Blizzard_ArenaUI.lua
local MAX_ARENA_ENEMIES = MAX_ARENA_ENEMIES or 5

-- sourced from FrameXML/TargetFrame.lua
local MAX_BOSS_FRAMES = MAX_BOSS_FRAMES or 5

-- sourced from FrameXML/PartyMemberFrame.lua
local MAX_PARTY_MEMBERS = MAX_PARTY_MEMBERS or 4
local isPartyHooked = false

local hiddenParent = CreateFrame('Frame', nil, UIParent)
hiddenParent:SetAllPoints()
hiddenParent:Hide()

local function insecureOnShow(self)
	self:Hide()
end

local function handleFrame(baseName, doNotReparent)
	local frame
	if(type(baseName) == 'string') then
		frame = _G[baseName]
	else
		frame = baseName
	end

	if(frame) then
		frame:UnregisterAllEvents()
		frame:Hide()

		if(not doNotReparent) then
			frame:SetParent(hiddenParent)
		end

		local health = frame.healthBar or frame.healthbar or frame.HealthBar
		if(health) then
			health:UnregisterAllEvents()
		end

		local power = frame.manabar or frame.ManaBar
		if(power) then
			power:UnregisterAllEvents()
		end

		local spell = frame.castBar or frame.spellbar
		if(spell) then
			spell:UnregisterAllEvents()
		end

		local altpowerbar = frame.powerBarAlt or frame.PowerBarAlt
		if(altpowerbar) then
			altpowerbar:UnregisterAllEvents()
		end

		local buffFrame = frame.BuffFrame
		if(buffFrame) then
			buffFrame:UnregisterAllEvents()
		end

		local petFrame = frame.PetFrame
		if(petFrame) then
			petFrame:UnregisterAllEvents()
		end

		local totFrame = frame.totFrame
		if(totFrame) then
			totFrame:UnregisterAllEvents()
		end
	end
end

oUF.DisableBlizzard = function(self, unit)
	if(not unit) then return end

	if(unit == 'player') then
		if RUF.db.profile.Appearance.disableBlizzard.player == true then
			handleFrame(PlayerFrame)

			if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
				-- Modification from Source to support classic. These events are not in Classic.
				PlayerFrame:RegisterEvent('UNIT_ENTERING_VEHICLE')
				PlayerFrame:RegisterEvent('UNIT_ENTERED_VEHICLE')
				PlayerFrame:RegisterEvent('UNIT_EXITING_VEHICLE')
				PlayerFrame:RegisterEvent('UNIT_EXITED_VEHICLE')
			end

			-- User placed frames don't animate
			PlayerFrame:SetUserPlaced(true)
			PlayerFrame:SetDontSavePosition(true)
		end
	elseif(unit == 'pet') then
		if RUF.db.profile.Appearance.disableBlizzard.pet == true then
			handleFrame(PetFrame)
		end
	elseif(unit == 'target') then
		if RUF.db.profile.Appearance.disableBlizzard.target == true then
			handleFrame(TargetFrame)
			handleFrame(ComboFrame)
		end
	elseif(unit == 'focus') then
		if RUF.db.profile.Appearance.disableBlizzard.focus == true then
			handleFrame(FocusFrame)
			handleFrame(TargetofFocusFrame)
		end
	elseif(unit == 'targettarget') then
		if RUF.db.profile.Appearance.disableBlizzard.targettarget == true then
			handleFrame(TargetFrameToT)
		end
	elseif(unit:match('boss%d?$')) then
		if RUF.db.profile.Appearance.disableBlizzard.boss == true then
			local id = unit:match('boss(%d)')
			if(id) then
				handleFrame('Boss' .. id .. 'TargetFrame')
			else
				for i = 1, MAX_BOSS_FRAMES do
					handleFrame(string.format('Boss%dTargetFrame', i))
				end
			end
		end
	elseif(unit:match('party%d?$')) then
		if RUF.db.profile.Appearance.disableBlizzard.party == true then
			if RUF.IsRetail() then
				if(not isPartyHooked) then
					isPartyHooked = true

					PartyFrame:UnregisterAllEvents()

					for frame in PartyFrame.PartyMemberFramePool:EnumerateActive() do
						handleFrame(frame)
					end
				end
			else
				local id = unit:match('party(%d)')
				if(id) then
					handleFrame('PartyMemberFrame' .. id)
				else
					for i = 1, MAX_PARTY_MEMBERS do
						handleFrame(string.format('PartyMemberFrame%d', i))
					end
				end
			end


		end
	elseif(unit:match('arena%d?$')) then
		if RUF.db.profile.Appearance.disableBlizzard.arena == true then
			local id = unit:match('arena(%d)')
			if(id) then
				handleFrame('ArenaEnemyFrame' .. id)
			else
				for i = 1, MAX_ARENA_ENEMIES do
					handleFrame(string.format('ArenaEnemyFrame%d', i))
				end
			end

			-- Blizzard_ArenaUI should not be loaded
			Arena_LoadUI = function() end
			SetCVar('showArenaEnemyFrames', '0', 'SHOW_ARENA_ENEMY_FRAMES_TEXT')
		end
	elseif(unit:match('nameplate%d+$')) then
		if RUF.db.profile.Appearance.disableBlizzard.nameplate == true then
			local frame = C_NamePlate.GetNamePlateForUnit(unit)
			if(frame and frame.UnitFrame) then
				if(not frame.UnitFrame.isHooked) then
					frame.UnitFrame:HookScript('OnShow', insecureOnShow)
					frame.UnitFrame.isHooked = true
				end

				handleFrame(frame.UnitFrame, true)
			end
		end
	end
end