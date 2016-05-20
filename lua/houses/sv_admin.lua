concommand.Add ("houses_admin_ui_opened", function (ply)
	if not ply:IsSuperAdmin () then return end
	if not ply.ReceivedHouseList then
		Houses.Houses.Subscribers:AddPlayer (ply)
		Houses.NetSerializer:SendAllHouses (ply)
		ply.ReceivedHouseList = true
	end
	if not ply.ReceivedHouseDoorList then
		Houses.Houses.DoorSubscribers:AddPlayer (ply)
		Houses.NetSerializer:SendAllDoors (ply)
		ply.ReceivedHouseDoorList = true
	end
end)

concommand.Add ("houses_admin_ui_closed", function (ply)
	if not ply.HouseAdminUIOpen then return end
	ply.HouseAdminUIOpen = false
	-- Houses.Houses.Subscribers:RemovePlayer (ply)
end)

-- reset networking status
for _, ply in ipairs (player.GetAll ()) do
	ply.HouseAdminUIOpen = false
	ply.ReceivedHouseDoorList = false
end

-- admin
concommand.Add ("houses_delete", function (ply, _, args)
	if ply and ply:IsValid () and not ply:IsSuperAdmin () then return end
	if not Houses.Houses:GetHouse (args [1]) then return end
	
	Houses.Houses:RemoveHouse (args [1])
	
	timer.Create ("HousesSave", 10, 1, function ()
		Houses.FileSerializer:SaveHouses ()
	end)
end)

concommand.Add ("houses_goto", function (ply, _, args)
	if ply and ply:IsValid () and not ply:IsSuperAdmin () then return end
	if not Houses.Houses:GetHouse (args [1]) then return end
	
	local house = Houses.Houses:GetHouse (args [1])
	local door = house:GetDoor (1)
	if not door then return end
	
	ply:SetPos (door:GetPosition ())
end)

util.AddNetworkString ("HouseData")
net.Receive ("HouseData", function (_, ply)
	if ply and ply:IsValid () and not ply:IsSuperAdmin () then return end
	
	local houseId     = net.ReadString ()
	local name        = net.ReadString ()
	local description = net.ReadString ()
	local category    = net.ReadString ()
	local icon        = net.ReadString ()
	local price       = net.ReadDouble ()
	
	if not houseId or houseId == "" then
		return
	end
	local house = Houses.Houses:GetHouse (houseId)
	if not house then
		house = Houses.House (houseId)
	end
	
	house:SetName (name)
	house:SetDescription (description)
	house:SetCategory (category)
	house:SetIcon (icon)
	house:SetPrice (tonumber (price))
	
	if not Houses.Houses:GetHouse (houseId) then
		Houses.Houses:AddHouse (house)
	end
	
	timer.Create ("HousesSave", 1, 1, function ()
		Houses.FileSerializer:SaveHouses ()
	end)
end)

-- doors
concommand.Add ("houses_add_door", function (ply, _, args)
	if ply and ply:IsValid () and not ply:IsSuperAdmin () then return end
	if #args < 2 then return end
	
	local id = args [1]
	local entID = tonumber (args [2])
	local house = Houses.Houses:GetHouse (id)
	if not house then return end
	local ent = ents.GetByIndex (entID)
	if not ent or not ent:IsValid () then return end
	
	local class = ent:GetClass ()
	if class ~= "func_door" and
		class ~= "func_door_rotating" and
		class ~= "prop_door_rotating" and
		class ~= "prop_dynamic" then
		return
	end
	
	local pos = ent:GetPos ()
	local model = ent:GetModel ()
	
	for door in house:GetDoorIterator () do
		if door:GetPosition () == pos and door:GetModel () == model then
			return
		end
	end
	
	local door = Houses.Door ()
	door:SetPosition (ent:GetPos ())
	door:SetModel (ent:GetModel ())
	door:Link ()
	
	house:AddDoor (door)
	
	timer.Create ("HousesSave", 10, 1, function ()
		Houses.FileSerializer:SaveHouses ()
	end)
end)

concommand.Add ("houses_remove_door", function (ply, _, args)
	if ply and ply:IsValid () and not ply:IsSuperAdmin () then return end
	if #args < 2 then return end
	
	local id = args [1]
	local doorID = tonumber (args [2])
	local house = Houses.Houses:GetHouse (id)
	if not house then return end
	if not house:GetDoor (doorID) then return end
	
	house:RemoveDoor (doorID)
	
	timer.Create ("HousesSave", 10, 1, function ()
		Houses.FileSerializer:SaveHouses ()
	end)
end)