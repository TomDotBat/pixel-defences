function oglbdSetDefensePos(prop, ply, isMax)
    local tr = ply:GetEyeTrace()
    if (not tr.Hit) then        
        return false
    elseif (IsValid(tr.Entity)) then
        if (tr.Entity:GetClass() != "prop_physics") then
            return false
        end
    end

    local angles = tr.HitNormal:Angle()
    if !(angles.pitch > 10) then
        return false
    elseif !(angles.pitch < 350) then
        return false
    end

    angles.pitch = 0
    angles.roll = 0

    local min, max = prop:GetModelBounds()
    local pos = tr.HitPos

    if (isMax) then
        pos.z = pos.z + max.z
    else
        pos.z = pos.z + min.z
    end
    
    local dist = pos:Distance(ply:GetPos())

    if (dist > 400) then
    	return false
    elseif (dist < 65) then
        return false
    end

    return pos, angles
end