local PANEL = {}
local Gradient = Material ("gui/gradient_down")

function PANEL:Init ()
	self:SetTall (64)
	
	self.House = nil
	self.Door = nil
	
	self.PositionLabel = vgui.Create ("DLabel", self)
	self.PositionLabel:SetFont ("TargetID")
	self.PositionLabel:SetTextColor (Color (255, 255, 255, 255))
	
	self.ModelLabel = vgui.Create ("DLabel", self)
	self.ModelLabel:SetTextColor (Color (255, 255, 255, 255))
	
	self.RemoveButton = vgui.Create ("DButton", self)
	self.RemoveButton:SetText ("Remove")
	self.RemoveButton:SetSize (80, 28)
	
	self.RemoveButton.DoClick = function (button)
		RunConsoleCommand ("houses_remove_door", self.House:GetID (), self.House:GetDoorID (self.Door))
	end
end

function PANEL:GetDoor ()
	return self.Door
end

function PANEL:IsHovered ()
	local x, y = self:CursorPos ()
	if x < 0 then return false end
	if y < 0 then return false end
	if x > self:GetWide () then return false end
	if y > self:GetWide () then return false end
	return true
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
	if self:IsHovered () then
		surface.SetDrawColor (255, 255, 255, 32)
		surface.SetMaterial (Gradient)
		surface.DrawTexturedRect (0, 0, self:GetWide (), self:GetTall ())
	end
	
	if not self.Door then return end
	
	local trace = LocalPlayer ():GetEyeTrace ()
	local ent = trace.Entity
	if not ent:IsValid () then return end
	if ent:GetPos () == self.Door:GetPosition () and ent:GetModel () == self.Door:GetModel () then
		surface.SetDrawColor (0, 255, 0, 128)
		surface.SetMaterial (Gradient)
		surface.DrawTexturedRect (0, 0, self:GetWide (), self:GetTall ())
	end
end

function PANEL:PerformLayout ()	
	self.PositionLabel:SetPos (8, 8)
	self.PositionLabel:SetWide (self:GetWide () - 16)
	
	self.ModelLabel:SetPos (8, 32)
	self.ModelLabel:SetWide (self:GetWide () - 16)
	
	self.RemoveButton:SetPos (self:GetWide () - 8 - self.RemoveButton:GetWide (), self:GetTall () - 8 - self.RemoveButton:GetTall ())
end

function PANEL:Remove ()
	self:SetDoor (nil)
	
	debug.getregistry ().Panel.Remove (self)
end

function PANEL:SetDoor (door)
	if self.Door == door then return end
	
	self.Door = door
	if self.Door then
		self.PositionLabel:SetText (tostring (self.Door:GetPosition ()))
		self.ModelLabel:SetText (self.Door:GetModel ())
	end
end

function PANEL:SetHouse (house)
	if self.House == house then return end
	
	self.House = house
end

function PANEL:Think ()
	self.RemoveButton:SetVisible (self:IsHovered ())
end

vgui.Register ("HouseDoorItem", PANEL, "DPanel")