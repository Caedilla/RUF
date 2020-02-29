local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local _, ns = ...
local oUF = ns.oUF
local faderState





--[[

		local AnimationGroup = element:CreateAnimationGroup()
		AnimationGroup:HookScript('OnFinished', OnFinished)
		element.Animation = AnimationGroup

		local Animation = AnimationGroup:CreateAnimation('Alpha')
		Animation:SetFromAlpha(1)
		Animation:SetToAlpha(0)
		Animation:SetDuration(element.fadeTime or 1.5)
		Animation:SetStartDelay(element.finishedTime or 10)


		element.Animation:Play()

]]--

local function DamagedPlayerTrigger(self, event, unit, v)
	local profileReference = RUF.db.profile.Appearance.CombatFader
	if v ~= oUF_RUF_Player then return false end
	if profileReference.damagedOverride ~= true then return false end
	if InCombatLockdown() then return false end
	if (unit ~= 'player' and unit ~= nil) then return false end
	local playerPercentHealth = RUF:Percent(UnitHealth('player'), UnitHealthMax('player'))
	if playerPercentHealth > profileReference.damagedPercent then return false end
	return true
end


function RUF.CombatFader(self, event, unit)
	local profileReference = RUF.db.profile.Appearance.CombatFader
	if event == 'updateOptions' then
		if profileReference.Enabled then
			if RUF.Client == 1 then
				RUF:RegisterEvent('PLAYER_TARGET_CHANGED', RUF.CombatFader, true)
			else
				RUF:RegisterEvent('PLAYER_TARGET_CHANGED', RUF.CombatFader, true)
				RUF:RegisterEvent('UNIT_TARGET', RUF.CombatFader, true)
			end
			RUF:RegisterEvent('PLAYER_REGEN_DISABLED', RUF.CombatFader, true)
			RUF:RegisterEvent('PLAYER_REGEN_ENABLED', RUF.CombatFader, true)
			RUF:RegisterEvent('PLAYER_ENTERING_WORLD', RUF.CombatFader, true)
			RUF:RegisterEvent('UNIT_HEALTH', RUF.CombatFader, true)
			RUF:RegisterEvent('UNIT_MAXHEALTH', RUF.CombatFader, true)
		else
			if RUF.Client == 1 then
				RUF:UnregisterEvent('PLAYER_TARGET_CHANGED', RUF.CombatFader)
			else
				RUF:UnregisterEvent('PLAYER_TARGET_CHANGED', RUF.CombatFader)
				RUF:UnregisterEvent('UNIT_TARGET', RUF.CombatFader)
			end
			RUF:UnregisterEvent('PLAYER_REGEN_DISABLED', RUF.CombatFader)
			RUF:UnregisterEvent('PLAYER_REGEN_ENABLED', RUF.CombatFader)
			RUF:UnregisterEvent('PLAYER_ENTERING_WORLD', RUF.CombatFader)
			RUF:UnregisterEvent('UNIT_HEALTH', RUF.CombatFader)
			RUF:UnregisterEvent('UNIT_MAXHEALTH', RUF.CombatFader)
		end
	end
	if profileReference.Enabled then
		faderState = true
		local playerPercentHealth = RUF:Percent(UnitHealth('player'), UnitHealthMax('player'))
		for k, v in next, oUF.objects do
			if (event == 'PLAYER_TARGET_CHANGED' or event == 'updateOptions' or (event == 'UNIT_TARGET' and unit == 'player')) and not InCombatLockdown() then
				if profileReference.targetOverride == true and UnitExists('target') then
					v:SetAlpha(profileReference.targetAlpha or 1)
					v.Alpha = profileReference.targetAlpha or 1
				else
					v:SetAlpha(profileReference.restAlpha or 0.5)
					v.Alpha = profileReference.restAlpha or 0.5
				end
				if DamagedPlayerTrigger(self, event, unit, v) == true then
					oUF_RUF_Player:SetAlpha(profileReference.damagedAlpha or 1)
					oUF_RUF_Player.Alpha = profileReference.damagedAlpha or 1
				end
			elseif event == 'PLAYER_REGEN_DISABLED' then
				v:SetAlpha(profileReference.combatAlpha or 1)
				v.Alpha = profileReference.combatAlpha or 1
			elseif event == 'PLAYER_REGEN_ENABLED' then
				if DamagedPlayerTrigger(self, event, unit, v) == true then
					oUF_RUF_Player:SetAlpha(profileReference.damagedAlpha or 1)
					oUF_RUF_Player.Alpha = profileReference.damagedAlpha or 1
				else
					v:SetAlpha(profileReference.restAlpha or 0.5)
					v.Alpha = profileReference.restAlpha or 0.5
				end
			elseif event == 'PLAYER_ENTERING_WORLD' then
				if InCombatLockdown() then
					v:SetAlpha(profileReference.combatAlpha or 1)
					v.Alpha = profileReference.combatAlpha or 0.5
				else
					v:SetAlpha(profileReference.restAlpha or 1)
					v.Alpha = profileReference.restAlpha or 0.5
				end
			elseif DamagedPlayerTrigger(self, event, unit, v) == true then
				oUF_RUF_Player:SetAlpha(profileReference.damagedAlpha or 1)
				oUF_RUF_Player.Alpha = profileReference.damagedAlpha or 1
			end
		end
	elseif faderState == true then
		for k, v in next, oUF.objects do
			v:SetAlpha(1)
			v.Alpha = 1
		end
		faderState = false
	end
end