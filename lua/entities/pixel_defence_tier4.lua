
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

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "pixel_defence_base"

ENT.PrintName = "Defence Tier 4"
ENT.Category = "PIXEL Defences"
ENT.Author = "Tom.bat"
ENT.Contact = "tom@tomdotbat.dev"
ENT.Purpose = "Used for defending yourself during combat."
ENT.Instructions = "Press E on the box and place the defence where you want it."

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.BoxModel = "models/props_junk/wood_crate002a.mdl"

ENT.DefenceTier = 4
ENT.DefenceMaxHP = 2500
ENT.DefenceBuildTime = 150 --Amount of time it takes for the initial build to complete
ENT.DefenceModel = "models/props_lab/blastdoor001b.mdl"

--Editor/3D2D configuration
ENT.Max = false --Swap this from true/false if the prop is floating above the ground in the editor
ENT.RotateText = false --Swap this from true/false if the defence stats are on the wrong sides of the model
ENT.MaxHeight = 110 --The height of the prop, used in the build animation, lower if the animation goes too fast, increase if otherwise
ENT.UIOffset = Vector(0, 0, 0) --The offset given to the statistics on the defence