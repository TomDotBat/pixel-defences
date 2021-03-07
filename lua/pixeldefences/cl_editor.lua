
if not PIXEL.Defences.Editor then
    PIXEL.Defences.Editor = {}
    PIXEL.Defences.Editor.IsEditing = false
    PIXEL.Defences.Editor.Yaw = 0
    PIXEL.Defences.Editor.CurBox = nil
    PIXEL.Defences.Editor.GhostProp = nil
    PIXEL.Defences.Editor.ValidPlacement = false
end

hook.Add("HUDShouldDraw", "PIXEL.Defences.PreventWeaponSelect", function(name)
    if (name == "CHudWeaponSelection" and PIXEL.Defences.Editor.IsEditing) then return false end
end)

hook.Add( "CreateMove", "PIXEL.Defences.RotateWithScroller", function()
    if (PIXEL.Defences.Editor.IsEditing) then
        if (input.WasMousePressed(MOUSE_WHEEL_UP)) then
            PIXEL.Defences.Editor.Yaw = PIXEL.Defences.Editor.Yaw + 5
            if (PIXEL.Defences.Editor.Yaw > 360) then PIXEL.Defences.Editor.Yaw = 5 end
        elseif (input.WasMousePressed(MOUSE_WHEEL_DOWN)) then
            PIXEL.Defences.Editor.Yaw = PIXEL.Defences.Editor.Yaw - 5
            if (PIXEL.Defences.Editor.Yaw < 0) then PIXEL.Defences.Editor.Yaw = 355 end
        end

        if (input.WasMousePressed(MOUSE_LEFT) and PIXEL.Defences.Editor.ValidPlacement) then
            net.Start("PIXEL.Defences.FinishEditing")
             net.WriteEntity(PIXEL.Defences.Editor.CurBox)
             net.WriteUInt(PIXEL.Defences.Editor.Yaw, 9)
            net.SendToServer()

            PIXEL.Defences.Editor.IsEditing = false
        elseif (input.WasMousePressed(MOUSE_RIGHT)) then
            net.Start("PIXEL.Defences.AbortEditing")
             net.WriteEntity(PIXEL.Defences.Editor.CurBox)
            net.SendToServer()

            PIXEL.Defences.Editor.IsEditing = false
        end      
    end
end )

hook.Add("Think", "PIXEL.Defences.UpdateGhost", function()
    if (!PIXEL.Defences.Editor.IsEditing) then 
        if (IsValid(PIXEL.Defences.Editor.GhostProp)) then
            PIXEL.Defences.Editor.GhostProp:Remove()

            PIXEL.Defences.Editor.CurBox = nil
            PIXEL.Defences.Editor.GhostProp = nil
        end
        return
    end

    if (not IsValid(PIXEL.Defences.Editor.GhostProp)) then
        PIXEL.Defences.Editor.GhostProp = ClientsideModel(PIXEL.Defences.Editor.CurBox.DefenseModel, RENDERGROUP_STATIC)
        PIXEL.Defences.Editor.GhostProp:SetMaterial("models/wireframe")
    end

    local pos, ang = PIXEL.Defences.GetPlacementPos(PIXEL.Defences.Editor.GhostProp, LocalPlayer(), PIXEL.Defences.Editor.CurBox.Max)

    if (!pos) then
        --PIXEL.Defences.Editor.GhostProp:SetNoDraw(true)
        PIXEL.Defences.Editor.GhostProp:SetColor(Color(255, 0, 0))
        PIXEL.Defences.Editor.ValidPlacement = false
        return
    end

    ang.Yaw = PIXEL.Defences.Editor.Yaw

    PIXEL.Defences.Editor.GhostProp:SetColor(Color(255, 255, 255))
    PIXEL.Defences.Editor.GhostProp:SetAngles(ang)
    PIXEL.Defences.Editor.GhostProp:SetPos(pos)
    PIXEL.Defences.Editor.GhostProp:SetNoDraw(false)
    PIXEL.Defences.Editor.ValidPlacement = true
end)

net.Receive("PIXEL.Defences.StartEditing", function(len, ply)
    PIXEL.Defences.Editor.CurBox = net.ReadEntity()
    PIXEL.Defences.Editor.IsEditing = true
end)

net.Receive("PIXEL.Defences.AbortEditing", function(len, ply)
    PIXEL.Defences.Editor.IsEditing = false
    PIXEL.Defences.Editor.CurBox = nil
end)

net.Receive("PIXEL.Defences.AbortEditing2", function(len, ply)
    net.Start("PIXEL.Defences.AbortEditing")
     net.WriteEntity(PIXEL.Defences.Editor.CurBox)
    net.SendToServer()
end)

net.Receive("PIXEL.Defences.FinishEditing", function(len, ply)
    PIXEL.Defences.Editor.IsEditing = false
    PIXEL.Defences.Editor.CurBox = nil
end)