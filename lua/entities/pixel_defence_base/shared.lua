
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

ENT.DefenceTier = 0
ENT.DefenceMaxHP = 1
ENT.DefenceBuildTime = 30
ENT.DefenceModel = "models/props_c17/fence01b.mdl"

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