if Houses.AdminUI then
	Houses.AdminUI:Remove ()
	Houses.AdminUI = nil
end
Houses.AdminUI = nil

concommand.Add ("houses_admin", function (ply, _, _)
	if not ply:IsSuperAdmin () then return end
	
	Houses.AdminUI = Houses.AdminUI or vgui.Create ("HouseAdminDialog")
	Houses.AdminUI:SetVisible (true)
end)