
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

local traceData = {}
local maxDist = 150

function PIXEL.Defences.GetLookingAtEnt(ply)
    traceData["filter"] = ply
    traceData["start"] = ply:EyePos()
    traceData["endpos"] = traceData["start"] + ply:EyeAngles():Forward() * maxDist

    local tr = util.TraceLine(traceData)
    local ent = tr.Entity

    if not IsValid(ent) then return end
    if not string.StartWith(ent:GetClass(), "pixel_defence") then return end
    if not ent:GetIsPlaced() then return end

    return ent, tr.HitPos
end

function PIXEL.Defences.GetPlacementPos(prop, ply, isMax)
    local tr = ply:GetEyeTrace()
    if not tr.Hit then
        return false
    elseif IsValid(tr.Entity) then
        if tr.Entity:GetClass() ~= "prop_physics" then
            return false
        end
    end

    local angles = tr.HitNormal:Angle()
    if angles.pitch < 10 then
        return false
    elseif angles.pitch > 350 then
        return false
    end

    angles.pitch = 0
    angles.roll = 0

    local min, max = prop:GetModelBounds()
    local pos = tr.HitPos

    if isMax then pos.z = pos.z + max.z
    else pos.z = pos.z + min.z end

    local dist = pos:Distance(ply:GetPos())
    if dist > 400 then
    	return false
    elseif dist < 65 then
        return false
    end

    return pos, angles
end