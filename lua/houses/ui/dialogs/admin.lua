local PANEL = {}

function PANEL:Init ()
	self:SetTitle ("House Administration")
	
	self:SetSize (ScrW () * 0.5, ScrH () * 0.75)
	self:Center ()
	
	self:MakePopup ()
	self:SetDeleteOnClose (false)
	
	-- main screen
	self.Houses = vgui.Create ("HouseList", self)
	self.Houses:SetItemClass ("AdminHouseItem")
	self.Houses:Populate ()
	
	self.NewButton = vgui.Create ("DButton", self)
	self.NewButton:SetText ("New house...")
	
	self.NewButton.DoClick = function (button)
		local dialog = vgui.Create ("HouseDialog")
		dialog:SetVisible (true)
	end
	
	-- doors screen
	self.SelectedHouse = nil
	self.BackButton = vgui.Create ("DButton", self)
	self.BackButton:SetText ("< Back")
	self.BackButton:SetSize (80, 28)
	
	self.BackButton.DoClick = function (button)
		self:SetSelectedHouse (nil)
	end
	
	self.HouseItem = vgui.Create ("AdminHouseItem", self)
	self.HouseItem:SetButtonsAlwaysVisible (true)
	self.HouseItem:SetHideDoorsButton (true)
	
	self.Door = nil
	self.Doors = vgui.Create ("HouseDoorList", self)
	
	self.AddDoorButton = vgui.Create ("DButton", self)
	self.AddDoorButton:SetText ("Add door")
	self.AddDoorButton:SetSize (80, 28)
	
	self.AddDoorButton.DoClick = function (button)
		local ent = self.Door
		if not ent or not ent:IsValid () then return end
		local class = ent:GetClass ()
		if class ~= "func_door" and
			class ~= "func_door_rotating" and
			class ~= "prop_door_rotating" and
			class ~= "prop_dynamic" then
			return
		end
		
		RunConsoleCommand ("houses_add_door", self.SelectedHouse:GetID (), ent:EntIndex ())
	end
	
	self:SetSkin ("DarkRP")
	self:InvalidateLayout ()
end

function PANEL:OnKeyCodePressed (key)
	if key == KEY_N then
		self:SetVisible (false)
	end
end

function PANEL:PerformLayout ()
	DFrame.PerformLayout (self)
	
	if self.Houses then
		local mainView = self.SelectedHouse == nil
		self.Houses:SetVisible (mainView)
		self.NewButton:SetVisible (mainView)
		self.BackButton:SetVisible (not mainView)
		self.HouseItem:SetVisible (not mainView)
		self.Doors:SetVisible (not mainView)
		self.AddDoorButton:SetVisible (not mainView)
		
		self.NewButton:SetSize (80, 28)
		self.NewButton:SetPos (8, self:GetTall () - 8 - self.NewButton:GetTall ())
	
		self.Houses:SetPos (8, 28)
		self.Houses:SetSize (self:GetWide () - 16, self:GetTall () - 44 - self.NewButton:GetTall ())
		
		self.BackButton:SetPos (8, 28)
		self.HouseItem:SetPos (8, 36 + self.BackButton:GetTall ())
		self.HouseItem:SetWide (self:GetWide () - 16)
		
		self.Doors:SetPos (8, 44 + self.BackButton:GetTall () + self.HouseItem:GetTall ())
		self.Doors:SetSize (self:GetWide () - 16, self:GetTall () - 60 - self.BackButton:GetTall () - self.HouseItem:GetTall () - self.AddDoorButton:GetTall ())
		
		self.AddDoorButton:SetSize (80, 28)
		self.AddDoorButton:SetPos (8, self:GetTall () - 8 - self.AddDoorButton:GetTall ())
	end
end

function PANEL:Remove ()
	self:SetVisible (false)
	self.Houses:Remove ()
	self:SetSelectedHouse (nil)
	debug.getregistry ().Panel.Remove (self)
end

function PANEL:SetSelectedHouse (house)
	if self.SelectedHouse == house then return end

	if self.SelectedHouse then
		self.SelectedHouse:RemoveEventListener ("Removed", tostring (self))
	end

	self.SelectedHouse = house
	self.HouseItem:SetHouse (house)
	self.Doors:SetHouse (house)
	
	if self.SelectedHouse then
		self.SelectedHouse:AddEventListener ("Removed", tostring (self), function (house)
			self:SetSelectedHouse (nil)
		end)
		
		local trace = LocalPlayer ():GetEyeTrace ()
		self.Door = nil
		if trace.Entity and trace.Entity:IsValid () then
			self.Door = trace.Entity
		end
	end
	
	self:InvalidateLayout ()
end

function PANEL:SetVisible (visible)
	debug.getregistry ().Panel.SetVisible (self, visible)
	
	if visible then
		RunConsoleCommand ("houses_admin_ui_opened")
		local trace = LocalPlayer ():GetEyeTrace ()
		self.Door = nil
		if trace.Entity and trace.Entity:IsValid () then
			self.Door = trace.Entity
		end
	else
		RunConsoleCommand ("houses_admin_ui_closed")
	end
end

function PANEL:Think ()
	self.AddDoorButton:SetDisabled (true)

	local ent = self.Door
	if not ent or not ent:IsValid () then return end
	local class = ent:GetClass ()
	if class ~= "func_door" and
		class ~= "func_door_rotating" and
		class ~= "prop_door_rotating" and
		class ~= "prop_dynamic" then
		return
	end
	self.AddDoorButton:SetDisabled (false)
end

vgui.Register ("HouseAdminDialog", PANEL, "DFrame")