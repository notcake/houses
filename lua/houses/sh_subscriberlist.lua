local SubscriberList = {}
Houses.SubscriberList = Houses.MakeConstructor (SubscriberList)

function SubscriberList:ctor ()
	self.RefCounts = {}
	self.Players = {}
end

function SubscriberList:AddPlayer (ply)
	if not ply or not ply:IsValid () then
		return
	end
	if self.RefCounts [ply] then
		self.RefCounts [ply] = self.RefCounts [ply] + 1
	else
		self.RefCounts [ply] = 1
		self.Players [#self.Players + 1] = ply
	end
end

function SubscriberList:CleanUp ()
	local invalid = {}
	for k, v in ipairs (self.Players) do
		if not v:IsValid () then
			invalid [#invalid + 1] = k
		end
	end
	for i = #invalid, 1, -1 do
		table.remove (self.Players, invalid [i])
	end
end

function SubscriberList:GetPlayerIterator ()
	self:CleanUp ()
	local next, tbl, key = pairs (self.Players)
	return function ()
		key = next (tbl, key)
		return tbl [key]
	end
end

function SubscriberList:GetRecipientFilter ()
	self:CleanUp ()
	return self.Players
end

function SubscriberList:RemovePlayer (ply)
	if not self.RefCounts [ply] then
		return
	end
	
	if self.RefCounts [ply] > 1 then
		self.RefCounts [ply] = self.RefCounts [ply] - 1
		return
	end
	self.RefCounts [ply] = nil
	
	for k, v in ipairs (self.Players) do
		if v == ply then
			table.remove (self.Players, k)
			break
		end
	end
end