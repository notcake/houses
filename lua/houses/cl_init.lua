for _, v in ipairs (file.Find ("houses/ui/*.lua", "LUA")) do
	include ("houses/ui/" .. v)
end

for _, v in ipairs (file.Find ("houses/ui/controls/*.lua", "LUA")) do
	include ("houses/ui/controls/" .. v)
end

for _, v in ipairs (file.Find ("houses/ui/dialogs/*.lua", "LUA")) do
	include ("houses/ui/dialogs/" .. v)
end

include ("cl_networkdeserializer.lua")

local deserializer = Houses.NetworkDeserializer (Houses.Houses)