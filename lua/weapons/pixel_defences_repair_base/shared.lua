
AddCSLuaFile()

SWEP.PrintName = "Defence Repair Tool"
SWEP.Category = "PIXEL Defences"
SWEP.Author = "Tom.bat"

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.Spawnable = false
SWEP.AdminOnly = false

SWEP.ViewModelFlip = false
SWEP.UseHands = false

SWEP.Weight = 1
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.CurHealth = 0
SWEP.HealRate = 0.1

function SWEP:Initialize()
    self:SetHoldType("idle")
end