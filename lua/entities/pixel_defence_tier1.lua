
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "pixel_defense_base"

ENT.PrintName = "Defence Tier 1"
ENT.Category = "PIXEL Defences"
ENT.Author = "Tom.bat"
ENT.Contact = "tom@tomdotbat.dev"
ENT.Purpose = "Used for defending yourself during combat."
ENT.Instructions = "Press E on the box and place the defence where you want it."

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.BoxModel = "models/props_junk/cardboard_box001a.mdl"

ENT.DefenseTier = 1
ENT.DefenseHP = 400
ENT.DefenseBuildTime = 45 --Amount of time it takes for the build to complete
ENT.DefenseModel = "models/props_fortifications/block_wall_01.mdl"

--Editor/3D2D configuration
ENT.Max = false --Swap this from true/false if the prop is floating above the ground in the editor
ENT.RotateText = true --Swap this from true/false if the defense stats are on the wrong sides of the model
ENT.MaxHeight = 50 --The height of the prop, used in the build animation, lower if the animation goes too fast, increase if otherwise
ENT.UIOffset = Vector(0, 7.7, 8) --The offset given to the statistics on the defense