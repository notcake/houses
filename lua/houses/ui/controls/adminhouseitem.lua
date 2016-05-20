local PANEL = {}

function PANEL:Init ()
	self.ButtonsAlwaysVisible = false
	self.HideDoorsButton = false
	
	self.EditButton = vgui.Create ("DButton", self)
	self.EditButton:SetText ("Edit")
	
	self.EditButton.DoClick = function (button)
		if not self:GetHouse () then return end
		local dialog = vgui.Create ("HouseDialog")
		dialog:SetHouse (self:GetHouse ())
		dialog:SetVisible (true)
	end
	
	self.DeleteButton = vgui.Create ("DButton", self)
	self.DeleteButton:SetText ("Delete")
	
	self.DeleteButton.DoClick = function (button)
		if not self:GetHouse () then return end
		RunConsoleCommand ("houses_delete", self:GetHouse ():GetID ())
	end
	
	self.GoToButton = vgui.Create ("DButton", self)
	self.GoToButton:SetText ("Go to")
	
	self.GoToButton.DoClick = function (button)
		if not self:GetHouse () then return end
		RunConsoleCommand ("houses_goto", self:GetHouse ():GetID ())
	end
	
	self.DoorsButton = vgui.Create ("DButton", self)
	self.DoorsButton:SetText ("Doors >")
	
	self.DoorsButton.DoClick = function (button)
		self:GetParent ():GetParent ():GetParent ():GetParent ():SetSelectedHouse (self.House)
	end
end

function PANEL:OnPerformLayout ()
	self.EditButton:SetSize (80, 28)
	self.DeleteButton:SetSize (80, 28)
	self.GoToButton:SetSize (80, 28)
	self.DoorsButton:SetSize (80, 28)
	
	self.EditButton:SetPos (80, 48)
	self.DeleteButton:SetPos (168, 48)
	self.GoToButton:SetPos (256, 48)
	self.DoorsButton:SetPos (344, 48)
end

function PANEL:SetButtonsAlwaysVisible (buttonsAlwaysVisible)
	self.ButtonsAlwaysVisible = buttonsAlwaysVisible
end

function PANEL:SetHideDoorsButton (hideDoorsButton)
	self.HideDoorsButton = hideDoorsButton
end

function PANEL:Think ()
	local hovered = self:IsHovered () or self.ButtonsAlwaysVisible
	self.EditButton:SetVisible (hovered)
	self.DeleteButton:SetVisible (hovered)
	self.GoToButton:SetVisible (hovered)
	self.DoorsButton:SetVisible (hovered and not self.HideDoorsButton)
end

vgui.Register ("AdminHouseItem", PANEL, "BaseHouseItem")