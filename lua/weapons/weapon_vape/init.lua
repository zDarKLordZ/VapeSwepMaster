-- weapon_vape/cl_init.lua
-- Defines common serverside code/defaults for Vape SWEP

-- Vape SWEP by Swamp Onions - http://steamcommunity.com/id/swamponions/

AddCSLuaFile ("cl_init.lua")
AddCSLuaFile ("shared.lua")
include ("shared.lua")

util.AddNetworkString("Vape")
util.AddNetworkString("VapeArm")
util.AddNetworkString("VapeTalking")

function VapeUpdate(ply, vapeID)
	if not ply.vapeCount then ply.vapeCount = 0 end
	if not ply.cantStartVape then ply.cantStartVape=false end
	if ply.vapeCount == 0 and ply.cantStartVape then return end

	if vapeID == 3 then --medicinal vape healing
		if ply.medVapeTimer then ply:SetHealth(math.min(ply:Health() + 1, ply:GetMaxHealth())) end
		ply.medVapeTimer = !ply.medVapeTimer
	end
	
	ply.vapeID = vapeID
	ply.vapeCount = ply.vapeCount + 1
	if ply.vapeCount == 1 then
		ply.vapeArm = true
		net.Start("VapeArm")
		net.WriteEntity(ply)
		net.WriteBool(true)
		net.Broadcast()
	end
	if ply.vapeCount >= 50 then
		ply.cantStartVape = true
		ReleaseVape(ply)
	end
end

hook.Add("KeyRelease","DoVapeHook",function(ply, key)
	if key == IN_ATTACK then
		ReleaseVape(ply)
		ply.cantStartVape=false
	end
end)

function ReleaseVape(ply)
	if not ply.vapeCount then ply.vapeCount = 0 end
	if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass():sub(1,11) == "weapon_vape" then
		if ply.vapeCount >= 5 then
			net.Start("Vape")
			net.WriteEntity(ply)
			net.WriteInt(ply.vapeCount, 8)
			net.WriteInt(ply.vapeID + (ply:GetActiveWeapon().juiceID or 0), 8)
			net.Broadcast()
		end
	end
	if ply.vapeArm then
		ply.vapeArm = false
		net.Start("VapeArm")
		net.WriteEntity(ply)
		net.WriteBool(false)
		net.Broadcast()
	end
	ply.vapeCount=0 
end