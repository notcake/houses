local PANEL = {}

function PANEL:Init ()
	self:SetTitle ("Realtor")
	
	self:SetSize (384, 120)
	self:Center ()
	self:MakePopup ()
	
	self:SetDeleteOnClose (false)

	self.SpeechLabel = vgui.Create ("DLabel", self)
	self.SpeechLabel:SetText ("Good afternoon! Would you be interested in buying a house?")
	
	self.YesButton = vgui.Create ("DButton", self)
	self.YesButton:SetText ("Yes, I would.")
	
	self.YesButton.DoClick = function (button)
		RunConsoleCommand ("houses_open_sales_ui")
		self:Close ()
	end
	
	self.NoButton = vgui.Create ("DButton", self)
	self.NoButton:SetText ("No.")
	
	self.NoButton.DoClick = function (button)
		self:Close ()
	end
	
	self:SetSkin ("DarkRP")
	self:InvalidateLayout ()
end

function PANEL:PerformLayout ()
	DFrame.PerformLayout (self)
	
	if self.SpeechLabel then
		self.SpeechLabel:SetPos (8, 28)
		self.SpeechLabel:SetWide (self:GetWide () - 16)
		
		self.YesButton:SetPos (8, 64)
		self.YesButton:SetSize (self:GetWide () - 16, 20)
		self.NoButton:SetPos (8, 72 + self.YesButton:GetTall ())
		self.NoButton:SetSize (self:GetWide () - 16, self.YesButton:GetTall ())
	end
end

function PANEL:SetVisible (visible)
	debug.getregistry ().Panel.SetVisible (self, visible)
	
	if visible then
	else
		RunConsoleCommand ("houses_pre_sales_ui_closed")
	end
end

vgui.Register ("HousePreSalesDialog", PANEL, "DFrame")