
--[[
    PIXEL Defences
    Copyright (C) 2021 Tom O'Sullivan (Tom.bat)
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]

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

	local pos, ang = Vector(0, 0, 0)
	if self.RotateText then
		pos.y = pos.y + min.y
		pos.z = pos.z + (max.z * 0.5)
		pos = pos + self.UIOffset

		ang = frontAngs[1]
	else
		pos.x = pos.x + max.x
		pos.z = pos.z + (max.z * 0.5)
		pos = pos + self.UIOffset

		ang = frontAngs[2]
	end

	local eyePos = localPly:EyePos()
	local posDiff = self:LocalToWorld(pos) - eyePos
	if posDiff:Dot(self:LocalToWorldAngles(ang):Up()) < 0 then
		PIXEL.DrawEntOverhead(self, tText, ang, pos)
		PIXEL.DrawEntOverhead(self, hText, ang, pos + subtextOffset, .02)
	end

	if self.RotateText then
		pos = Vector(0, 0, 0)
		pos.x = self.UIOffset.x
		pos.y = (pos.y + max.y) - self.UIOffset.y
		pos.z = (pos.z + (max.z * 0.5)) + self.UIOffset.z

		ang = backAngs[1]
	else
		pos = Vector(0, 0, 0)
		pos.x = pos.x + min.x
		pos.z = pos.z + (max.z * 0.5)
		pos = pos - self.UIOffset

		ang = backAngs[2]
	end

	posDiff = self:LocalToWorld(pos) - eyePos
	if posDiff:Dot(self:LocalToWorldAngles(ang):Up()) > 0 then return end

	PIXEL.DrawEntOverhead(self, tText, ang, pos)
	PIXEL.DrawEntOverhead(self, hText, ang, pos + subtextOffset, .02)
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