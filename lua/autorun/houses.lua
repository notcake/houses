if SERVER then
	AddCSLuaFile ("autorun/houses.lua")
	concommand.Add ("houses_reload_sv", function (ply, _, _)
		if ply and ply:IsValid () and not ply:IsSuperAdmin () then
			return
		end
		include ("autorun/houses.lua")
		
		for _, ply in ipairs (player.GetAll ()) do
			ply:ConCommand ("houses_reload")
		end
	end)
elseif CLIENT then
	concommand.Add ("houses_reload", function ()
		include ("autorun/houses.lua")
	end)
end

include ("houses/sh_init.lua")