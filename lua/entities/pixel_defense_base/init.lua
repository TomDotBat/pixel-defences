
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

PIXEL.Defences.EditingPlayers = {}

function ENT:Initialize()
    self:SetModel(self.BoxModel)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    
    self.OriginalMaterial = self:GetMaterial()

    local phys = self:GetPhysicsObject()

    if (phys:IsValid()) then
        phys:Wake()
    end
end

function ENT:SetupDefense()
    self:PhysicsDestroy()
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
    phys:EnableMotion(false)

    if (phys:IsValid()) then
        phys:Wake()
    end
end

function ENT:Build()
    if not self:GetIsBuilding() then return end
    self:SetDefenceHealth(self:GetDefenceHealth() + 1)

    if (self:GetDefenceHealth() >= self.DefenseHP) then
        self:SetIsBuilding(false)

        return
    end

    timer.Simple(self.DefenseBuildTime / self.DefenseHP, function()
        self:Build()
    end)
end

function ENT:OnTakeDamage(dmginfo)
    if self:GetIsPlaced() then
        local newHealth = self:GetDefenceHealth() - math.Round(dmginfo:GetDamage())
        self:SetDefenceHealth(newHealth)

        if (newHealth < 1) then
            self:Remove()
        end
    end
end

function ENT:Use(ply)
    if ply ~= self:CPPIGetOwner() then return end
    if self:GetIsPlacing() or self:GetIsPlaced() then return end
    if PIXEL.Defences.EditingPlayers[ply:SteamID64()] then return end

    self:SetIsPlacing(true)

    net.Start("PIXEL.Defences.StartEditing")
     net.WriteEntity(self)
    net.Send(ply)

    ply:Give("pixel_defences_editor")
    ply:SelectWeapon("pixel_defences_editor")

    PIXEL.Defences.EditingPlayers[ply:SteamID64()] = true
end

function ENT:Think()
    if self:GetDefenceHealth() > self.DefenseHP then
        self:SetDefenceHealth(self.DefenseHP)
    end
end