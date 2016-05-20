local PANEL = {}

function PANEL:Init ()
	self:SetTitle ("House Sales")
	
	self:SetSize (ScrW () * 0.5, ScrH () * 0.75)
	self:Center ()
	
	self:MakePopup ()
	self:SetDeleteOnClose (false)
	
	self.Houses = vgui.Create ("HouseList", self)
	self.Houses:Populate ()
	
	self:SetSkin ("DarkRP")
	self:InvalidateLayout ()
end

function PANEL:PerformLayout ()
	DFrame.PerformLayout (self)
	
	if self.Houses then
		self.Houses:SetPos (8, 28)
		self.Houses:SetSize (self:GetWide () - 16, self:GetTall () - 36)
	end
end

function PANEL:Remove ()
	self:SetVisible (false)
	self.Houses:Remove ()
	debug.getregistry ().Panel.Remove (self)
end

function PANEL:SetVisible (visible)
	debug.getregistry ().Panel.SetVisible (self, visible)
	
	if visible then
		Houses.CountPlayerHouses (LocalPlayer ())
	else
		RunConsoleCommand ("houses_sales_ui_closed")
	end
end

vgui.Register ("HouseSalesDialog", PANEL, "DFrame")