
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

net.Receive("PIXEL.Defences.AbortEditing", function(len, ply)
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end

    if ply ~= ent:CPPIGetOwner() then return end

    ent:SetIsPlacing(false)
    ent:SetMaterial(ent.OriginalMaterial)

    net.Start("PIXEL.Defences.AbortEditing")
    net.Send(ply)

    ply:StripWeapon("pixel_defences_editor")

    PIXEL.Defences.EditingPlayers[ply:SteamID64()] = false
end)

net.Receive("PIXEL.Defences.FinishEditing", function(len, ply)
    local ent = net.ReadEntity()

    if not IsValid(ent) then return end
    if not ent:GetIsPlacing() then return end
    if ply ~= ent:CPPIGetOwner() then return end

    ent:SetModel(ent.DefenceModel)

    local pos, ang = PIXEL.Defences.GetPlacementPos(ent, ply, ent.Max)
    if not pos then
        ent:SetIsPlacing(false)
        ent:SetModel(ent.BoxModel)
        ent:SetMaterial(ent.OriginalMaterial)

        PIXEL.Defences.EditingPlayers[ply:SteamID64()] = false
        return
    end

    ang.Yaw = net.ReadUInt(9)

    ent:SetPos(pos)
    ent:SetAngles(ang)

    ent:SetIsPlacing(false)
    ent:SetIsPlaced(true)
    ent:SetIsBuilding(true)

    ent:SetModel(ent.DefenceModel)
    ent:SetMaterial(ent.OriginalMaterial)

    ent:SetupDefence()
    ent:Build()

    net.Start("PIXEL.Defences.FinishEditing")
    net.Send(ply)

    ply:StripWeapon("pixel_defences_editor")

    PIXEL.Defences.EditingPlayers[ply:SteamID64()] = false
end)

hook.Add("playerBoughtCustomEntity", "PIXEL.Defences.SetOwner", function(ply, entTable, ent, price)
    if (string.StartWith(ent:GetClass(), "pixel_defence")) then
        ent:CPPISetOwner(ply)
    end
end)

hook.Add("PlayerDeath", "PIXEL.Defences.AbortOnDeath", function(ply, a, b)
    net.Start("PIXEL.Defences.AbortEditing2")
    net.Send(ply)
end)

hook.Add("PhysgunPickup", "PIXEL.Defences.PreventPickupWhileEditing", function(ply, ent)
    if not string.StartWith(ent:GetClass(), "pixel_defence") then return end
    if not ent:GetIsPlaced() then return end
    if not ply:IsAdmin() then return false end
end)

util.AddNetworkString("PIXEL.Defences.StartEditing")
util.AddNetworkString("PIXEL.Defences.AbortEditing")
util.AddNetworkString("PIXEL.Defences.AbortEditing2")
util.AddNetworkString("PIXEL.Defences.FinishEditing")