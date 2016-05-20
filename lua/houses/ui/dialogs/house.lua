local PANEL = {}

function PANEL:Init ()
	self:SetTitle ("Edit house...")

	self:SetSize (ScrW () * 0.3, 216)
	self:Center ()
	
	self:MakePopup ()
	
	self.IDLabel = vgui.Create ("DLabel", self)
	self.IDValue = vgui.Create ("DLabel", self)
	self.NameLabel = vgui.Create ("DLabel", self)
	self.DescriptionLabel = vgui.Create ("DLabel", self)
	self.PriceLabel = vgui.Create ("DLabel", self)
	self.CategoryLabel = vgui.Create ("DLabel", self)
	self.IconLabel = vgui.Create ("DLabel", self)
	
	self.IDLabel:SetText ("ID:")
	self.IDValue:SetText ("")
	self.NameLabel:SetText ("Name:")
	self.DescriptionLabel:SetText ("Description:")
	self.PriceLabel:SetText ("Price:")
	self.CategoryLabel:SetText ("Category:")
	self.IconLabel:SetText ("Icon:")
	
	self.IDEntry = vgui.Create ("DTextEntry", self)
	self.IDEntry.OnTextChanged = function (textEntry)
		self.IDValue:SetText (self.IDEntry:GetText ())
	end
	
	self.NameEntry = vgui.Create ("DTextEntry", self)
	self.DescriptionEntry = vgui.Create ("DTextEntry", self)
	self.PriceEntry = vgui.Create ("DTextEntry", self)
	self.CategoryEntry = vgui.Create ("DTextEntry", self)
	self.IconEntry = vgui.Create ("DTextEntry", self)

	self.SaveButton = vgui.Create ("DButton", self)
	self.SaveButton:SetText ("Save")
	
	self.SaveButton.DoClick = function (button)
		net.Start ("HouseData")
			net.WriteString (self.IDValue:GetText ())
			net.WriteString (self.NameEntry:GetText ())
			net.WriteString (self.DescriptionEntry:GetText ())
			net.WriteDouble (tonumber (self.PriceEntry:GetText ()) or 0)
			net.WriteString (self.CategoryEntry:GetText ())
			net.WriteString (self.IconEntry:GetText ())
		net.SendToServer ()
		
		self:Close ()
	end
	
	self.CancelButton = vgui.Create ("DButton", self)
	self.CancelButton:SetText ("Cancel")
	
	self.CancelButton.DoClick = function (button)
		self:Close ()
	end
	
	self:SetSkin ("DarkRP")
	self:InvalidateLayout ()
end

function PANEL:PerformLayout ()
	DFrame.PerformLayout (self)
	
	if self.IDLabel then
		self.IDLabel:SetPos (8, 28)
		self.NameLabel:SetPos (8, 28 + 24)
		self.DescriptionLabel:SetPos (8, 28 + 24 * 2)
		self.PriceLabel:SetPos (8, 28 + 24 * 3)
		self.CategoryLabel:SetPos (8, 28 + 24 * 4)
		self.IconLabel:SetPos (8, 28 + 24 * 5)
		
		self.IDEntry:SetPos (128, 28)
		self.IDValue:SetPos (128, 28)
		self.NameEntry:SetPos (128, 28 + 24)
		self.DescriptionEntry:SetPos (128, 28 + 24 * 2)
		self.PriceEntry:SetPos (128, 28 + 24 * 3)
		self.CategoryEntry:SetPos (128, 28 + 24 * 4)
		self.IconEntry:SetPos (128, 28 + 24 * 5)
		
		self.IDEntry:SetWide (self:GetWide () - 136)
		self.IDValue:SetWide (self:GetWide () - 136)
		self.NameEntry:SetWide (self:GetWide () - 136)
		self.DescriptionEntry:SetWide (self:GetWide () - 136)
		self.PriceEntry:SetWide (self:GetWide () - 136)
		self.CategoryEntry:SetWide (self:GetWide () - 136)
		self.IconEntry:SetWide (self:GetWide () - 136)
		
		self.SaveButton:SetSize (80, 28)
		self.CancelButton:SetSize (80, 28)
		
		self.CancelButton:SetPos (self:GetWide () - 8 - self.CancelButton:GetWide (), self:GetTall () - 8 - self.CancelButton:GetTall ())
		self.SaveButton:SetPos (self:GetWide () - 16 - self.SaveButton:GetWide () - self.CancelButton:GetWide (), self:GetTall () - 8 - self.SaveButton:GetTall ())
	end
end

function PANEL:SetHouse (house)
	self.IDEntry:SetVisible (false)
	self.IDValue:SetText (house:GetID ())
	self.NameEntry:SetText (house:GetName ())
	self.DescriptionEntry:SetText (house:GetDescription ())
	self.PriceEntry:SetText (tostring (house:GetPrice ()))
	self.CategoryEntry:SetText (house:GetCategory ())
	self.IconEntry:SetText (house:GetIcon ())
end

function PANEL:Remove ()
	debug.getregistry ().Panel.Remove (self)
end

vgui.Register ("HouseDialog", PANEL, "DFrame")