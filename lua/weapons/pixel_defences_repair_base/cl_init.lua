
include("shared.lua")

function SWEP:PrimaryAttack() end

local laserMat = Material("sprites/bluelaser1")
function SWEP:DrawHUD()
	local ply = LocalPlayer()
	local facingEnt = PIXEL.Defences.GetLookingAtEnt(ply)
	if (!facingEnt) then return end

	self.CurHealth = Lerp(FrameTime() * 5, self.CurHealth, facingEnt:GetDefenceHealth())

	local col = Color(255, 255 * (self.CurHealth / facingEnt.DefenceMaxHP), 255 * (self.CurHealth / facingEnt.DefenceMaxHP))

	local text = "Tier " .. facingEnt.DefenceTier .. " Defence"
	surface.SetFont("oglDefenseHudTitle")
	surface.SetTextColor(col)
	local w,h = surface.GetTextSize(text)
	surface.SetTextPos((ScrW()/2)-(w/2), (ScrH()*0.99)-150)
	surface.DrawText(text)
	draw.RoundedBox(0, (ScrW()/2)-(w/2), (ScrH()*0.99)-h*2, w, 5, col)

	text = "Health: " .. math.Round(self.CurHealth)
	surface.SetFont("oglDefenseHudSubTitle")
	w,h = surface.GetTextSize(text)
	surface.SetTextPos((ScrW()/2)-(w/2), (ScrH()*0.99)-90)
	surface.DrawText(text)

    local vm = ply:GetViewModel()
	if vm then
		local t = util.GetPlayerTrace(ply)
		local tr = util.TraceLine(t)

	    cam.Start3D(EyePos(), EyeAngles())
			render.SetMaterial(laserMat)
			render.DrawBeam(vm:GetAttachment("1").Pos, tr.HitPos, 4, 0, 12.5, Color(0, 255, 0, 255))
		cam.End3D()

		if (input.IsMouseDown(MOUSE_LEFT) and (facingEnt:GetDefenceHealth() < facingEnt.DefenceMaxHP)) then
			local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetMagnitude(1)
			effectdata:SetScale(0.5)
			effectdata:SetRadius(2)
			util.Effect("Sparks", effectdata)
		end
	end
end
