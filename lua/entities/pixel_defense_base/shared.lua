
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Defence Base"
ENT.Category = "PIXEL Defences"
ENT.Author = "Tom.bat"
ENT.Contact = "tom@tomdotbat.dev"
ENT.Purpose = "Used for defending your base."
ENT.Instructions = "Press E on the box and place the defence where you want it."

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.IsPIXELDefence = true

ENT.BoxModel = "models/props_junk/wood_crate001a.mdl"

ENT.DefenseTier = 0
ENT.DefenseHP = 1
ENT.DefenseBuildTime = 30
ENT.DefenseModel = "models/props_c17/fence01b.mdl"

ENT.Max = true
ENT.RotateText = false
ENT.MaxHeight = 100
ENT.UIOffset = Vector(0, 0, 0)

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsPlaced")
    self:NetworkVar("Bool", 1, "IsBuilding")
    self:NetworkVar("Bool", 2, "IsPlacing")
    self:NetworkVar("Int", 0, "DefenceHealth")

    if SERVER then
        self:SetIsPlaced(false)
        self:SetIsBuilding(false)
        self:SetIsPlacing(false)
        self:SetDefenceHealth(1)
    end
end