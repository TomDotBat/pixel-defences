
include("shared.lua")

PIXEL.RegisterFontUnscaled("Defences.EntityTitle", "Open Sans SemiBold", 255)
PIXEL.RegisterFontUnscaled("Defences.EntityHealth", "Open Sans SemiBold", 120)
PIXEL.RegisterFontUnscaled("Defences.EntityHint", "Open Sans SemiBold", 100)

ENT.BuildProgress = 0
ENT.Height = 0

local localPly
function ENT:Draw()
	if not IsValid(localPly) then localPly = LocalPlayer() end

	if self:GetIsBuilding() then self:DrawSpawning()
	else self:DrawModel() end

	if self:GetPos():DistToSqr(localPly:GetPos()) > 30000 then return end

	if self:GetIsPlaced() then
		self:Draw3D2DDefence()
	else
		PIXEL.DrawEntOverhead(self, "Tier " .. self.DefenceTier .. " Defence")
	end
end

local frontAngs = {Angle(0, 0, 90), Angle(0, 90, 90)}
local backAngs = {Angle(0, 180, 90), Angle(0, 270, 90)}
local subtextOffset = Vector(0, 0, -1.4)

function ENT:Draw3D2DDefence()
	local min, max = self:GetModelBounds()

	local tText = "Tier " .. self.DefenceTier .. " Defence"
	local hText = "Health: " .. self:GetDefenceHealth()

	if self:GetIsBuilding() then
		hText = "Building: " .. tostring(math.Round((self:GetDefenceHealth() / self.DefenceMaxHP) * 100)) .. "%"
	end

	local pos = Vector(0, 0, 0)
	if self.RotateText then
		pos.y = pos.y + min.y
		pos.z = pos.z + (max.z * 0.5)
		pos = pos + self.UIOffset

		PIXEL.DrawEntOverhead(self, tText, frontAngs[1], pos)
		PIXEL.DrawEntOverhead(self, hText, frontAngs[1], pos + subtextOffset, .02)
	else
		pos.x = pos.x + max.x
		pos.z = pos.z + (max.z * 0.5)
		pos = pos + self.UIOffset

		PIXEL.DrawEntOverhead(self, tText, frontAngs[2], pos)
		PIXEL.DrawEntOverhead(self, hText, frontAngs[2], pos + subtextOffset, .02)
	end

	if self.RotateText then
		pos = Vector(0, 0, 0)
		pos.x = self.UIOffset.x
		pos.y = (pos.y + max.y) - self.UIOffset.y
		pos.z = (pos.z + (max.z * 0.5)) + self.UIOffset.z

		PIXEL.DrawEntOverhead(self, tText, backAngs[1], pos)
		PIXEL.DrawEntOverhead(self, hText, backAngs[1], pos + subtextOffset, .02)
		--pos = self:LocalToWorld(pos)
	else
		pos = Vector(0, 0, 0)
		pos.x = pos.x + min.x
		pos.z = pos.z + (max.z * 0.5)
		pos = pos - self.UIOffset

		PIXEL.DrawEntOverhead(self, tText, backAngs[2], pos)
		PIXEL.DrawEntOverhead(self, hText, backAngs[2], pos + subtextOffset, .02)
	end
end

local progressMat = Material("models/effects/comball_tape")
function ENT:DrawSpawning()
	self.BuildProgress = Lerp(FrameTime(), self.BuildProgress, self:GetDefenceHealth())

	local progress = self.BuildProgress / self.DefenceMaxHP

	render.MaterialOverride(progressMat)
	render.SetColorModulation(PIXEL.LerpColor(progress, PIXEL.Colors.Negative, PIXEL.Colors.Positive):ToVector():Unpack())

	self:DrawModel()

	render.MaterialOverride()

	self.Height = self.MaxHeight * progress

	render.SetColorModulation(1, 1, 1)
	render.MaterialOverride()

	local normal = -self:GetAngles():Up()
	local pos = self:LocalToWorld(Vector(0, 0, self:OBBMins().z + self.Height))
	local distance = normal:Dot(pos)
	render.EnableClipping(true)
	render.PushCustomClipPlane(normal, distance)

	self:DrawModel()

	render.PopCustomClipPlane()
end