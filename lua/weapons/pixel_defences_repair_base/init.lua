
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

SWEP.NextUse = 0

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	if CurTime() < self.NextUse then return end

	local lookingAtEnt = PIXEL.Defences.GetLookingAtEnt(self:GetOwner())
	if not lookingAtEnt then return end

	local newhealth = lookingAtEnt:GetDefenceHealth() + 1
	if newhealth > lookingAtEnt.DefenseHP then return end

	lookingAtEnt:SetDefenceHealth(newhealth)

	self.NextUse = CurTime() + self.HealSpeed
end