if CLIENT then
	include('weapon_vape/cl_init.lua')
else
	include('weapon_vape/shared.lua')
end

SWEP.PrintName = "Butterfly Vape"
SWEP.VapeAccentColor = Vector(0,1,1)

SWEP.Spawnable = false

SWEP.VapeVMAng2 = Vector(360+170,720-108,132)