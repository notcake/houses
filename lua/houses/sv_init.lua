include ("houses/sv_houseserializer.lua")
include ("houses/sv_perphouseserializer.lua")
include ("houses/sv_networkserializer.lua")
include ("houses/sv_resources.lua")

local perpSerializer = Houses.PERPHouseSerializer (Houses.Houses)
perpSerializer:LoadHouses ()

Houses.FileSerializer = Houses.HouseSerializer (Houses.Houses)
Houses.FileSerializer:LoadHouses ()

Houses.NetSerializer = Houses.NetworkSerializer (Houses.Houses)

hook.Add ("InitPostEntity", "Houses", function ()
	timer.Simple (1,
		function ()
			Houses.Houses:LinkDoors ()
		end
	)
end)

include ("houses/sv_autospawn.lua")

include ("houses/sv_sales.lua")
include ("houses/sv_admin.lua")

local Entity = debug.getregistry ().Entity
function Entity:IsHouseDoor()
	if not IsValid (self) then return end
	
	if not self.DoorData or self.DoorData.IsHouseDoor == nil then
		Houses.Houses:UpdateDoorData ()
	end
	
	self.DoorData = self.DoorData or {}
	self.DoorData.IsHouseDoor = self.HouseDoor ~= nil
	if self.DoorData.IsHouseDoor and self.HouseDoor:GetHouse () then
		self.DoorData.HouseName = self.HouseDoor:GetHouse ():GetName ()
	else
		self.DoorData.HouseName = ""
	end
	
	return self.DoorData.IsHouseDoor
end