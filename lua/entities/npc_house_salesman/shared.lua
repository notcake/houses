ENT.Base					= "base_ai" 
ENT.Type					= "ai"
 
ENT.PrintName				= "Realtor"
ENT.Author					= "!cake"
ENT.Contact					= ""
ENT.Purpose					= ""
ENT.Instructions			= "Press USE"
 
ENT.AutomaticFrameAdvance	= true

ENT.Spawnable				= false
ENT.AdminSpawnable			= false

function ENT:SetAutomaticFrameAdvance (usingAnim)
	self.AutomaticFrameAdvance = usingAnim
end