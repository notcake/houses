local PANEL = {}

function PANEL:Init ()
	self.House = nil
	
	self.ItemClass = "HouseDoorItem"

	self.PanelList = vgui.Create ("DPanelList", self)
	self.PanelList:SetPos (0, 0)
	self.PanelList:EnableVerticalScrollbar (true)
	
	self.Doors = {}
end

function PANEL:AddDoor (door)
	local item = vgui.Create (self.ItemClass)
	item:SetHouse (self.House)
	item:SetDoor (door)
	
	self.PanelList:AddItem (item)
	
	self.Doors [#self.Doors + 1] = item
end

function PANEL:GetItemClass ()
	return self.ItemClass
end

function PANEL:PerformLayout ()
	self.PanelList:SetSize (self:GetWide (), self:GetTall ())
end

function PANEL:Populate ()
	for door in self.House:GetDoorIterator () do
		self:AddDoor (door)
	end
end

function PANEL:Remove ()
	self.PanelList:Clear (true)

	self:SetHouse (nil)

	debug.getregistry ().Panel.Remove (self)
end

function PANEL:SetHouse (house)
	if self.House == house then return end

	if self.House then
		self.House:RemoveEventListener ("DoorAdded", tostring (self))
		self.House:RemoveEventListener ("DoorRemoved", tostring (self))
	end
	
	self.PanelList:Clear (true)
	self.House = house
	self.Doors = {}
	
	if self.House then
		self.House:AddEventListener ("DoorAdded", self, function (house, door)
			self:AddDoor (door)
		end)
		self.House:AddEventListener ("DoorRemoved", self, function (house, door, doorID)
			local item = self.Doors [doorID]
			self.PanelList:RemoveItem (item)
			item:Remove ()
			table.remove (self.Doors, doorID)
		end)
		
		self:Populate ()
	end
end

function PANEL:SetItemClass (itemClass)
	self.ItemClass = itemClass
end

vgui.Register ("HouseDoorList", PANEL, "DPanel")