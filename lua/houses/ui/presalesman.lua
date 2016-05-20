if Houses.PreSalesUI then
	Houses.PreSalesUI:Remove ()
	Houses.PreSalesUI = nil
end
Houses.PreSalesUI = nil

usermessage.Hook ("houses_open_pre_sales_ui", function (umsg)
	Houses.PreSalesUI = Houses.PreSalesUI or vgui.Create ("HousePreSalesDialog")
	Houses.PreSalesUI:SetVisible (true)
end)