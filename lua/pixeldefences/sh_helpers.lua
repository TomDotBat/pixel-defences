
local traceData = {}
local maxDist = 150

function PIXEL.Defences.GetLookingAtEnt(ply)
    traceData["filter"] = ply
    traceData["start"] = ply:EyePos()
    traceData["endpos"] = traceData["start"] + ply:EyeAngles():Forward() * maxDist

    local tr = util.TraceLine(traceData).HitPos
    local ent = tr.Entity

    if not IsValid(ent) then return end
    if not string.StartWith(ent:GetClass(), "pixel_defence") then return end
    if not ent:GetIsPlaced() then return end

    return ent
end