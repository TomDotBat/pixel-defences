
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

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

SWEP.NextUse = 0

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	if CurTime() < self.NextUse then return end

	local lookingAtEnt = PIXEL.Defences.GetLookingAtEnt(self:GetOwner())
	if not lookingAtEnt then return end

	local newHealth = lookingAtEnt:GetDefenceHealth() + 1
	if newHealth > lookingAtEnt.DefenceMaxHP then return end

	lookingAtEnt:SetDefenceHealth(newHealth)

	self.NextUse = CurTime() + self.HealRate
end