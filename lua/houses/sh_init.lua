Houses = Houses or {}

function Houses.MakeConstructor (metatable, base)
	metatable.__index = metatable
	
	if base then
		local name, basetable = debug.getupvalue (base, 1)
		metatable.__base = basetable
		setmetatable (metatable, basetable)
	end
	
	return function (...)
		local object = {}
		setmetatable (object, metatable)
		
		-- Call base constructors
		local base = object.__base
		local basectors = {}
		while base ~= nil do
			basectors [#basectors + 1] = base.ctor
			base = base.__base
		end
		for i = #basectors, 1, -1 do
			basectors [i] (object, ...)
		end
		
		-- Call object constructor
		if object.ctor then
			object:ctor (...)
		end
		return object
	end
end

include ("houses/sh_eventprovider.lua")
include ("houses/sh_subscriberlist.lua")

include ("houses/sh_client.lua")
include ("houses/sh_clients.lua")
include ("houses/sh_darkrpmoneysystem.lua")

include ("houses/sh_houselist.lua")
include ("houses/sh_house.lua")
include ("houses/sh_door.lua")

Houses.Houses = Houses.HouseList ()

if SERVER then
	include ("houses/sv_init.lua")
elseif CLIENT then
	include ("houses/cl_init.lua")
end

Houses.MaxHouses = 5

function Houses.CountPlayerHouses (ply)
	local steamID = ply:SteamID ()
	if CLIENT and game.SinglePlayer () then
		steamID = "STEAM_0:0:0"
	end
	local count = 0
	for _, house in Houses.Houses:GetHouseIterator () do
		if house:GetOwnerID () == steamID then
			count = count + 1
		end
	end
	
	ply.HouseCount = count
	return count
end