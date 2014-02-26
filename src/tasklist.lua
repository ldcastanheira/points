
tasklist = newclass("tasklist")

group = function(id, t, gid, grouplist, allocatedgroup, alarm)
	local gtu
	local brokenlink = alarm and (alarm.brokenlink or alarm.all) and printf or function() end

	if not grouplist[gid] then
		brokenlink("Could not link %s task to %s task\n", id, gid)
		return
	end

	if allocatedgroup[gid] then
		gtu = allocatedgroup[gid]
	else
		gtu = taskunit:new(gid, grouplist[gid]:get(), {})
		allocatedgroup[gid] = gtu
	end

	gtu:add(t)

	if grouplist[gid].attach then
		return group(gid, gtu, grouplist[gid].attach, allocatedgroup, alarm)
	else
		return gtu, gid
	end
end

tasklist.init = function(self, list, alarm)
	local allocatedgroup = {}
	self.data = {}
	self.group = {}

	for id, tu in pairs(list.bug) do
		local t = tu:get()

		if not t.attach and not t.group then
			self.data[id] = tu

		elseif t.attach and not t.group then
			local gtu, gid = group(id, tu, t.attach, list.group, allocatedgroup, alarm)

			if gtu then
				self.data[gid] = gtu
			end
		end
	end
end

tasklist.points = function(self)
	local points = 0

	for i, task in pairs(self.data) do
		points = points + task:points()
	end

	return points
end

tasklist.get = function(self, id)
	if id then
		return self.data[id]
	else
		return self.data
	end
end

tasklist.printable = function(self)
	local t = {}
	local n = 0

	for _, task in pairs(self.data) do
		local list = task:printable()

		for _, ta in pairs(list) do
			table.insertsortedbyfields(t, ta, "priority", "id", "name")
		end
		n = n + 1
	end
	return t, n
end

tasklist.print = function(self, format, usecolor)
	local t, n = self:printable()
	local str = taskunit.static.print(t, format, usecolor)

	if str then
		local footnote = string.format("\n%s tasks [%.2f pts]\n", n, self:points())

		return str..footnote
	end
end

