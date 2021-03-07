
if (!oglbdeditor) then
    oglbdeditor = {}
    oglbdeditor.isEditing = false
    oglbdeditor.yaw = 0
    oglbdeditor.curBox = nil
    oglbdeditor.ghostProp = nil
    oglbdeditor.validPlacement = false
end

hook.Add("HUDShouldDraw", "oglbasedefense_hideweaponselect", function(name)
    if (name == "CHudWeaponSelection" and oglbdeditor.isEditing) then return false end
end)

hook.Add( "CreateMove", "oglbasedefense_scrollrotate", function()
    if (oglbdeditor.isEditing) then
        if (input.WasMousePressed(MOUSE_WHEEL_UP)) then
            oglbdeditor.yaw = oglbdeditor.yaw + 5
            if (oglbdeditor.yaw > 360) then oglbdeditor.yaw = 5 end
        elseif (input.WasMousePressed(MOUSE_WHEEL_DOWN)) then
            oglbdeditor.yaw = oglbdeditor.yaw - 5
            if (oglbdeditor.yaw < 0) then oglbdeditor.yaw = 355 end
        end

        if (input.WasMousePressed(MOUSE_LEFT) and oglbdeditor.validPlacement) then
            net.Start("PIXEL.Defences.FinishEditing")
             net.WriteEntity(oglbdeditor.curBox)
             net.WriteUInt(oglbdeditor.yaw, 9)
            net.SendToServer()

            oglbdeditor.isEditing = false
        elseif (input.WasMousePressed(MOUSE_RIGHT)) then
            net.Start("PIXEL.Defences.AbortEditing")
             net.WriteEntity(oglbdeditor.curBox)
            net.SendToServer()

            oglbdeditor.isEditing = false
        end      
    end
end )

hook.Add("Think", "oglbasedefense_think", function()
    if (!oglbdeditor.isEditing) then 
        if (IsValid(oglbdeditor.ghostProp)) then
            oglbdeditor.ghostProp:Remove()

            oglbdeditor.curBox = nil
            oglbdeditor.ghostProp = nil
        end
        return
    end

    if (not IsValid(oglbdeditor.ghostProp)) then
        oglbdeditor.ghostProp = ClientsideModel(oglbdeditor.curBox.DefenseModel, RENDERGROUP_STATIC)
        oglbdeditor.ghostProp:SetMaterial("models/wireframe")
    end

    local pos, ang = oglbdSetDefensePos(oglbdeditor.ghostProp, LocalPlayer(), oglbdeditor.curBox.Max)

    if (!pos) then
        --oglbdeditor.ghostProp:SetNoDraw(true)
        oglbdeditor.ghostProp:SetColor(Color(255, 0, 0))
        oglbdeditor.validPlacement = false
        return
    end

    ang.yaw = oglbdeditor.yaw

    oglbdeditor.ghostProp:SetColor(Color(255, 255, 255))
    oglbdeditor.ghostProp:SetAngles(ang)
    oglbdeditor.ghostProp:SetPos(pos)
    oglbdeditor.ghostProp:SetNoDraw(false)
    oglbdeditor.validPlacement = true
end)

net.Receive("PIXEL.Defences.StartEditing", function(len, ply)
    oglbdeditor.curBox = net.ReadEntity()
    oglbdeditor.isEditing = true
end)

net.Receive("PIXEL.Defences.AbortEditing", function(len, ply)
    oglbdeditor.isEditing = false
    oglbdeditor.curBox = nil
end)

net.Receive("PIXEL.Defences.AbortEditing2", function(len, ply)
    net.Start("PIXEL.Defences.AbortEditing")
     net.WriteEntity(oglbdeditor.curBox)
    net.SendToServer()
end)

net.Receive("PIXEL.Defences.FinishEditing", function(len, ply)
    oglbdeditor.isEditing = false
    oglbdeditor.curBox = nil
end)