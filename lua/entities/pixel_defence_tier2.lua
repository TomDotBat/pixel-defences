
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "pixel_defense_base"

ENT.PrintName = "Defence Tier 2"
ENT.Category = "PIXEL Defences"
ENT.Author = "Tom.bat"
ENT.Contact = "tom@tomdotbat.dev"
ENT.Purpose = "Used for defending your base."
ENT.Instructions = "Press E on the box and place the defence where you want it."

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.BoxModel = "models/props_junk/cardboard_box002a.mdl"

ENT.DefenseTier = 2
ENT.DefenseHP = 800
ENT.DefenseBuildTime = 60 --Amount of time it takes for the initial build to complete
ENT.DefenseModel = "models/props_fortifications/hedgehog_01.mdl"

--Editor/3D2D configuration
ENT.Max = false --Swap this from true/false if the prop is floating above the ground in the editor
ENT.RotateText = false --Swap this from true/false if the defense stats are on the wrong sides of the model
ENT.MaxHeight = 84 --The height of the prop, used in the build animation, lower if the animation goes too fast, increase if otherwise
ENT.UIOffset = Vector(-33, 0, 0) --The offset given to the statistics on the defense