function Houses.SaveAutospawn ()
	file.CreateDir ("houses")
	file.CreateDir ("houses/autospawn")
	
	local salesman = ents.FindByClass ("npc_house_salesman") [1]
	if not salesman then
		file.Write ("houses/autospawn/" .. game.GetMap () .. ".txt", "")
		return
	end
	
	local tbl = {}
	tbl.x = salesman:GetPos ().x
	tbl.y = salesman:GetPos ().y
	tbl.z = salesman:GetPos ().z
	tbl.pitch = salesman:GetAngles ().p
	tbl.yaw   = salesman:GetAngles ().y
	tbl.roll  = salesman:GetAngles ().r
	
	file.Write ("houses/autospawn/" .. game.GetMap () .. ".txt", util.TableToKeyValues (tbl))
end

concommand.Add ("houses_spawn_realtor",
	function (ply, _, _)
		if not ply or not ply:IsValid () then return end
		if not ply:IsSuperAdmin () then return end
		
		local pos = ply:GetEyeTrace ().HitPos
		if not pos then return end
		
		local salesman = ents.FindByClass ("npc_house_salesman") [1]
		if not salesman then
			salesman = ents.Create ("npc_house_salesman")
			salesman:SetPos (pos)
			salesman:Spawn ()
		end
		
		Houses.SaveAutospawn ()
	end
)

concommand.Add ("houses_save_realtor",
	function (ply, _, _)
		if not ply or not ply:IsValid () then return end
		if not ply:IsSuperAdmin () then return end
		
		Houses.SaveAutospawn ()
	end
)

hook.Add ("InitPostEntity", "Houses.AutospawnNPC",
	function ()
		local data = file.Read ("houses/autospawn/" .. game.GetMap () .. ".txt", "DATA")
		if not data or data == "" then return end
		
		local tbl = util.KeyValuesToTable (data)
		local salesman = ents.Create ("npc_house_salesman")
		salesman:SetPos (Vector (tonumber (tbl.x) or 0, tonumber (tbl.y) or 0, tonumber (tbl.z) or 0))
		salesman:SetAngles (Angle (tonumber (tbl.pitch) or 0, tonumber (tbl.yaw) or 0, tonumber (tbl.roll) or 0))
		salesman:Spawn ()
	end
)