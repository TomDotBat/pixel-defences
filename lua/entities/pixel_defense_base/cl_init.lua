
include("shared.lua")

PIXEL.RegisterFontUnscaled("Defences.EntityTitle", "Open Sans SemiBold", 255)
PIXEL.RegisterFontUnscaled("Defences.EntityHealth", "Open Sans SemiBold", 120)
PIXEL.RegisterFontUnscaled("Defences.EntityHint", "Open Sans SemiBold", 100)

local localPly
function ENT:Draw()
	if not IsValid(localPly) then localPly = LocalPlayer() end

	if self:GetIsBuilding() then
		self.height = self.height or 0
		self.colr = self.colr or 1
		self.colg = self.colg or 0
		self:DrawSpawning()
	else
		self:DrawModel()
	end

	if self:GetPos():DistToSqr(localPly:GetPos()) > 30000 then return end

	if self:GetIsPlaced() then
		self:Draw3D2DDefence()
	else
		PIXEL.DrawEntOverhead(self, "Tier " .. self.DefenceTier .. " Defence")
	end
end

ENT.BuildProgress = 0

function ENT:Draw3D2DDefence()
	local ang = self:GetAngles()
	local min, max = self:GetModelBounds()
	local pos = Vector(0, 0, 0)

	if (self.RotateText) then
		pos.y = pos.y + min.y
		pos.z = pos.z + (max.z * 0.5)
		pos = pos + self.UIOffset
		pos = self:LocalToWorld(pos)

		ang:RotateAroundAxis(ang:Up(), 0)
		ang:RotateAroundAxis(ang:Forward(), 90)
	else
		pos.x = pos.x + max.x
		pos.z = pos.z + (max.z * 0.5)
		pos = pos + self.UIOffset
		pos = self:LocalToWorld(pos)

		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Forward(), 90)
	end

	local tText = "Tier " .. self.DefenceTier .. " Defence"
	local hText = "Health: " .. self:GetDefenceHealth()

	if self:GetIsBuilding() then
		hText = "Building: " .. tostring(math.Round((self:GetDefenceHealth() / self.DefenceMaxHP) * 100)) .. "%"
	end

	cam.Start3D2D(pos, ang, 0.028)
		PIXEL.SetFont("Defences.EntityTitle")
		surface.SetTextColor(255, 255, 255)
		local w,h = surface.GetTextSize(tText)
		surface.SetTextPos(0-(w/2), -150)
		surface.DrawText(tText)

		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(-(w/2), -150, w, 20)
		surface.DrawRect(-(w/2), 90, w, 20)

		PIXEL.SetFont("Defences.EntityHealth")
		w,h = surface.GetTextSize(hText)
		surface.SetTextPos(0-(w/2), 120)
		surface.DrawText(hText)

	cam.End3D2D()
	if (self.RotateText) then
		pos = Vector(0, 0, 0)
		pos.x = self.UIOffset.x
		pos.y = (pos.y + max.y) - self.UIOffset.y
		pos.z = (pos.z + (max.z * 0.5)) + self.UIOffset.z

		pos = self:LocalToWorld(pos)
	else
		pos = Vector(0, 0, 0)
		pos.x = pos.x + min.x
		pos.z = pos.z + (max.z * 0.5)
		pos = pos - self.UIOffset
		pos = self:LocalToWorld(pos)
	end

	ang:RotateAroundAxis(ang:Right(), 180)

	cam.Start3D2D(pos, ang, 0.028)
		PIXEL.SetFont("Defences.EntityTitle")
		surface.SetTextColor(255, 255, 255)
		local w,h = surface.GetTextSize(tText)
		surface.SetTextPos(0-(w/2), -150)
		surface.DrawText(tText)

		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(-(w/2), -150, w, 20)
		surface.DrawRect(-(w/2), 90, w, 20)

		PIXEL.SetFont("Defences.EntityHealth")
		w,h = surface.GetTextSize(hText)
		surface.SetTextPos(0-(w/2), 120)
		surface.DrawText(hText)

	cam.End3D2D()
end

local progressMat = Material("models/effects/comball_tape")
function ENT:DrawSpawning()
	self.BuildProgress = Lerp(FrameTime(), self.BuildProgress, self:GetDefenceHealth())

	local progress = self.BuildProgress / self.DefenceMaxHP

	render.MaterialOverride(progressMat)

	render.SetColorModulation(self.colr, self.colg, 100)

	self:DrawModel()

	render.MaterialOverride()

	self.colr = -progress
	self.colg = progress
	self.height = self.MaxHeight * progress

	render.SetColorModulation(1, 1, 1)

	render.MaterialOverride()

	local normal = -self:GetAngles():Up()
	local pos = self:LocalToWorld(Vector(0, 0, self:OBBMins().z + self.height))
	local distance = normal:Dot(pos)
	render.EnableClipping(true)
	render.PushCustomClipPlane(normal, distance)

	self:DrawModel()

	render.PopCustomClipPlane()
end