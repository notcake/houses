local PANEL = {}
local Gradient = Material ("gui/gradient_down")
local Sold = Material ("houses/sold")

function PANEL:Init ()
	self:SetTall (80)
	
	self.House = nil
	self.SortKey = ""
	
	self.Image = vgui.Create ("DImage", self)
	self.NameLabel = vgui.Create ("DLabel", self)
	self.NameLabel:SetFont ("TargetID")
	self.NameLabel:SetTextColor (Color (255, 255, 255, 255))
	
	self.DescriptionLabel = vgui.Create ("DLabel", self)
	self.DescriptionLabel:SetTextColor (Color (255, 255, 255, 255))
	
	self.PriceLabel = vgui.Create ("DLabel", self)
	self.PriceLabel:SetFont ("TargetID")
	self.PriceLabel:SetContentAlignment (6)
	self.PriceLabel:SetTextColor (Color (255, 255, 255, 255))
end

function PANEL:GetHouse ()
	return self.House
end

function PANEL:IsHovered ()
	local x, y = self:CursorPos ()
	if x < 0 then return false end
	if y < 0 then return false end
	if x >= self:GetWide () then return false end
	if y >= self:GetTall () then return false end
	return true
end

function PANEL:OnHouseChanged ()
end

function PANEL:OnOwnerChanged ()
end

function PANEL:OnPriceChanged ()
end
	
function PANEL:Paint ()
	if self.Selected then
		draw.RoundedBox (4, 0, 0, self:GetWide (), self:GetTall (), Color (128, 128, 255, 128))
	else
		draw.RoundedBox (4, 0, 0, self:GetWide (), self:GetTall (), Color (128, 128, 128, 128))
	end
	surface.SetDrawColor (255, 255, 255, 32)
	surface.SetMaterial (Gradient)
	surface.DrawTexturedRect (0, 0, self:GetWide (), self:GetTall ())
end
	
function PANEL:PaintOver ()
	if self.House and self.House:IsOwned () then
		surface.SetDrawColor (255, 255, 255, 255)
		surface.SetMaterial (Sold)
		surface.DrawTexturedRect (8, 8, 64, 64)
	end
	if self:IsHovered () then
		surface.SetDrawColor (255, 255, 255, 32)
		surface.SetMaterial (Gradient)
		surface.DrawTexturedRect (0, 0, self:GetWide (), self:GetTall ())
	end
end

function PANEL:PerformLayout ()
	self.Image:SetPos (8, 8)
	self.Image:SetSize (64, 64)
	
	self.NameLabel:SetPos (80, 8)
	self.NameLabel:SetWide (self:GetWide () - 72)
	self.DescriptionLabel:SetPos (80, 32)
	self.DescriptionLabel:SetWide (self:GetWide () - 72)
	
	self.PriceLabel:SetPos (80, 48)
	self.PriceLabel:SetWide (self:GetWide () - 96)
	
	self:OnPerformLayout ()
end

function PANEL:Remove ()
	self:SetHouse (nil)
	
	debug.getregistry ().Panel.Remove (self)
end

function PANEL:SetHouse (house)
	if house == self.House then
		return
	end
	if self.House then
		self.House:RemoveEventListener ("NameChanged", tostring (self))
		self.House:RemoveEventListener ("CategoryChanged", tostring (self))
		self.House:RemoveEventListener ("DescriptionChanged", tostring (self))
		self.House:RemoveEventListener ("IconChanged", tostring (self))
		self.House:RemoveEventListener ("OwnerChanged", tostring (self))
		self.House:RemoveEventListener ("PriceChanged", tostring (self))
	end
	self.House = house
	if self.House then
		self.SortKey = self.House:GetName ()
		local number = ""
		while tonumber (self.SortKey:sub (self.SortKey:len ())) do
			number = self.SortKey:sub (self.SortKey:len ()) .. number
			self.SortKey = self.SortKey:sub (1, self.SortKey:len () - 1)
		end
		self.SortKey = self.SortKey .. string.Right ("000000" .. number, 6)
	
		self.Image:SetImage (self.House:GetIcon ())
		self.NameLabel:SetText (self.House:GetName ())
		self.DescriptionLabel:SetText (self.House:GetDescription ())
		self.PriceLabel:SetText ("$ " .. tostring (self.House:GetPrice ()))

		self:OnHouseChanged ()
		
		self.House:AddEventListener ("NameChanged", tostring (self), function (house, name)
			self.NameLabel:SetText (name)
		end)
		self.House:AddEventListener ("DescriptionChanged", tostring (self), function (house, description)
			self.DescriptionLabel:SetText (description)
		end)
		self.House:AddEventListener ("IconChanged", tostring (self), function (house, icon)
			self.Image:SetImage (icon)
		end)
		self.House:AddEventListener ("OwnerChanged", tostring (self), function (house, owned, ownerID)
			self:OnOwnerChanged ()
		end)
		self.House:AddEventListener ("PriceChanged", tostring (self), function (house, price)
			self.PriceLabel:SetText ("$ " .. tostring (price))
			self:OnPriceChanged ()
		end)
	end
end

vgui.Register ("BaseHouseItem", PANEL, "DPanel")