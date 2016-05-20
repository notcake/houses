local HouseSerializer = {}
Houses.HouseSerializer = Houses.MakeConstructor (HouseSerializer)

function HouseSerializer:ctor (houses)
	file.CreateDir ("houses")
	file.CreateDir ("houses/autospawn")
	self.File = "houses/" .. game.GetMap () .. ".txt"
	self.Houses = houses
end

function HouseSerializer:LoadHouses ()
	local fileContents = file.Read (self.File, "DATA") or ""
	local tbl = util.KeyValuesToTable (fileContents)
	
	for _, houseData in pairs (tbl) do
		local house = Houses.House (houseData.id)
		house:SetName (houseData.name)
		house:SetCategory (houseData.category)
		house:SetDescription (houseData.description)
		house:SetIcon (houseData.icon)
		house:SetPrice (tonumber (houseData.price))
		
		for _, doorData in pairs (houseData.doors or {}) do
			local door = Houses.Door ()
			door:SetPosition (Vector (tonumber (doorData.x), tonumber (doorData.y), tonumber (doorData.z)))
			door:SetModel (doorData.model)
			door:Link ()
			
			house:AddDoor (door)
		end
		
		self.Houses:AddHouse (house)
	end
end

function HouseSerializer:SaveHouses ()
	local tbl = {}
	for _, house in self.Houses:GetHouseIterator () do
		local houseData = {}
		houseData.id = house:GetID ()
		houseData.name = house:GetName ()
		houseData.category = house:GetCategory ()
		houseData.description = house:GetDescription ()
		houseData.icon = house:GetIcon ()
		houseData.price = tostring (house:GetPrice ())
		houseData.doors = {}
		
		for door in house:GetDoorIterator () do
			local doorData = {}
			doorData.x = tostring (door:GetPosition ().x)
			doorData.y = tostring (door:GetPosition ().y)
			doorData.z = tostring (door:GetPosition ().z)
			doorData.model = door:GetModel ()
			
			houseData.doors [#houseData.doors + 1] = doorData
		end
		
		tbl [#tbl + 1] = houseData
	end
	
	local fileContents = util.TableToKeyValues (tbl)
	file.Write (self.File, fileContents)
end