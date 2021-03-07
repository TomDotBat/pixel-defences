
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

function SWEP:DrawHUD()
    if not PIXEL.Defences.Editor.IsEditing then return end

    local col = PIXEL.Defences.Editor.ValidPlacement and PIXEL.Colors.PrimaryText or PIXEL.Colors.Negative
    local text = "Placing Tier " .. PIXEL.Defences.Editor.CurBox.DefenseTier .. " Defence"

    surface.SetFont("oglDefenseHudTitle")
    surface.SetTextColor(col)
    local w, h = surface.GetTextSize(text)
    surface.SetTextPos((ScrW() / 2) - (w / 2), (ScrH() * 0.99) - 150)
    surface.DrawText(text)
    draw.RoundedBox(0, (ScrW() / 2) - (w / 2), (ScrH() * 0.99) - h * 2, w, 5, col)
    text = "Rotation: " .. PIXEL.Defences.Editor.Yaw .. "°"
    surface.SetFont("oglDefenseHudSubTitle")
    w, h = surface.GetTextSize(text)
    surface.SetTextPos((ScrW() / 2) - (w / 2), (ScrH() * 0.99) - 90)
    surface.DrawText(text)
    surface.SetTextColor(255, 255, 255)
    text = "Left Click: Place"
    surface.SetFont("oglDefenseHudHint")
    w, h = surface.GetTextSize(text)
    surface.SetTextPos((ScrW() / 2) - (w / 2) - 200, ScrH() - h)
    surface.DrawText(text)
    text = "Right Click: Cancel"
    surface.SetFont("oglDefenseHudHint")
    w, h = surface.GetTextSize(text)
    surface.SetTextPos((ScrW() / 2) - (w / 2), ScrH() - h)
    surface.DrawText(text)
    text = "Scroll: Rotate"
    surface.SetFont("oglDefenseHudHint")
    w, h = surface.GetTextSize(text)
    surface.SetTextPos((ScrW() / 2) - (w / 2) + 200, ScrH() - h)
    surface.DrawText(text)
end