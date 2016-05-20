local PANEL = {}

function PANEL:Init ()
	self.ItemClass = "HouseItem"

	self.PanelList = vgui.Create ("DPanelList", self)
	self.PanelList:SetPos (0, 0)
	self.PanelList:EnableVerticalScrollbar (true)
	
	self.Houses = {}
	
	Houses.Houses:AddEventListener ("HouseAdded", tostring (self), function (houses, house)
		self:AddHouse (house)
	end)
	
	Houses.Houses:AddEventListener ("HouseRemoved", tostring (self), function (houses, house)
		self.PanelList:RemoveItem (self.Houses [house:GetID ()])
		self.Houses [house:GetID ()]:Remove ()
		self.Houses [house:GetID ()] = nil
	end)
end

function PANEL:AddHouse (house)
	local item = vgui.Create (self.ItemClass)
	item:SetHouse (house)
	
	self.Houses [house:GetID ()] = item
	
	self.PanelList:AddItem (item)
	
	self.PanelList:SortByMember ("SortKey")
end

function PANEL:GetItemClass ()
	return self.ItemClass
end

function PANEL:PerformLayout ()
	self.PanelList:SetSize (self:GetWide (), self:GetTall ())
end

function PANEL:Populate ()
	for _, house in Houses.Houses:GetHouseIterator () do
		self:AddHouse (house)
	end
	
	self.PanelList:SortByMember ("SortKey")
end

function PANEL:Remove ()
	self.PanelList:Clear (true)

	Houses.Houses:RemoveEventListener ("HouseAdded", tostring (self))
	Houses.Houses:RemoveEventListener ("HouseRemoved", tostring (self))

	debug.getregistry ().Panel.Remove (self)
end

function PANEL:SetItemClass (itemClass)
	self.ItemClass = itemClass
end

vgui.Register ("HouseList", PANEL, "DPanel")