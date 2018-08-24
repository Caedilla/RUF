local RUF = LibStub("AceAddon-3.0"):NewAddon("RUF", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")
local LSM = LibStub("LibSharedMedia-3.0")

function RUF:ChatCommand(input)
	if not InCombatLockdown() then
		if not IsAddOnLoaded("RUF_Options") then
			LoadAddOn("RUF_Options")
			if input == "Blizz" then
				InterfaceOptionsFrame_OpenToCategory("RUF","RUF")
				InterfaceOptionsFrame_OpenToCategory("RUF","RUF")
			else
				LibStub("AceConfigDialog-3.0"):Open("RUF")
			end
		else
			if input == "Blizz" then
				InterfaceOptionsFrame_OpenToCategory("RUF","RUF")
				InterfaceOptionsFrame_OpenToCategory("RUF","RUF")
			else
				LibStub("AceConfigDialog-3.0"):Open("RUF")	
			end
		end
	else
		RUF:Print_Self(L["Cannot configure while in combat."])
	end	
end

function RUF:RefreshConfig()
	RUF.db.profile = self.db.profile
	RUF:UpdateUnitSettings()
	RUF:UpdateFrames()
	RUF:UpdateAllAuras()
	if IsAddOnLoaded("RUF_Options") then
		RUF:UpdateOptions()
	end
end
