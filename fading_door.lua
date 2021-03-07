TOOL.Category = "Construction"
TOOL.Name = "#Fading Doors"

TOOL.ClientConVar["key"] = "41"
TOOL.ClientConVar["swap"] = "0"
TOOL.ClientConVar["reversed"] = "0"
TOOL.ClientConVar["mat"] = "sprites/heatwave"
TOOL.ClientConVar["opensound"] = "0"
TOOL.ClientConVar["loopsound"] = "0"
TOOL.ClientConVar["closesound"] = "0"

list.Add("FDoorMaterials", "sprites/heatwave")
list.Add("FDoorMaterials", "models/wireframe")
list.Add("FDoorMaterials", "debug/env_cubemap_model")
list.Add("FDoorMaterials", "models/shadertest/shader3")
list.Add("FDoorMaterials", "models/shadertest/shader4")
list.Add("FDoorMaterials", "models/shadertest/shader5")
list.Add("FDoorMaterials", "models/shiny")
list.Add("FDoorMaterials", "models/debug/debugwhite")
list.Add("FDoorMaterials", "Models/effects/comball_sphere")
list.Add("FDoorMaterials", "Models/effects/comball_tape")
list.Add("FDoorMaterials", "Models/effects/splodearc_sheet")
list.Add("FDoorMaterials", "Models/effects/vol_light001")
list.Add("FDoorMaterials", "models/props_combine/stasisshield_sheet")
list.Add("FDoorMaterials", "models/props_combine/portalball001_sheet")
list.Add("FDoorMaterials", "models/props_combine/com_shield001a")
list.Add("FDoorMaterials", "models/props_c17/frostedglass_01a")
list.Add("FDoorMaterials", "models/props_lab/Tank_Glass001")
list.Add("FDoorMaterials", "models/props_combine/tprings_globe")
list.Add("FDoorMaterials", "models/rendertarget")
list.Add("FDoorMaterials", "models/screenspace")
list.Add("FDoorMaterials", "brick/brick_model")
list.Add("FDoorMaterials", "models/props_pipes/GutterMetal01a")
list.Add("FDoorMaterials", "models/props_pipes/Pipesystem01a_skin3")
list.Add("FDoorMaterials", "models/props_wasteland/wood_fence01a")
list.Add("FDoorMaterials", "models/props_foliage/tree_deciduous_01a_trunk")
list.Add("FDoorMaterials", "models/props_c17/FurnitureFabric003a")
list.Add("FDoorMaterials", "models/props_c17/FurnitureMetal001a")
list.Add("FDoorMaterials", "models/props_c17/paper01")
list.Add("FDoorMaterials", "models/flesh")

if SERVER then
	util.AddNetworkString("DrawFadeDoor")
end

local Sounds = {}
--[[
Sounds[1] = Sound("doors/doorstop1.wav")
Sounds[2] = Sound("npc/turret_floor/retract.wav")
Sounds[3] = Sound("npc/roller/mine/combine_mine_deactivate1.wav")
Sounds[4] = Sound("npc/roller/mine/combine_mine_deploy1.wav")
Sounds[5] = Sound("npc/roller/mine/rmine_taunt1.wav")
Sounds[6] = Sound("npc/scanner/scanner_nearmiss2.wav")
Sounds[7] = Sound("npc/scanner/scanner_siren1.wav")
Sounds[8] = Sound("npc/barnacle/barnacle_gulp1.wav")
Sounds[9] = Sound("npc/barnacle/barnacle_gulp2.wav")
Sounds[10] = Sound("npc/combine_gunship/attack_start2.wav")
Sounds[11] = Sound("npc/combine_gunship/attack_stop2.wav")
Sounds[12] = Sound("npc/dog/dog_pneumatic1.wav")
Sounds[13] = Sound("npc/dog/dog_pneumatic2.wav")

util.PrecacheSound(Sounds[1])
util.PrecacheSound(Sounds[2])
util.PrecacheSound(Sounds[3])
util.PrecacheSound(Sounds[4])
util.PrecacheSound(Sounds[5])
util.PrecacheSound(Sounds[6])
util.PrecacheSound(Sounds[7])
util.PrecacheSound(Sounds[8])
util.PrecacheSound(Sounds[9])
util.PrecacheSound(Sounds[10])
util.PrecacheSound(Sounds[11])
util.PrecacheSound(Sounds[12])
util.PrecacheSound(Sounds[13])
]]

local LoopSounds = {}
--[[
LoopSounds[1] = "ambient/machines/machine6.wav"
LoopSounds[2] = "ambient/energy/force_field_loop1.wav"
LoopSounds[3] = "physics/metal/canister_scrape_smooth_loop1.wav"
LoopSounds[4] = "ambient/levels/citadel/citadel_drone_loop5.wav"
LoopSounds[5] = "ambient/levels/citadel/citadel_drone_loop6.wav"
LoopSounds[6] = "ambient/atmosphere/city_rumble_loop1.wav"
LoopSounds[7] = "ambient/machines/city_ventpump_loop1.wav"
LoopSounds[8] = "ambient/machines/combine_shield_loop3.wav"
LoopSounds[9] = "npc/manhack/mh_engine_loop1.wav"
LoopSounds[10] = "npc/manhack/mh_engine_loop2.wav"
]]

if CLIENT then
	language.Add("Tool.fading_door.name", "Fading Doors")
	language.Add("Tool.fading_door.desc", "Makes anything into a fadable door")
	language.Add("Tool.fading_door.0", "Click on something to make it a fading door. Right click to copy data. Reload to remove fading door.")
	
	function TOOL:BuildCPanel()
		self:AddControl("Header",   {Text = "#Tool.fading_door.name", Description = "#Tool.fading_door.desc"})
		self:AddControl("CheckBox", {Label = "Reversed", Command = "fading_door_reversed"})
		self:AddControl("CheckBox", {Label = "Toggle Active", Command = "fading_door_swap"})
		
		local DoorOpenSound = vgui.Create("CtrlListBox", self)
		DoorOpenSound:AddOption("None", {fading_door_opensound = "0"})
		--[[
		if file.Exists("sound/doors/doorstop1.wav", "GAME") then DoorOpenSound:AddOption("1", {fading_door_opensound = "1"}) end
		if file.Exists("sound/npc/turret_floor/retract.wav", "GAME") then DoorOpenSound:AddOption("2", {fading_door_opensound = "2"}) end
		if file.Exists("sound/npc/roller/mine/combine_mine_deactivate1.wav", "GAME") then DoorOpenSound:AddOption("3", {fading_door_opensound = "3"}) end
		if file.Exists("sound/npc/roller/mine/combine_mine_deploy1.wav", "GAME") then DoorOpenSound:AddOption("4", {fading_door_opensound = "4"}) end
		if file.Exists("sound/npc/roller/mine/rmine_taunt1.wav", "GAME") then DoorOpenSound:AddOption("5", {fading_door_opensound = "5"}) end
		if file.Exists("sound/npc/scanner/scanner_nearmiss2.wav", "GAME") then DoorOpenSound:AddOption("6", {fading_door_opensound = "6"}) end
		if file.Exists("sound/npc/scanner/scanner_siren1.wav", "GAME") then DoorOpenSound:AddOption("7", {fading_door_opensound = "7"}) end
		if file.Exists("sound/npc/barnacle/barnacle_gulp1.wav", "GAME") then DoorOpenSound:AddOption("8", {fading_door_opensound = "8"}) end
		if file.Exists("sound/npc/barnacle/barnacle_gulp2.wav", "GAME") then DoorOpenSound:AddOption("9", {fading_door_opensound = "9"}) end
		if file.Exists("sound/npc/combine_gunship/attack_start2.wav", "GAME") then DoorOpenSound:AddOption("10", {fading_door_opensound = "10"}) end
		if file.Exists("sound/npc/combine_gunship/attack_stop2.wav", "GAME") then DoorOpenSound:AddOption("11", {fading_door_opensound = "11"}) end
		if file.Exists("sound/npc/dog/dog_pneumatic1.wav", "GAME") then DoorOpenSound:AddOption("12", {fading_door_opensound = "12"}) end
		if file.Exists("sound/npc/dog/dog_pneumatic2.wav", "GAME") then DoorOpenSound:AddOption("13", {fading_door_opensound = "13"}) end
		]]
		
		local left = vgui.Create("DLabel", self)
		left:SetText("Open Sound")
		left:SetDark(true)
		DoorOpenSound:SetHeight(25)
		DoorOpenSound:Dock(TOP)
		
		self:AddItem(left, DoorOpenSound)
		
		local DoorActiveSound = vgui.Create("CtrlListBox", self)
		DoorActiveSound:AddOption("None", {fading_door_loopsound = "0"})
		--[[
		if file.Exists("sound/"..LoopSounds[1], "GAME") then DoorActiveSound:AddOption("1", {fading_door_loopsound = "1"}) end
		if file.Exists("sound/"..LoopSounds[2], "GAME") then DoorActiveSound:AddOption("2", {fading_door_loopsound = "2"}) end
		if file.Exists("sound/"..LoopSounds[3], "GAME") then DoorActiveSound:AddOption("3", {fading_door_loopsound = "3"}) end
		if file.Exists("sound/"..LoopSounds[4], "GAME") then DoorActiveSound:AddOption("4", {fading_door_loopsound = "4"}) end
		if file.Exists("sound/"..LoopSounds[5], "GAME") then DoorActiveSound:AddOption("5", {fading_door_loopsound = "5"}) end
		if file.Exists("sound/"..LoopSounds[6], "GAME") then DoorActiveSound:AddOption("6", {fading_door_loopsound = "6"}) end
		if file.Exists("sound/"..LoopSounds[7], "GAME") then DoorActiveSound:AddOption("7", {fading_door_loopsound = "7"}) end
		if file.Exists("sound/"..LoopSounds[8], "GAME") then DoorActiveSound:AddOption("8", {fading_door_loopsound = "8"}) end
		if file.Exists("sound/"..LoopSounds[9], "GAME") then DoorActiveSound:AddOption("9", {fading_door_loopsound = "9"}) end
		if file.Exists("sound/"..LoopSounds[10], "GAME") then DoorActiveSound:AddOption("10", {fading_door_loopsound = "10"}) end
		]]
		
		local left = vgui.Create("DLabel", self)
		left:SetText("Active Sound")
		left:SetDark(true)
		DoorActiveSound:SetHeight(25)
		DoorActiveSound:Dock(TOP)
		
		self:AddItem(left, DoorActiveSound)
		
		local DoorCloseSound = vgui.Create("CtrlListBox", self)
		DoorCloseSound:AddOption("None", {fading_door_closesound = "0"})
		--[[
		if file.Exists("sound/doors/doorstop1.wav", "GAME") then DoorCloseSound:AddOption("1", {fading_door_closesound = "1"}) end
		if file.Exists("sound/npc/turret_floor/retract.wav", "GAME") then DoorCloseSound:AddOption("2", {fading_door_closesound = "2"}) end
		if file.Exists("sound/npc/roller/mine/combine_mine_deactivate1.wav", "GAME") then DoorCloseSound:AddOption("3", {fading_door_closesound = "3"}) end
		if file.Exists("sound/npc/roller/mine/combine_mine_deploy1.wav", "GAME") then DoorCloseSound:AddOption("4", {fading_door_closesound = "4"}) end
		if file.Exists("sound/npc/roller/mine/rmine_taunt1.wav", "GAME") then DoorCloseSound:AddOption("5", {fading_door_closesound = "5"}) end
		if file.Exists("sound/npc/scanner/scanner_nearmiss2.wav", "GAME") then DoorCloseSound:AddOption("6", {fading_door_closesound = "6"}) end
		if file.Exists("sound/npc/scanner/scanner_siren1.wav", "GAME") then DoorCloseSound:AddOption("7", {fading_door_closesound = "7"}) end
		if file.Exists("sound/npc/barnacle/barnacle_gulp1.wav", "GAME") then DoorCloseSound:AddOption("8", {fading_door_closesound = "8"}) end
		if file.Exists("sound/npc/barnacle/barnacle_gulp2.wav", "GAME") then DoorCloseSound:AddOption("9", {fading_door_closesound = "9"}) end
		if file.Exists("sound/npc/combine_gunship/attack_start2.wav", "GAME") then DoorCloseSound:AddOption("10", {fading_door_closesound = "10"}) end
		if file.Exists("sound/npc/combine_gunship/attack_stop2.wav", "GAME") then DoorCloseSound:AddOption("11", {fading_door_closesound = "11"}) end
		if file.Exists("sound/npc/dog/dog_pneumatic1.wav", "GAME") then DoorCloseSound:AddOption("12", {fading_door_closesound = "12"}) end
		if file.Exists("sound/npc/dog/dog_pneumatic2.wav", "GAME") then DoorCloseSound:AddOption("13", {fading_door_closesound = "13"}) end
		]]

		local left = vgui.Create("DLabel", self)
		left:SetText("Close Sound")
		left:SetDark(true)
		DoorCloseSound:SetHeight(25)
		DoorCloseSound:Dock(TOP)
		
		self:AddItem(left, DoorCloseSound)
		self:AddControl("Numpad", {Label = "Button", ButtonSize = "22", Command = "fading_door_key"})
		self:MatSelect("fading_door_mat", list.Get("FDoorMaterials"), true, 0.33, 0.33)
	end
	
	local EFFECT = {}
	
	net.Receive("DrawFadeDoor",function()
		local String = net.ReadString()
		if String == "0" then
			EFFECT.Type = nil
			EFFECT.Ent = nil
			if EFFECT.Remove == false then EFFECT.Remove = true end
		else
			EFFECT.Type = nil
			EFFECT.Ent = nil
			if EFFECT.Remove == nil then util.Effect("render_fade_door", EffectData()) end
			EFFECT.Remove = false
			
			local Table = string.Explode("_",String)
			local Ent = ents.GetByIndex(tonumber(Table[1]))
			if IsValid(Ent) then
				EFFECT.Type = tonumber(Table[2])
				EFFECT.Ent = Ent
			end
		end
	end)
	
	function EFFECT:Init(data) end

	function EFFECT:Think()
		-- This makes the effect always visible.
		local pl = LocalPlayer()
		local Pos = pl:EyePos()
		local Trace = {}
		Trace.start = Pos
		Trace.endpos = Pos+(pl:GetAimVector()*10)
		Trace.filter = {pl}
		local TR = util.TraceLine(Trace)
		self:SetPos(TR.HitPos)
		
		-- Remove when ent is not valid.
		if !IsValid(EFFECT.Ent) then
			EFFECT.Type = nil
			EFFECT.Ent = nil
			EFFECT.Remove = true
		end
		
		if EFFECT.Remove or EFFECT.Remove == nil then
			EFFECT.Remove = nil
			return false
		end
		return true
	end
	
	function EFFECT:Render()
		if IsValid(EFFECT.Ent) then
			if EFFECT.Type == 1 then
				halo.Add({EFFECT.Ent}, Color(255, 255, 255, 255), 10, 10, 1, true, false)
			elseif EFFECT.Type == 2 then
				halo.Add({EFFECT.Ent}, Color(100, 255, 100, 255), 10, 10, 1, true, false)
			else
				halo.Add({EFFECT.Ent}, Color(255, 150, 50, 255), 10, 10, 1, true, false)
			end
		end
	end
	
	effects.Register(EFFECT,"render_fade_door",true)
	
	function TOOL:LeftClick(tr)
		if !tr.Entity or !tr.Entity:IsValid() then return false end
		if tr.Entity:IsPlayer() or tr.HitWorld then return false end
		return true
	end
	
	function TOOL:RightClick(tr)
		if !tr.Entity or !tr.Entity:IsValid() then return false end
		if tr.Entity:IsPlayer() or tr.HitWorld then return false end
		return true
	end

	function TOOL:Reload(tr)
		if !tr.Entity or !tr.Entity:IsValid() then return false end
		if tr.Entity:IsPlayer() or tr.HitWorld then return false end
		return true
	end
	
	return
end

local function fadeActivate(self)
	if self.fadeActive then return end

	if self.IsPIXELDefence then
		if (self:GetDefenceHealth() < self.DefenceMaxHP) then
			self:CPPIGetOwner():SendLua("notification.AddLegacy('Unable to open door, your defense is low on health.', 6)")
			return
		end
	end

	self.fadeActive = true
	self.fadeMaterial = self:GetMaterial()
	self.fadeDoorMaterial = self.fadeDoorMaterial or "sprites/heatwave"
	self:SetMaterial(self.fadeDoorMaterial)
	self:DrawShadow(false)
	if self.fadeCanDisableMotion then self:SetNotSolid(true) else self:SetCollisionGroup(COLLISION_GROUP_WORLD) end
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		self.fadeMoveable = phys:IsMoveable()
		phys:EnableMotion(false)
	end
	
	if self.fadeDoorOpenSound and Sounds and Sounds[self.fadeDoorOpenSound] then
		self:EmitSound(Sounds[self.fadeDoorOpenSound],350,100)
	end
	
	if self.fadeDoorLoopSound and LoopSounds and LoopSounds[self.fadeDoorLoopSound] and !self.FadeDoorSound then
		self.FadeDoorSound = CreateSound(self, LoopSounds[self.fadeDoorLoopSound])
		self.FadeDoorSound:Play()
	end
	
	if WireLib then
		Wire_TriggerOutput(self,  "FadeActive",  1)
	end
end

local function fadeDeactivate(self)
	self.fadeActive = false
	if self:GetMaterial() == self.fadeDoorMaterial and self.fadeMaterial then self:SetMaterial(self.fadeMaterial) end
	self:DrawShadow(true)
	if self.fadeCanDisableMotion then self:SetNotSolid(false) else self:SetCollisionGroup(COLLISION_GROUP_NONE) end
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(self.fadeMoveable or false)
		phys:Wake()
	end
	
	if self.fadeDoorCloseSound and Sounds and Sounds[self.fadeDoorCloseSound] then
		self:EmitSound(Sounds[self.fadeDoorCloseSound],350,100)
	end
	
	if self.FadeDoorSound then self.FadeDoorSound:Stop() end
	self.FadeDoorSound = nil
	
	if WireLib then
		Wire_TriggerOutput(self,  "FadeActive",  0)
	end
end

local function onUp(pl, Ent)
	if IsValid(Ent) then
		local Activate = false
		if Ent.fadeToggle then
			if Ent.fadeReversed then
				Activate = !Ent.fadeActive
			else
				Activate = Ent.fadeActive
			end
		elseif Ent.fadeReversed then
			Activate = true
		end
		if Activate then
			if !Ent.fadeActive then Ent:fadeActivate() end
		else
			if Ent.fadeActive then Ent:fadeDeactivate() end
		end
	end
end
numpad.Register("Fading Door onUp", onUp)

local function onDown(pl, Ent)
	if IsValid(Ent) then
		local Activate = true
		if Ent.fadeToggle then
			if Ent.fadeReversed then
				Activate = Ent.fadeActive
			else
				Activate = !Ent.fadeActive
			end
		elseif Ent.fadeReversed then
			Activate = false
		end
		if Activate then
			if !Ent.fadeActive then Ent:fadeActivate() end
		else
			if Ent.fadeActive then Ent:fadeDeactivate() end
		end
	end
end
numpad.Register("Fading Door onDown", onDown)

local function getWireInputs(Ent)
	local inputs = Ent.Inputs
	local names, types, descs = {}, {}, {}
	if inputs then
		local num
		for _, data in pairs(inputs) do
			num = data.Num
			names[num] = data.Name
			types[num] = data.Type
			descs[num] = data.Desc
		end
	end
	return names, types, descs
end

local function doWireInputs(Ent)
	local inputs = Ent.Inputs
	if !inputs then
		Wire_CreateInputs(Ent, {"Fade"})
		return
	end
	local names, types, descs = {}, {}, {}
	local num
	for _, data in pairs(inputs) do
		num = data.Num
		names[num] = data.Name
		types[num] = data.Type
		descs[num] = data.Desc
	end
	table.insert(names, "Fade")
	WireLib.AdjustSpecialInputs(Ent, names, types, descs)
end

local function doWireOutputs(Ent)
	local outputs = Ent.Outputs
	if !outputs then
		Wire_CreateOutputs(Ent, {"FadeActive"})
		return
	end
	local names, types, descs = {}, {}, {}
	local num
	for _, data in pairs(outputs) do
		num = data.Num
		names[num] = data.Name
		types[num] = data.Type
		descs[num] = data.Desc
	end
	table.insert(names, "FadeActive")
	WireLib.AdjustSpecialOutputs(Ent, names, types, descs)
end

local function TriggerInput(self, name, value, ...)
	if name == "Fade" then
		if value == 0 then onUp(nil, self) else onDown(nil, self) end
	elseif self.fadeTriggerInput then
		return self:fadeTriggerInput(name, value, ...)
	end
end

local function PreEntityCopy(self)
	if self then
		local info = WireLib.BuildDupeInfo(self)
		if info then duplicator.StoreEntityModifier(self, "WireDupeInfo", info) end
		if self.fadePreEntityCopy then self:fadePreEntityCopy() end
	end
end

local function PostEntityPaste(self, pl, Ent, ents)
	if self then
		if self.EntityMods and self.EntityMods.WireDupeInfo then WireLib.ApplyDupeInfo(pl, self, self.EntityMods.WireDupeInfo, function(id) return ents[id] end) end
		if self.fadePostEntityPaste then self:fadePostEntityPaste(pl, Ent, ents) end
	end
end

local function onRemove(self)
	if self.fadeDeactivate then self:fadeDeactivate() end
	self.isFadingDoor = nil
	self.PreEntityCopy = self.fadePreEntityCopy
	self.fadePreEntityCopy = nil
	self.PostEntityPaste = self.fadePostEntityPaste
	self.fadePostEntityPaste = nil
	self.TriggerInput = self.fadeTriggerInput
	self.fadeTriggerInput = nil
	duplicator.ClearEntityModifier(self, "Fading Door")
	if self.fadeUpNum then numpad.Remove(self.fadeUpNum) end
	if self.fadeDownNum then numpad.Remove(self.fadeDownNum) end
	self.fadeActive = nil
	self.fadeMaterial = nil
	if IsValid(self.FadingDoorDummy) then self.FadingDoorDummy:Remove() end
	self.FadingDoorDummy = nil
	self.fadeToggle = nil
	self.fadeDoorMaterial = nil
	self.fadeMoveable = nil
	self.fadeCanDisableMotion = nil
	self.fadeDoorOpenSound = nil
	self.fadeDoorCloseSound = nil
	self.fadeDoorLoopSound = nil
	self.fadeDeactivate = nil
	self.fadeUpNum = nil
	self.fadeDownNum = nil
	self.fadeToggleActive = nil
	self.fadeReversed = nil
	self.fadeActivate = nil
	self.fadeKey = nil
	if self.OnDieFunctions then
		self.OnDieFunctions["UndoFadingDoor"..self:EntIndex()] = nil
		self.OnDieFunctions["Fading Doors"] = nil
	end
	if WireLib then
		if self.Inputs then
			Wire_Link_Clear(self, "Fade")
			self.Inputs['Fade'] = nil
			WireLib._SetInputs(self)
		end
		if self.Outputs then
			local port = self.Outputs['FadeActive']
			if port then
				for i,inp in ipairs(port.Connected) do
					if inp.Entity:IsValid() then
						Wire_Link_Clear(inp.Entity, inp.Name)
					end
				end
			end
			self.Outputs['FadeActive'] = nil
			WireLib._SetOutputs(self)
		end
	end
	if self.EntityMods and self.EntityMods.WireDupeInfo and self.EntityMods.WireDupeInfo.Wires then self.EntityMods.WireDupeInfo.Wires.Fade = nil end
end

local function RemoveKeys(self)
	if self.FadeDoorSound then self.FadeDoorSound:Stop() end
	numpad.Remove(self.fadeUpNum)
	numpad.Remove(self.fadeDownNum)
end

local function dooEet(pl, Ent, stuff)
	if Ent.isFadingDoor then
		if Ent.fadeDeactivate then Ent:fadeDeactivate() end
		RemoveKeys(Ent)
	else
		Ent.isFadingDoor = true
		Ent.fadeActivate = fadeActivate
		Ent.fadeDeactivate = fadeDeactivate
		Ent.fadeToggleActive = fadeToggleActive
		Ent:CallOnRemove("Fading Doors", RemoveKeys)
		if WireLib then
			doWireInputs(Ent)
			doWireOutputs(Ent)
			Ent.fadeTriggerInput = Ent.fadeTriggerInput or Ent.TriggerInput
			Ent.TriggerInput = TriggerInput
			if !Ent.IsWire then
				if !Ent.fadePreEntityCopy and Ent.PreEntityCopy then Ent.fadePreEntityCopy = Ent.PreEntityCopy end
				Ent.PreEntityCopy = PreEntityCopy
				if !Ent.fadePostEntityPaste and Ent.PreEntityCopy then Ent.fadePostEntityPaste = Ent.PostEntityPaste end
				Ent.PostEntityPaste = PostEntityPaste
			end
		end
	end
	Ent.fadeUpNum = numpad.OnUp(pl, stuff.key, "Fading Door onUp", Ent)
	Ent.fadeDownNum = numpad.OnDown(pl, stuff.key, "Fading Door onDown", Ent)
	Ent.fadeToggle = stuff.toggle
	Ent.fadeReversed = stuff.reversed
	Ent.fadeKey = stuff.key
	Ent.fadeCanDisableMotion = stuff.CanDisableMotion
	Ent.fadeDoorMaterial = stuff.DoorMaterial
	Ent.fadeDoorOpenSound = stuff.DoorOpenSound
	Ent.fadeDoorLoopSound = stuff.DoorLoopSound
	Ent.fadeDoorCloseSound = stuff.DoorCloseSound
	if stuff.reversed then Ent:fadeActivate() end
	duplicator.StoreEntityModifier(Ent, "Fading Door", stuff)
	return true
end

duplicator.RegisterEntityModifier("Fading Door", dooEet)
hook.Add("Initialize", "FadingDoor1", function() duplicator.RegisterEntityModifier("Fading Door", dooEet) end)	-- No overwrite.

if !FadingDoor then
	local function legacy(pl, Ent, data)
		return dooEet(pl, Ent, {
			key					= data.Key,
			toggle				= data.Toggle,
			reversed			= data.Inverse,
			CanDisableMotion	= data.CanDisableMotion,
			DoorMaterial		= data.DoorMaterial,
			DoorOpenSound		= data.DoorOpenSound,
			DoorLoopSound		= data.DoorLoopSound,
			DoorCloseSound		= data.DoorCloseSound
		})
	end
	duplicator.RegisterEntityModifier("FadingDoor", legacy)
	hook.Add("Initialize", "FadingDoor2", function() duplicator.RegisterEntityModifier("FadingDoor", legacy) end)	-- No overwrite.
end

function TOOL:LeftClick(tr)
	if !tr.Entity or !tr.Entity:IsValid() then return false end
	if tr.Entity:IsPlayer() or tr.HitWorld or tr.Entity:GetClass() == "sammyservers_textscreen" then return false end
	if CLIENT then return true end
	
	local Ent = tr.Entity
	local pl = self:GetOwner()
	if not list.Contains("FDoorMaterials",self:GetClientInfo("mat")) then
		for k, v in ipairs(player.GetAll()) do
			if v:IsAdmin() then
				v:PrintMessage(3,pl:Nick() .. " tried to use custom fading door material: " .. self:GetClientInfo("mat"))
			end
		end
		print(pl:Nick() .. " tried to use custom fading door material: " .. self:GetClientInfo("mat"))
		return
	end
	
	if !IsValid(pl) then return false end
	
	local phys = Ent:GetPhysicsObject()
	local CanDisableMotion = false
	
	if phys:IsValid() then
		local MotionEnabled = phys:IsMotionEnabled()
		phys:EnableMotion(!MotionEnabled)
		CanDisableMotion = MotionEnabled != phys:IsMotionEnabled()
		phys:EnableMotion(MotionEnabled)
	end
	
	if self.AimEnt then
		self.AimEnt[pl] = nil
		net.Start("DrawFadeDoor")
		net.WriteString("0")
		net.Send(pl)
	end
	
	dooEet(pl, Ent, {
		key     			= self:GetClientNumber("key"),
		toggle   			= self:GetClientNumber("swap") == 1,
		reversed			= self:GetClientNumber("reversed") == 1,
		CanDisableMotion	= CanDisableMotion,
		DoorMaterial		= self:GetClientInfo("mat"),
		DoorOpenSound     	= self:GetClientNumber("opensound"),
		DoorLoopSound     	= self:GetClientNumber("loopsound"),
		DoorCloseSound     	= self:GetClientNumber("closesound")
	})
	
	if !IsValid(Ent.FadingDoorDummy) then
		local Dummy = ents.Create("info_null")
		Dummy.Owner = pl
		Dummy.Door = Ent
		undo.Create("Undo fading door")
		undo.AddEntity(Dummy)
		Ent.FadingDoorDummy = Dummy
		local UndoT = {Ent,self:GetOwner(),self}
		undo.AddFunction(function(Undo, UndoT)
			local Ent = UndoT[1]
			local pl = UndoT[2]
			local Tool = UndoT[3]
			if IsValid(Ent) then onRemove(Ent) end
			if IsValid(pl) then
				if Tool and Tool.AimEnt then Tool.AimEnt[pl] = nil end
				net.Start("DrawFadeDoor")
				net.WriteString("0")
				net.Send(pl)
			end
		end, UndoT)
		undo.SetPlayer(pl)
		undo.SetCustomUndoText("Undone Fading Door")
		undo.Finish()
		
		Ent:CallOnRemove("UndoFadingDoor"..Ent:EntIndex(),function(Ent)
			if Ent.FadingDoorDummy and Ent.FadingDoorDummy:IsValid() then
				if IsValid(Ent.FadingDoorDummy.Owner) then
					local PlayerID = Ent.FadingDoorDummy.Owner:UniqueID()
					local PlayerUndo = undo:GetTable()[PlayerID]
					if PlayerUndo then
						for k,v in pairs(PlayerUndo) do
							if PlayerUndo[k] and PlayerUndo[k].Name and PlayerUndo[k].Name == "Undo fading door" and PlayerUndo[k].Entities and IsValid(PlayerUndo[k].Entities[1]) and PlayerUndo[k].Entities[1]:GetTable().Door == Ent then
								undo:GetTable()[PlayerID][k] = nil
								break
							end
						end
					end
				end
				Ent.FadingDoorDummy:Remove()
			end
		end,Ent)
	end
	
	return true
end

function TOOL:RightClick(tr)
	if !tr.Entity or !tr.Entity:IsValid() then return false end
	if tr.Entity:IsPlayer() or tr.HitWorld then return false end
	if CLIENT then return true end
	local Ent = tr.Entity
	if Ent.isFadingDoor then
		local pl = self:GetOwner()
		if !IsValid(pl) then return false end
		if Ent.fadeKey != nil then pl:ConCommand("fading_door_key "..tostring(Ent.fadeKey)) end
		if Ent.fadeToggle != nil then if Ent.fadeToggle then pl:ConCommand("fading_door_swap 1") else pl:ConCommand("fading_door_swap 0") end end
		if Ent.fadeReversed != nil then if Ent.fadeReversed then pl:ConCommand("fading_door_reversed 1") else pl:ConCommand("fading_door_reversed 0") end end
		if Ent.fadeDoorMaterial != nil then pl:ConCommand("fading_door_mat "..Ent.fadeDoorMaterial) end
		if Ent.fadeDoorOpenSound != nil then pl:ConCommand("fading_door_opensound "..tostring(Ent.fadeDoorOpenSound)) end
		if Ent.fadeDoorLoopSound != nil then pl:ConCommand("fading_door_loopsound "..tostring(Ent.fadeDoorLoopSound)) end
		if Ent.fadeDoorCloseSound != nil then pl:ConCommand("fading_door_closesound "..tostring(Ent.fadeDoorCloseSound)) end
		return true
	end
end

function TOOL:Reload(tr)
	if !tr.Entity or !tr.Entity:IsValid() then return false end
	if tr.Entity:IsPlayer() or tr.HitWorld then return false end
	if CLIENT then return true end
	local Ent = tr.Entity
	
	if Ent.isFadingDoor then
		if IsValid(Ent.FadingDoorDummy) then
			if IsValid(Ent.FadingDoorDummy.Owner) then
				local PlayerID = Ent.FadingDoorDummy.Owner:UniqueID()
				local PlayerUndo = undo:GetTable()[PlayerID]
				if PlayerUndo then
					for k,v in pairs(PlayerUndo) do
						if PlayerUndo[k] and PlayerUndo[k].Name and PlayerUndo[k].Name == "Undo fading door" and PlayerUndo[k].Entities and IsValid(PlayerUndo[k].Entities[1]) and PlayerUndo[k].Entities[1]:GetTable().Door == Ent then
							undo:GetTable()[PlayerID][k] = nil
							break
						end
					end
				end
			end
			Ent.FadingDoorDummy:Remove()
		end
		onRemove(Ent)
		net.Start("DrawFadeDoor")
		net.WriteString(tostring(Ent:EntIndex()).."_1")
		net.Send(self:GetOwner())
		return true
	end
end

function TOOL:Holster()
	if CLIENT then return end
	local pl = self:GetOwner()
	if !IsValid(pl) then return false end
	if self.AimEnt and self.AimEnt[pl] != nil then
		self.AimEnt[pl] = nil
		net.Start("DrawFadeDoor")
		net.WriteString("0")
		net.Send(pl)
	end
end

function TOOL:Think()
	if CLIENT then return end
	if self.Hold then return end
	local pl = self:GetOwner()
	local trace = pl:GetEyeTrace()
	
	if trace.Hit and trace.Entity and trace.Entity:IsValid() and !trace.Entity:IsPlayer() then
		if !self.AimEnt then self.AimEnt = {} end
		if !self.OldKey then self.OldKey = {} end
		if !self.OldToggle then self.OldToggle = {} end
		if !self.OldReversed then self.OldReversed = {} end
		
		if !IsValid(pl) then return false end
		
		if trace.Entity != self.AimEnt[pl] or self:GetClientNumber("key") != self.OldKey[pl] or self:GetClientNumber("swap") != self.OldToggle[pl] or self:GetClientNumber("reversed") != self.OldReversed[pl] then
			self.AimEnt[pl] = trace.Entity
			local Key = self:GetClientNumber("key")
			self.OldKey[pl] = Key
			local Toggle = self:GetClientNumber("swap")
			self.OldToggle[pl] = Toggle
			local Reversed = self:GetClientNumber("reversed")
			self.OldReversed[pl] = Reversed
			if trace.Entity.isFadingDoor then
				Toggle = Toggle == 1
				Reversed = Reversed == 1
				if trace.Entity.fadeKey == Key and trace.Entity.fadeReversed == Reversed and trace.Entity.fadeToggle == Toggle then
					net.Start("DrawFadeDoor")
					net.WriteString(tostring(trace.Entity:EntIndex()).."_2")
					net.Send(pl)
				else
					net.Start("DrawFadeDoor")
					net.WriteString(tostring(trace.Entity:EntIndex()).."_3")
					net.Send(pl)
				end
			else
				net.Start("DrawFadeDoor")
				net.WriteString(tostring(trace.Entity:EntIndex()).."_1")
				net.Send(pl)
			end
		end
	elseif self.AimEnt and self.AimEnt[pl] != nil then
		self.AimEnt[pl] = nil
		net.Start("DrawFadeDoor")
		net.WriteString("0")
		net.Send(pl)
	end
end