
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