local NetworkDeserializer = {}
Houses.NetworkDeserializer = Houses.MakeConstructor (NetworkDeserializer)

function NetworkDeserializer:ctor (houses)
	self.Houses = houses
	
	usermessage.Hook ("houses_clear", function (umsg)
		self.Houses:Clear ()
	end)
	
	usermessage.Hook ("houses_deleted", function (umsg)
		self.Houses:RemoveHouse (umsg:ReadString ())
	end)
	
	usermessage.Hook ("houses_house", function (umsg)
		local id = umsg:ReadString ()
		local house = self.Houses:GetHouse (id)
		if not house then
			house = Houses.House (id)
		end
		house:SetName (umsg:ReadString ())
		house:SetCategory (umsg:ReadString ())
		house:SetDescription (umsg:ReadString ())
		house:SetIcon (umsg:ReadString ())
		house:SetPrice (umsg:ReadLong ())
		local ownerID = umsg:ReadString ()
		if ownerID ~= "" then
			house:SetOwnerID (ownerID)
		end
		
		if not self.Houses:GetHouse (id) then
			self.Houses:AddHouse (house)
		end
	end)
	
	for _, property in ipairs ({"Name", "Category", "Description", "Icon"}) do
		usermessage.Hook ("houses_" .. property:lower  (), function (umsg)
			local house = self.Houses:GetHouse (umsg:ReadString ())
			house ["Set" .. property] (house, umsg:ReadString ())
		end)
	end
	
	usermessage.Hook ("houses_owner", function (umsg)
		local house = self.Houses:GetHouse (umsg:ReadString ())
		local owned = umsg:ReadBool ()
		local ownerID = umsg:ReadString ()
		house:SetOwnerID (owned and ownerID or nil)
	end)
	
	usermessage.Hook ("houses_price", function (umsg)
		local house = self.Houses:GetHouse (umsg:ReadString ())
		house:SetPrice (umsg:ReadLong ())
	end)
	
	-- doors
	usermessage.Hook ("houses_door", function (umsg)
		local house = self.Houses:GetHouse (umsg:ReadString ())
		local door = Houses.Door ()
		door:SetPosition (umsg:ReadVector ())
		door:SetModel (umsg:ReadString ())
		house:AddDoor (door)
	end)
	
	usermessage.Hook ("houses_door_removed", function (umsg)
		local house = self.Houses:GetHouse (umsg:ReadString ())
		house:RemoveDoor (umsg:ReadLong ())
	end)
end