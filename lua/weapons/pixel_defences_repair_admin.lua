
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

    lookingAtEnt:SetDefenceHealth(lookingAtEnt.DefenceMaxHP)
end