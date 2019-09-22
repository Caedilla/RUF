local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF

function RUF.SetFramePortrait(self, unit)
	-- 3D Portrait
	-- Position and size
	local Portrait = CreateFrame('PlayerModel', nil, self)
	Portrait:SetSize(32, 32)
	Portrait:SetPoint('RIGHT', self, 'LEFT')

	-- Register it with oUF
	self.Portrait = Portrait

	-- 2D Portrait
	--local Portrait = self:CreateTexture(nil, 'OVERLAY')
	--Portrait:SetSize(32, 32)
	--Portrait:SetPoint('RIGHT', self, 'LEFT')

	-- Register it with oUF
	--self.Portrait = Portrait
end