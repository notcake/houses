local Door = {}
Houses.Door = Houses.MakeConstructor (Door)

function Door:ctor ()
	Houses.EventProvider (self)

	self.House = nil

	self.Position = Vector (0, 0, 0)
	self.Model = ""
	
	self.Entity = nil
end

function Door:GetEntity ()
	return self.Entity
end

function Door:GetHouse ()
	return self.House
end

function Door:GetModel ()
	return self.Model or ""
end

function Door:GetPosition ()
	return self.Position
end

function Door:Link ()
	if self.Entity and self.Entity:IsValid () then return end

	local props = ents.FindInSphere (self:GetPosition (), 32)
	for _, prop in ipairs (props) do
		if (prop:GetModel () or ""):lower () == self:GetModel ():lower () then
			self.Entity = prop
			break
		end
	end

	if self.Entity and not self.Entity:IsValid () then
		self.Entity = nil
	end
	
	if self.Entity then
		self.Entity.HouseDoor = self
		self:UpdateDoorData ()
		
		if self.House and self.House:GetOwnerID () then
			local client = Houses.Clients:GetClientBySteamID (self.House:GetOwnerID ())
			if client and client:GetPlayer () then
				self:SetOwner (client:GetPlayer ())
			end
		end
	end
	return self.Entity ~= nil
end

function Door:RemoveOwner (ply)
	self:ValidateEntity ()
	if not self.Entity then return end
	
	self.Entity:UnOwn (ply)
	ply.Ownedz [self.Entity:EntIndex ()] = nil
	ply.OwnedNumz = ply.OwnedNumz - 1
end

function Door:SetEntity (entity)
	self.Entity = entity
end

function Door:SetHouse (house)
	self.House = house
	self:UpdateDoorData ()
end

function Door:SetOwner (ply)
	self:ValidateEntity ()
	if not self.Entity then return end
	
	self.Entity:Own (ply)
	ply.OwnedNumz = (ply.OwnedNumz or 0) + 1
	ply.Ownedz = ply.Ownedz or {}
	ply.Ownedz [self.Entity:EntIndex ()] = self.Entity
end

function Door:SetModel (model)
	self.Model = model
end

function Door:SetPosition (position)
	self.Position = position
end

function Door:UpdateDoorData ()
	if not self.Entity or not self.Entity:IsValid () then return end
	
	self.Entity.DoorData = self.Entity.DoorData or {}
	self.Entity.DoorData.IsHouseDoor = true
	self.Entity.DoorData.HouseName = self:GetHouse () and self:GetHouse ():GetName () or nil
end

function Door:ValidateEntity ()
	if not self.Entity then return end
	
	if self.Entity and not self.Entity:IsValid () then
		self.Entity = nil
	end
end