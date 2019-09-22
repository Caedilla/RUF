local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local _, ns = ...
local oUF = ns.oUF
local faderState

function RUF.CombatFader(self,event,unit)
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
		end
	end
	if profileReference.Enabled then
		faderState = true
		for k, v in next, oUF.objects do
			if (event == 'PLAYER_TARGET_CHANGED' or event == 'updateOptions' or (event == 'UNIT_TARGET' and unit == 'player')) and not InCombatLockdown() then
				if profileReference.targetOverride == true and UnitExists('target') then
					v:SetAlpha(profileReference.targetAlpha)
					v.Alpha = profileReference.targetAlpha
				else
					v:SetAlpha(profileReference.restAlpha)
					v.Alpha = profileReference.restAlpha
				end
			elseif event == 'PLAYER_REGEN_DISABLED' then
				v:SetAlpha(profileReference.combatAlpha)
				v.Alpha = profileReference.combatAlpha
			elseif event == 'PLAYER_REGEN_ENABLED' then
				v:SetAlpha(profileReference.restAlpha)
				v.Alpha = profileReference.restAlpha
			elseif event == 'PLAYER_ENTERING_WORLD' then
				if InCombatLockdown() then
					v:SetAlpha(profileReference.combatAlpha)
					v.Alpha = profileReference.combatAlpha
				else
					v:SetAlpha(profileReference.restAlpha)
					v.Alpha = profileReference.restAlpha
				end
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