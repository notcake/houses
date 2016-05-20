local PANEL = {}
local Gradient = Material ("gui/gradient_down")
local LocalID = nil

if game.SinglePlayer () then
	LocalID = function ()
		return "STEAM_0:0:0"
	end
else
	LocalID = function ()
		return LocalPlayer ():SteamID ()
	end
end

function PANEL:Init ()
	self.MoneySystem = Houses.MoneySystem
	self.MoneySystem:AddEventListener ("PlayerMoneyChanged", tostring (self), function (moneySystem, steamID, money)
		self:UpdateButton ()
	end)
	
	self.BuyButton = vgui.Create ("DButton", self)
	self.BuyButton:SetText ("Buy")
	
	self.BuyButton.DoClick = function (button)
		if self.House:IsOwned () then
			RunConsoleCommand ("houses_sell", self.House:GetID ())
		else
			RunConsoleCommand ("houses_buy", self.House:GetID ())
		end
	end
end

function PANEL:OnHouseChanged ()
	self:UpdateButton ()
end

function PANEL:OnOwnerChanged ()
	self:UpdateButton ()
end

function PANEL:OnPriceChanged ()
	self:UpdateButton ()
end

function PANEL:OnPerformLayout ()	
	self.BuyButton:SetSize (80, 28)
	self.BuyButton:SetPos (self:GetWide () - 8 - self.BuyButton:GetWide (), self:GetTall () - 8 - self.BuyButton:GetTall ())
	
	self.PriceLabel:SetPos (80, 48)
	self.PriceLabel:SetWide (self:GetWide () - 104 - self.BuyButton:GetWide ())
end

function PANEL:Remove ()
	self:SetHouse (nil)
	
	self.MoneySystem:RemoveEventListener ("PlayerMoneyChanged", tostring (self))
	
	debug.getregistry ().Panel.Remove (self)
end

function PANEL:Think ()
	self.BuyButton:SetVisible (self:IsHovered ())
end

function PANEL:UpdateButton ()
	if self.House:IsOwned () then
		if self.House:GetOwnerID () == LocalID () then
			self.BuyButton:SetDisabled (false)
			self.BuyButton:SetText ("Sell for $ " .. tostring (self.House:GetSalePrice ()))
			self.PriceLabel:SetTextColor (Color (128, 255, 128, 255))
		else
			self.BuyButton:SetDisabled (true)
			self.BuyButton:SetText ("Sold")
		end
	else
		self.BuyButton:SetText ("Buy")
		self.BuyButton:SetDisabled (false)
		if (LocalPlayer ().HouseCount or 0) >= Houses.MaxHouses then
			self.BuyButton:SetDisabled (true)
		end
	end

	if self.House:GetOwnerID () ~= LocalID () then
		self.MoneySystem:CanPlayerAfford (LocalID (), self.House:GetPrice (), function (steamID, canAfford)
			if not self.House:IsOwned () and not canAfford then
				self.BuyButton:SetDisabled (true)
			end
			if canAfford then
				self.PriceLabel:SetTextColor (Color (128, 255, 128, 255))
			else
				self.PriceLabel:SetTextColor (Color (128, 0, 0, 255))
			end
		end)
	end
end

vgui.Register ("HouseItem", PANEL, "BaseHouseItem")