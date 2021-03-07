
include("shared.lua")

SWEP.NextSpark = 0

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end

PIXEL.RegisterFont("Defences.RepairType", "Open Sans Bold", 40)
PIXEL.RegisterFont("Defences.RepairHealth", "Open Sans SemiBold", 34)

function SWEP:DrawHUD()
	local owner = self:GetOwner()

	local lookingAtEnt = PIXEL.Defences.GetLookingAtEnt(owner)
	if not lookingAtEnt then return end

	self.CurHealth = Lerp(FrameTime() * 8, self.CurHealth, lookingAtEnt:GetDefenceHealth())

	local centerW = ScrW() * .5
	local textX = ScrH() * .8

	local _, textH = PIXEL.DrawSimpleText(
		"Tier " .. lookingAtEnt.DefenceTier .. " Defence",
		"Defences.EditorType", centerW, textX,
		PIXEL.Colors.PrimaryText, TEXT_ALIGN_CENTER
	)
	textX = textX + textH

	_, textH = PIXEL.DrawSimpleText(
		"Health: " .. math.Round(self.CurHealth),
		"Defences.EditorRotation", centerW, textX,
		PIXEL.LerpColor(self.CurHealth / lookingAtEnt.DefenceMaxHP, PIXEL.Colors.Negative, PIXEL.Colors.Positive), TEXT_ALIGN_CENTER
	)

	if CurTime() < self.NextSpark then return end
	if not input.IsMouseDown(MOUSE_LEFT) or (lookingAtEnt:GetDefenceHealth() >= lookingAtEnt.DefenceMaxHP) then return end

	local tr = owner:GetEyeTrace()
	local effectdata = EffectData()

	effectdata:SetOrigin(tr.HitPos)
	effectdata:SetMagnitude(0.5)
	effectdata:SetScale(2)
	effectdata:SetRadius(3)

	util.Effect("Sparks", effectdata)

	self.NextSpark = CurTime() + .1
	sound.Play("ambient/energy/spark" .. math.random(1, 6) .. ".wav", tr.HitPos, 80, 100, 1)
end

local laserMat = Material("sprites/bluelaser1")
local laserCol = Color(255, 0, 0)
function SWEP:ViewModelDrawn()
	local owner = self:GetOwner()
	if not IsValid(owner) then return end

	local viewModel = owner:GetViewModel()
	if not IsValid(viewModel) then return end

	local _, endPos = PIXEL.Defences.GetLookingAtEnt(owner)
	if not endPos then return end

	cam.Start3D()
		render.SetMaterial(laserMat)
		render.DrawBeam(viewModel:GetAttachment("1").Pos, endPos, 4, 0, 12.5, laserCol)
	cam.End3D()
end