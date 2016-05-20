if Houses.SalesUI then
	Houses.SalesUI:Remove ()
	Houses.SalesUI = nil
end
Houses.SalesUI = nil

usermessage.Hook ("houses_open_sales_ui", function (umsg)
	Houses.SalesUI = Houses.SalesUI or vgui.Create ("HouseSalesDialog")
	Houses.SalesUI:SetVisible (true)
end)

usermessage.Hook ("houses_close_sales_ui", function (umsg)
	if not Houses.SalesUI or not Houses.SalesUI:IsValid () then return end
	Houses.SalesUI:SetVisible (false)
end)