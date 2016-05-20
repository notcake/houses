include ("shared.lua")
AddCSLuaFile ("shared.lua")
AddCSLuaFile ("cl_init.lua")

function ENT:Initialize ()
	self:SetModel ("models/mossman.mdl")

	self:SetHullType (HULL_HUMAN)
	self:SetHullSizeNormal ()
	
	self:SetUseType (SIMPLE_USE)
 
	self:SetSolid (SOLID_BBOX)
	self:SetMoveType (MOVETYPE_STEP)
 
	self:CapabilitiesAdd (bit.bor (CAP_MOVE_GROUND, CAP_OPEN_DOORS, CAP_ANIMATEDFACE, CAP_TURN_HEAD, CAP_USE_SHOT_REGULATOR, CAP_AIM_GUN))
 
	self:SetMaxYawSpeed (5000)
 
	self:SetHealth (100)
	
	if self:GetPhysicsObject ():IsValid () then
		self:GetPhysicsObject ():Wake ()
	end 
end

function ENT:AcceptInput (name, activator, caller)
    if name == "Use" and activator and activator:IsPlayer () then
		Houses.OpenPreSalesmanUI (activator)
    end
end

function ENT:OnTakeDamage (damage)
	return false
end

function ENT:SpawnFunction (ply, tr)
	if not tr.Hit then
		return
	end
	local pos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create ("npc_house_salesman")
	ent:SetPos (pos)
	ent:Spawn ()
	ent:Activate ()
	
	return ent
end