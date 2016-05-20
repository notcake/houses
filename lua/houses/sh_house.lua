local House = {}
Houses.House = Houses.MakeConstructor (House)

function House:ctor (id)
	Houses.EventProvider (self)

	self.ID = id
	self.Name = "<name>"
	self.Category = "<category>"
	self.Description = "<description>"
	self.Icon = "icon16/cross.png"
	
	self.Price = 9000
	
	self.Doors = {}
	
	self.Owned = false
	self.OwnerID = nil
end

function House:AddDoor (door)
	self.Doors [#self.Doors + 1] = door
	door:SetHouse (self)
	
	self:DispatchEvent ("DoorAdded", door)
end

function House:GetCategory ()
	return self.Category
end

function House:GetDescription ()
	return self.Description
end

function House:GetDoor (doorID)
	return self.Doors [doorID]
end

function House:GetDoorID (door)
	for k, v in ipairs (self.Doors) do
		if v == door then
			return k
		end
	end
	return 0
end

function House:GetDoorIterator ()
	local next, tbl, key = ipairs (self.Doors)
	return function ()
		key = next (tbl, key)
		return tbl [key]
	end
end

function House:GetIcon ()
	return self.Icon
end

function House:GetID ()
	return self.ID
end

function House:GetName ()
	return self.Name
end

function House:GetOwnerID ()
	return self.OwnerID
end

function House:GetPrice ()
	return self.Price
end

function House:GetSalePrice ()
	return math.floor (self.Price * 0.5)
end

function House:IsOwned ()
	return self.Owned
end

function House:RemoveDoor (doorOrDoorID)
	if type (doorOrDoorID) == "number" then
		local door = self.Doors [doorOrDoorID]
		door:DispatchEvent ("Removed", doorOrDoorID)
		table.remove (self.Doors, doorOrDoorID)
		self:DispatchEvent ("DoorRemoved", door, doorOrDoorID)
		return
	end
	
	for k, door in ipairs (self.Doors) do
		if door == doorOrDoorID then
			self:RemoveDoor (k)
			return
		end
	end
end

function House:SetCategory (category)
	category = category or ""
	if self.Category == category then return end
	self.Category = category
	self:DispatchEvent ("CategoryChanged", self.Category)
end

function House:SetDescription (description)
	description = description or ""
	if self.Description == description then return end
	self.Description = description
	self:DispatchEvent ("DescriptionChanged", self.Description)
end

function House:SetIcon (icon)
	icon = icon or "icon16/cross.png"
	if self.Icon == icon then return end
	self.Icon = icon
	if SERVER then
		Houses.AddIconResource (self.Icon)
	end
	self:DispatchEvent ("IconChanged", self.Icon)
end

function House:SetName (name)
	name = name or ""
	name = name:sub (1, 1):upper () .. name:sub (2)
	if self.Name == name then return end
	self.Name = name
	self:DispatchEvent ("NameChanged", self.Name)
	
	for door in self:GetDoorIterator () do
		door:UpdateDoorData ()
	end
end

function House:SetOwned (owned)
	if self.Owned == owned then return end
	self.Owned = owned
	if not self.Owned then
		self.OwnerID = nil
	end
	self:DispatchEvent ("OwnerChanged", self.Owned, self.OwnerID)
end

function House:SetOwnerID (ownerID)
	if self.OwnerID == ownerID then return end
	local client = Houses.Clients:GetClientBySteamID (self.OwnerID)
	local ply = client and client:GetPlayer () or nil
	
	if SERVER and self.OwnerID ~= nil then
		if ply then
			for _, door in ipairs (self.Doors) do
				door:RemoveOwner (ply)
			end
		end
	end
	
	self.OwnerID = ownerID
	self.Owned = self.OwnerID ~= nil
	if ply then
		Houses.CountPlayerHouses (ply)
	end
	
	client = Houses.Clients:GetClientBySteamID (self.OwnerID)
	ply = client and client:GetPlayer () or nil
	if SERVER and self.OwnerID ~= nil then
		if ply then
			for _, door in ipairs (self.Doors) do
				door:SetOwner (ply)
			end
		end
	end
	if ply then
		Houses.CountPlayerHouses (ply)
	end
	
	self:DispatchEvent ("OwnerChanged", self.Owned, self.OwnerID)
end

function House:SetPrice (price)
	price = price or 0
	if self.Price == price then return end
	self.Price = price
	self:DispatchEvent ("PriceChanged", self.Price)
end