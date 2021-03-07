
net.Receive("PIXEL.Defences.AbortEditing", function(len, ply)
    local ent = net.ReadEntity()

    if (ply == ent:CPPIGetOwner()) then
        ent:SetIsPlacing(false)
        ent:SetMaterial(ent.OriginalMaterial)
        net.Start("PIXEL.Defences.AbortEditing")
        net.Send(ply)

        ply:StripWeapon("pixel_defences_editor")
        PIXEL.Defences.EditingPlayers[ply:SteamID64()] = false
    end
end)

net.Receive("PIXEL.Defences.FinishEditing", function(len, ply)
    local ent = net.ReadEntity()
    local plyAng = net.ReadUInt(9)

    if not ent:GetIsPlacing() then return end

    if (ply == ent:CPPIGetOwner()) then
        ent:SetModel(ent.DefenseModel)
        local pos, ang = PIXEL.Defences.GetPlacementPos(ent, ply, ent.Max)
        if not pos then
            ent:SetIsPlacing(false)
            ent:SetModel(ent.BoxModel)
            ent:SetMaterial(ent.OriginalMaterial)
            PIXEL.Defences.EditingPlayers[ply:SteamID64()] = false
            return
        end

        ang.Yaw = plyAng

        ent:SetPos(pos)
        ent:SetAngles(ang)

        ent:SetIsPlacing(false)
        ent:SetIsPlaced(true)
        ent:SetIsBuilding(true)

        ent:SetModel(ent.DefenseModel)
        ent:SetMaterial(ent.OriginalMaterial)

        ent:SetupDefense()
        ent:Build()

        net.Start("PIXEL.Defences.FinishEditing")
        net.Send(ply)

        ply:StripWeapon("pixel_defences_editor")
        PIXEL.Defences.EditingPlayers[ply:SteamID64()] = false
    end
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