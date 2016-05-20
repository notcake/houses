local NetworkSerializer = {}
Houses.NetworkSerializer = Houses.MakeConstructor (NetworkSerializer)

function NetworkSerializer:ctor (houses)
	self.Houses = houses
	
	self.Houses:AddEventListener ("HouseAdded", tostring (self), function (houses, house)
		self:SendHouse (house, self.Houses.Subscribers:GetRecipientFilter ())
		self:SendHouseDoors (house, self.Houses.DoorSubscribers:GetRecipientFilter ())
	end)
	
	self.Houses:AddEventListener ("HouseRemoved", tostring (self), function (houses, house)
		umsg.Start ("houses_deleted", self.Houses.Subscribers:GetRecipientFilter ())
			umsg.String (house:GetID ())
		umsg.End ()
	end)
	
	-- houses
	for _, property in ipairs ({"Name", "Category", "Description", "Icon"}) do
		self.Houses:AddEventListener ("House" .. property .. "Changed", tostring (self), function (houses, house, value)
			umsg.Start ("houses_" .. property:lower (), self.Houses.Subscribers:GetRecipientFilter ())
				umsg.String (house:GetID ())
				umsg.String (value)
			umsg.End ()
		end)
	end
	
	self.Houses:AddEventListener ("HouseOwnerChanged", tostring (self), function (houses, house, owned, ownerID)
		for ply in self.Houses.Subscribers:GetPlayerIterator () do
			umsg.Start ("houses_owner", ply)
				umsg.String (house:GetID ())
				umsg.Bool (owned)
				umsg.String (ownerID or "")
			umsg.End ()
		end
	end)
	
	self.Houses:AddEventListener ("HousePriceChanged", tostring (self), function (houses, house, price)
		umsg.Start ("houses_price", self.Houses.Subscribers:GetRecipientFilter ())
			umsg.String (house:GetID ())
			umsg.Long (price)
		umsg.End ()
	end)
	
	-- doors
	self.Houses:AddEventListener ("HouseDoorAdded", tostring (self), function (houses, house, door)
		umsg.Start ("houses_door", self.Houses.DoorSubscribers:GetRecipientFilter ())
			umsg.String (house:GetID ())
			umsg.Vector (door:GetPosition ())
			umsg.String (door:GetModel ())
		umsg.End ()
	end)
	
	self.Houses:AddEventListener ("HouseDoorRemoved", tostring (self), function (houses, house, door, doorID)
		umsg.Start ("houses_door_removed", self.Houses.DoorSubscribers:GetRecipientFilter ())
			umsg.String (house:GetID ())
			umsg.Long (doorID)
		umsg.End ()
	end)
end

function NetworkSerializer:SendAllHouses (ply)
	umsg.Start ("houses_clear", ply)
	umsg.End ()
	
	for id, house in self.Houses:GetHouseIterator () do
		umsg.PoolString (house:GetID ())
		umsg.PoolString (house:GetCategory ())
		umsg.PoolString (house:GetDescription ())
		umsg.PoolString (house:GetIcon ())
	
		self:SendHouse (house, ply)
	end
end

function NetworkSerializer:SendAllDoors (ply)
	for id, house in self.Houses:GetHouseIterator () do	
		self:SendHouseDoors (house, ply)
	end
end

function NetworkSerializer:SendHouse (house, ply)
	umsg.Start ("houses_house", ply)
		umsg.String (house:GetID ())
		umsg.String (house:GetName ())
		umsg.String (house:GetCategory ())
		umsg.String (house:GetDescription ())
		umsg.String (house:GetIcon ())
		umsg.Long (house:GetPrice ())
		umsg.String (house:GetOwnerID () or "")
	umsg.End ()
end

function NetworkSerializer:SendHouseDoors (house, ply)
	for door in house:GetDoorIterator () do
		umsg.Start ("houses_door", ply)
			umsg.String (house:GetID ())
			umsg.Vector (door:GetPosition ())
			umsg.String (door:GetModel ())
		umsg.End ()
	end
end