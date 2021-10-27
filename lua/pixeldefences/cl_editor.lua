
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

local editor = PIXEL.Defences.Editor or {Yaw = 0}
PIXEL.Defences.Editor = editor

hook.Add("HUDShouldDraw", "PIXEL.Defences.PreventWeaponSelect", function(name)
    if name == "CHudWeaponSelection" and editor.IsEditing then return false end
end)

hook.Add("CreateMove", "PIXEL.Defences.RotateWithScroller", function()
    if not editor.IsEditing then return end

    if input.WasMousePressed(MOUSE_WHEEL_UP) then
        editor.Yaw = editor.Yaw + 5
        if editor.Yaw > 360 then editor.Yaw = 5 end
    elseif input.WasMousePressed(MOUSE_WHEEL_DOWN) then
        editor.Yaw = editor.Yaw - 5
        if editor.Yaw < 0 then editor.Yaw = 355 end
    end

    if input.WasMousePressed(MOUSE_LEFT) and editor.ValidPlacement then
        net.Start("PIXEL.Defences.FinishEditing")
         net.WriteEntity(editor.CurBox)
         net.WriteUInt(editor.Yaw, 9)
        net.SendToServer()

        editor.IsEditing = false
    elseif input.WasMousePressed(MOUSE_RIGHT) then
        net.Start("PIXEL.Defences.AbortEditing")
         net.WriteEntity(editor.CurBox)
        net.SendToServer()

        editor.IsEditing = false
    end
end)

hook.Add("Think", "PIXEL.Defences.UpdateGhost", function()
    if not editor.IsEditing then
        if IsValid(editor.GhostProp) then
            editor.GhostProp:Remove()

            editor.CurBox = nil
            editor.GhostProp = nil
        end
        return
    end

    if not IsValid(editor.GhostProp) then
        editor.GhostProp = ClientsideModel(editor.CurBox.DefenceModel, RENDERGROUP_STATIC)
        editor.GhostProp:SetMaterial("models/wireframe")
    end

    local pos, ang = PIXEL.Defences.GetPlacementPos(editor.GhostProp, LocalPlayer(), editor.CurBox.Max)
    if not pos then
        editor.GhostProp:SetColor(PIXEL.Colors.Negative)
        editor.ValidPlacement = false
        return
    end

    ang.Yaw = editor.Yaw

    editor.GhostProp:SetColor(color_white)
    editor.GhostProp:SetAngles(ang)
    editor.GhostProp:SetPos(pos)
    editor.GhostProp:SetNoDraw(false)
    editor.ValidPlacement = true
end)

net.Receive("PIXEL.Defences.StartEditing", function(len, ply)
    editor.CurBox = net.ReadEntity()
    editor.IsEditing = true
end)

net.Receive("PIXEL.Defences.AbortEditing", function(len, ply)
    editor.IsEditing = false
    editor.CurBox = nil
end)

net.Receive("PIXEL.Defences.AbortEditing2", function(len, ply)
    net.Start("PIXEL.Defences.AbortEditing")
     net.WriteEntity(editor.CurBox)
    net.SendToServer()
end)

net.Receive("PIXEL.Defences.FinishEditing", function(len, ply)
    editor.IsEditing = false
    editor.CurBox = nil
end)