local HouseList = {}
Houses.HouseList = Houses.MakeConstructor (HouseList)

function HouseList:ctor ()
	Houses.EventProvider (self)
	self.Subscribers = Houses.SubscriberList ()
	self.DoorSubscribers = Houses.SubscriberList ()
	
	self.Houses = {}
	self.HouseCount = 0
	
	Houses.Clients:AddEventListener ("ClientDisconnected", tostring (self), function (clients, client)
		local steamID = client:GetSteamID ()
		for _, house in pairs (self.Houses) do
			if house:GetOwnerID () == steamID then
				house:SetOwnerID (nil)
			end
		end
	end)
end

function HouseList:AddHouse (house)
	if not house then return end
	if self.Houses [house:GetID ()] then
		self:RemoveHouse (house:GetID ())
	end
	self.Houses [house:GetID ()] = house
	self.HouseCount = self.HouseCount + 1
	
	self:DispatchEvent ("HouseAdded", house)
	
	self:InstallEventListeners (house)
end

function HouseList:Clear ()
	local ids = {}
	for k, _ in pairs (self.Houses) do
		ids [#ids + 1] = k
	end
	for _, id in ipairs (ids) do
		self:RemoveHouse (id)
	end
end

function HouseList:GetHouse (id)
	return self.Houses [id]
end

function HouseList:GetHouseCount ()
	return self.HouseCount
end

function HouseList:GetHouseIterator ()
	local next, tbl, key = pairs (self.Houses)
	return function ()
		key = next (tbl, key)
		return key, tbl [key]
	end
end

function HouseList:InstallEventListeners (house)
	house:AddEventListener ("CategoryChanged", tostring (self), function (house, category)
		self:DispatchEvent ("HouseCategoryChanged", house, category)
	end)
	house:AddEventListener ("DescriptionChanged", tostring (self), function (house, description)
		self:DispatchEvent ("HouseDescriptionChanged", house, description)
	end)
	house:AddEventListener ("IconChanged", tostring (self), function (house, icon)
		self:DispatchEvent ("HouseIconChanged", house, icon)
	end)
	house:AddEventListener ("NameChanged", tostring (self), function (house, name)
		self:DispatchEvent ("HouseNameChanged", house, name)
	end)
	house:AddEventListener ("OwnerChanged", tostring (self), function (house, owned, ownerID)
		self:DispatchEvent ("HouseOwnerChanged", house, owned, ownerID)
	end)
	house:AddEventListener ("PriceChanged", tostring (self), function (house, price)
		self:DispatchEvent ("HousePriceChanged", house, price)
	end)
	
	house:AddEventListener ("DoorAdded", tostring (self), function (house, door)
		self:DispatchEvent ("HouseDoorAdded", house, door)
	end)
	house:AddEventListener ("DoorRemoved", tostring (self), function (house, door, doorID)
		self:DispatchEvent ("HouseDoorRemoved", house, door, doorID)
	end)
end

function HouseList:LinkDoors ()
	for _, house in self:GetHouseIterator () do
		for door in house:GetDoorIterator () do
			door:Link ()
		end
	end
end

function HouseList:RemoveHouse (id)
	if not self.Houses [id] then return end
	
	self.Houses [id]:DispatchEvent ("Removed")
	self:DispatchEvent ("HouseRemoved", self.Houses [id])
	self:UninstallEventListeners (self.Houses [id])
	
	self.Houses [id]:SetOwnerID (nil)
	
	self.Houses [id] = nil
	self.HouseCount = self.HouseCount - 1
end

function HouseList:UninstallEventListeners (house)
	house:RemoveEventListener ("CategoryChanged", tostring (self))
	house:RemoveEventListener ("DescriptionChanged", tostring (self))
	house:RemoveEventListener ("IconChanged", tostring (self))
	house:RemoveEventListener ("NameChanged", tostring (self))
	house:RemoveEventListener ("OwnerChanged", tostring (self))
	house:RemoveEventListener ("PriceChanged", tostring (self))
	
	house:RemoveEventListener ("DoorAdded", tostring (self))
	house:RemoveEventListener ("DoorRemoved", tostring (self))
end

function HouseList:UpdateDoorData ()
	for _, house in self:GetHouseIterator () do
		for door in house:GetDoorIterator () do
			door:UpdateDoorData ()
		end
	end
end