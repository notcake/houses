local HouseSerializer = {}
Houses.PERPHouseSerializer = Houses.MakeConstructor (HouseSerializer)

function HouseSerializer:ctor (houseList)
	self.HouseList = houseList
end

function HouseSerializer:LoadHouses ()
	local _GAMEMODE = GAMEMODE
	GAMEMODE = {}
	GAMEMODE.HouseList = self.HouseList
	
	function GAMEMODE:RegisterProperty (property)
		local house = Houses.House (property.Name)
		house:SetName (property.Name)
		house:SetCategory (property.Category)
		house:SetDescription (property.Description)
		house:SetIcon ("houses/" .. property.Image)
		house:SetPrice (property.Cost)
		
		for _, propertyDoor in ipairs (property.Doors) do
			local door = Houses.Door ()
			door:SetPosition (propertyDoor [1])
			door:SetModel (propertyDoor [2])
			door:Link ()
			
			house:AddDoor (door)
		end
		
		self.HouseList:AddHouse (house)
	end
	
	for _, houseFile in ipairs (file.Find ("houses/properties/" .. game.GetMap () .. "/*.lua", "LUA")) do
		include ("houses/properties/" .. game.GetMap () .. "/" .. houseFile)
	end
	
	GAMEMODE = _GAMEMODE
end