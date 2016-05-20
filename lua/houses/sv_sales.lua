function Houses.OpenPreSalesmanUI (ply)
	if ply.HousePreSalesUIOpen then return end
	ply.HousePreSalesUIOpen = true

	umsg.Start ("houses_open_pre_sales_ui", ply)
	umsg.End ()
end

function Houses.OpenSalesmanUI (ply)
	if ply.HouseSalesUIOpen then return end
	ply.HouseSalesUIOpen = true

	umsg.Start ("houses_open_sales_ui", ply)
	umsg.End ()
	if not ply.ReceivedHouseList then
		Houses.Houses.Subscribers:AddPlayer (ply)
		Houses.NetSerializer:SendAllHouses (ply)
		ply.ReceivedHouseList = true
	end
end

concommand.Add ("houses_open_sales_ui", function (ply)
	if not ply.HousePreSalesUIOpen then return end
	Houses.OpenSalesmanUI (ply)
end)

concommand.Add ("houses_pre_sales_ui_closed", function (ply)
	if not ply.HousePreSalesUIOpen then return end
	ply.HousePreSalesUIOpen = false
end)

concommand.Add ("houses_sales_ui_closed", function (ply)
	if not ply.HouseSalesUIOpen then return end
	ply.HouseSalesUIOpen = false
end)

-- reset networking status
for _, ply in ipairs (player.GetAll ()) do
	ply.HousePreSalesUIOpen = false
	ply.HouseSalesUIOpen = false
	ply.ReceivedHouseList = false
end

concommand.Add ("houses_buy", function (ply, _, args)
	if not ply or not ply:IsValid () then return end
	if not ply.HouseSalesUIOpen then return end
	
	local id = args [1]
	local house = Houses.Houses:GetHouse (id)
	
	if not house or house:IsOwned () then return end
	local price = house:GetPrice ()
	
	if (ply.HouseCount or 0) >= Houses.MaxHouses then return end
	
	Houses.MoneySystem:CanPlayerAfford (ply:SteamID (), price, function (steamID, canAfford)
		if not canAfford then return end
		if house:IsOwned () then return end
		
		house:SetOwnerID (steamID)
		Houses.MoneySystem:RemovePlayerMoney (steamID, price)
		
		GAMEMODE:TalkToPerson (ply, Color (255, 255, 255, 255), "You bought " .. house:GetName () .." for $ " .. tostring (house:GetPrice ()) .. ".")
		GAMEMODE:Notify (ply, NOTIFY_GENERIC, 4, "You bought " .. house:GetName () .." for $ " .. tostring (house:GetPrice ()) .. ".")
		
		umsg.Start ("houses_close_sales_ui", ply)
		umsg.End ()
	end)
end)

concommand.Add ("houses_sell", function (ply, _, args)
	if not ply or not ply:IsValid () then return end
	if not ply.HouseSalesUIOpen then return end
	
	local id = args [1]
	local house = Houses.Houses:GetHouse (id)
	
	if not house or house:GetOwnerID () ~= ply:SteamID () then return end
	
	house:SetOwnerID (nil)
	Houses.MoneySystem:AddPlayerMoney (ply:SteamID (), house:GetSalePrice ())
	
	GAMEMODE:TalkToPerson (ply, Color (255, 255, 255, 255), "You sold " .. house:GetName () .. " for $ " .. tostring (house:GetSalePrice ()) .. ".")
	GAMEMODE:Notify (ply, NOTIFY_GENERIC, 4, "You sold " .. house:GetName () .. " for $ " .. tostring (house:GetSalePrice ()) .. ".")
end)