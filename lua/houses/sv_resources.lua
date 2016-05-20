function Houses.AddIconResource (icon)
	resource.AddFile ("materials/" .. icon .. ".vmt")
	resource.AddFile ("materials/" .. icon .. ".vtf")
	
	if game.SinglePlayer () then
		local vmt = "\"UnlitGeneric\"\n"
		vmt = vmt .. "{\n"
		vmt = vmt .. "\t\"$basetexture\"\t\"" .. icon .. "\"\n"
		vmt = vmt .. "\t\"$ignorez\"\t\"1\"\n"
		vmt = vmt .. "\t\"$vertexcolor\"\t\"1\"\n"
		vmt = vmt .. "\t\"$vertexalpha\"\t\"1\"\n"
		vmt = vmt .. "\t\"$nolod\"\t\"1\"\n"
		vmt = vmt .. "}\n"
		
		if icon:sub (1, 6) == "houses" then
			icon = icon:sub (7)
		end
		file.Write ("houses/" .. icon .. ".txt", vmt)
	end
end

Houses.AddIconResource ("houses/sold")

AddCSLuaFile ("houses/sh_eventprovider.lua")
AddCSLuaFile ("houses/sh_subscriberlist.lua")

AddCSLuaFile ("houses/sh_client.lua")
AddCSLuaFile ("houses/sh_clients.lua")
AddCSLuaFile ("houses/sh_darkrpmoneysystem.lua")

AddCSLuaFile ("houses/sh_init.lua")
AddCSLuaFile ("houses/sh_door.lua")
AddCSLuaFile ("houses/sh_house.lua")
AddCSLuaFile ("houses/sh_houselist.lua")
AddCSLuaFile ("houses/cl_init.lua")
AddCSLuaFile ("houses/cl_networkdeserializer.lua")

AddCSLuaFile ("houses/ui/admin.lua")
AddCSLuaFile ("houses/ui/presalesman.lua")
AddCSLuaFile ("houses/ui/salesman.lua")

AddCSLuaFile ("houses/ui/controls/adminhouseitem.lua")
AddCSLuaFile ("houses/ui/controls/basehouseitem.lua")
AddCSLuaFile ("houses/ui/controls/dooritem.lua")
AddCSLuaFile ("houses/ui/controls/doorlist.lua")
AddCSLuaFile ("houses/ui/controls/houseitem.lua")
AddCSLuaFile ("houses/ui/controls/houselist.lua")

AddCSLuaFile ("houses/ui/dialogs/admin.lua")
AddCSLuaFile ("houses/ui/dialogs/house.lua")
AddCSLuaFile ("houses/ui/dialogs/presales.lua")
AddCSLuaFile ("houses/ui/dialogs/sales.lua")