
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
    if not IsValid(phys) then return end
    phys:Wake()
end

function ENT:SetupDefence()
    self:PhysicsDestroy()
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if not IsValid(phys) then return end

    phys:Wake()
    phys:EnableMotion(false)
end

function ENT:Build()
    if not self:GetIsBuilding() then return end
    self:SetDefenceHealth(self:GetDefenceHealth() + 1)

    if self:GetDefenceHealth() >= self.DefenceMaxHP then
        self:SetIsBuilding(false)
        return
    end

    timer.Simple(self.DefenceBuildTime / self.DefenceMaxHP, function()
        if not IsValid(self) then return end
        self:Build()
    end)
end

function ENT:OnTakeDamage(dmgInfo)
    if not self:GetIsPlaced() then return end

    local newHealth = self:GetDefenceHealth() - math.Round(dmgInfo:GetDamage())
    self:SetDefenceHealth(newHealth)

    if newHealth < 1 then self:Remove() end
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
    if self:GetDefenceHealth() < self.DefenceMaxHP then return end
    self:SetDefenceHealth(self.DefenceMaxHP)
end