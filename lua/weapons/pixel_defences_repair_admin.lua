
AddCSLuaFile()

SWEP.Base = "pixel_defences_repair_base"
SWEP.PrintName = "Admin Defence Repair Tool"
SWEP.Category = "PIXEL Defences"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.UseHands = false
SWEP.Primary.Automatic = false

if CLIENT then return end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end

    local lookingAtEnt = PIXEL.Defences.GetLookingAtEnt(self:GetOwner())
    if not lookingAtEnt then return end
    
    lookingAtEnt:SetDefenceHealth(lookingAtEnt.DefenseHP)
end