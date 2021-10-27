
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

SWEP.PrintName = "Editor"
SWEP.Category = "PIXEL Defences"
SWEP.Author = "Tom.bat"
SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.Spawnable = false
SWEP.AdminOnly = false

SWEP.UseHands = false
SWEP.ViewModelFlip = false
SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.Weight = 1
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
    self:SetHoldType("idle")
end

if SERVER then return end

function SWEP:Think()
    if not self.Cancelled and self:GetOwner():InVehicle() then
        net.Start("PIXEL.Defences.AbortEditing")
         net.WriteEntity(PIXEL.Defences.Editor.CurBox)
        net.SendToServer()

        self.Cancelled = true
    end
end

PIXEL.RegisterFont("Defences.EditorType", "Open Sans Bold", 40)
PIXEL.RegisterFont("Defences.EditorRotation", "Open Sans SemiBold", 34)
PIXEL.RegisterFont("Defences.EditorHint", "Open Sans SemiBold", 24)

function SWEP:DrawHUD()
    if not PIXEL.Defences.Editor.IsEditing then return end
    if not IsValid(PIXEL.Defences.Editor.CurBox) then return end

    local centerW = ScrW() * .5
    local textX = ScrH() * .8

    local _, textH = PIXEL.DrawSimpleText(
        "Placing Tier " .. PIXEL.Defences.Editor.CurBox.DefenceTier .. " Defence",
        "Defences.EditorType", centerW, textX,
        PIXEL.Defences.Editor.ValidPlacement and PIXEL.Colors.PrimaryText or PIXEL.Colors.Negative, TEXT_ALIGN_CENTER
    )
    textX = textX + textH + PIXEL.Scale(2)

    _, textH = PIXEL.DrawSimpleText(
        "Rotation: " .. PIXEL.Defences.Editor.Yaw .. "°",
        "Defences.EditorRotation", centerW, textX,
        PIXEL.Colors.Primary, TEXT_ALIGN_CENTER
    )
    textX = textX + textH + PIXEL.Scale(6)

    _, textH = PIXEL.DrawSimpleText(
        "Left Click: Place    Right Click: Cancel    Scroll: Rotate",
        "Defences.EditorHint", centerW, textX,
        PIXEL.Colors.SecondaryText, TEXT_ALIGN_CENTER
    )
end