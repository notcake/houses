local self = {}Houses.MoneySystem = Houses.MakeConstructor (self)function self:ctor ()	Houses.EventProvider (self)		if CLIENT then		local ownMoney = 0		timer.Create ("DarkRPMoneySystem", 1, 0, function ()			if not LocalPlayer then return end			if not LocalPlayer () then return end			if not LocalPlayer ():IsValid () then return end			if not LocalPlayer ().SteamID then return end						self:GetPlayerMoney (LocalPlayer ():SteamID (), function (steamID, money)				if ownMoney ~= money then					self:DispatchEvent ("PlayerMoneyChanged", steamID, money)					ownMoney = money				end			end)		end)	endendfunction self:AddPlayerMoney (steamID, deltamoney)	Houses.Clients:GetClientBySteamID (steamID):GetPlayer ():AddMoney (deltamoney)endfunction self:CanPlayerAfford (steamID, money, callback)	if CLIENT and game.SinglePlayer () and steamID == "STEAM_0:0:0" then		steamID = LocalPlayer ():SteamID ()	end		local ply = Houses.Clients:GetClientBySteamID (steamID):GetPlayer ()	if not ply.DarkRPVars then		callback (steamID, false)		return	end	callback (steamID, ply.DarkRPVars.money >= money)endfunction self:GetPlayerMoney (steamID, callback)	if CLIENT and game.SinglePlayer () and steamID == "STEAM_0:0:0" then		steamID = LocalPlayer ():SteamID ()	end		local ply = Houses.Clients:GetClientBySteamID (steamID):GetPlayer ()	if not ply.DarkRPVars then		callback (steamID, 0)		return	end	callback (steamID, ply.DarkRPVars.money)endfunction self:RemovePlayerMoney (steamID, deltamoney)	local ply = Houses.Clients:GetClientBySteamID (steamID):GetPlayer ()	if not ply.AddMoney then return end	ply:AddMoney (-deltamoney)endfunction self:SetPlayerMoney (steamID, money)	local ply = Houses.Clients:GetClientBySteamID (steamID):GetPlayer ()	if not DB then return end	DB.StoreMoney (ply, money)endtimer.Simple (1,	function ()		Houses.MoneySystem = Houses.MoneySystem ()	end)