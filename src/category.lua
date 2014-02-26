
category = newclass("category")

local fields = {"priority", "severity", "assigned"}

category.init = function(self, list, team)
	self.all = tl
	self.team = team

	for _, f in pairs(fields) do
		self[f] = {}
	end
	for _, f in pairs(fields) do
		local buglist = {}

		for id, t in pairs(list.bug) do
			local val = t:get(f)

			if val then
				if not buglist[val] then
					buglist[val] = {}
				end
				buglist[val][id] = t
			end
		end
		for val, bl in pairs(buglist) do
			self[f][val] = tasklist:new({bug = bl, group = list.group})
		end
	end
	self.all = tasklist:new(list)
	self.priorities  = Config.priorities
end

category.get = function(self, name, val)
	local n = name or "all"
	local c = self[n]

	if n == "all" then
		return (not val and c)
	elseif not val then
		return c
	else
		return c[val]
	end
end

category.points = function(self, name, val)
	local tl = self:get(name, val)

	return tl:points()
end

category.show = function(self, val)
	local n = 0
	local tl 

	if val then
		for _, n in pairs(fields) do
			tl = self[n][val]

			if tl then
				break
			end
		end
	end
	return tl, 1	
end

local private = {}

private.effortstatus = function(totaldays, days)
	local status = "normal"
	local percent = days / totaldays

	if percent > 1 then
		return "critical"
	elseif percent > 0.8 then
		return "attention"
	else
		return "normal"
	end
end

private.bars = function(self, totaldays, days)
	local max_length_bar = 40
	local cor = Config.colors

	for i=1, (days/totaldays * max_length_bar) do
		local idays = i * totaldays / max_length_bar
		local status = private.effortstatus(totaldays, idays+private.barsdays)

		printf(color[cor[status]].."+"..color.reset)
		if (i > max_length_bar) then
			printf(color[cor[status]].." ->"..color.reset)
			break
		end
	end
	private.barsdays = private.barsdays + days
end

--  1 [       Bug urgent] : [29-05-12] +++++++ 7.32 days (19.94%) [11-06-12]
private.bars1 = function(self, name, coname, startdate, totaleffort, effort)
	
	printf("    %4s [%17s] : [%s] ", color.bold..name..color.reset, coname, startdate:fmt("%y-%m-%d"))
	private.bars(self, totaleffort.teamdays, effort.teamdays)

	local effortpercent = effort.teamdays/totaleffort.teamdays * 100
	printf(" %.2f days (%.2f%%) [%s]\n", effort.teamdays, effortpercent, effort.date:fmt("%y-%m-%d"));
end

-- erico     : ++++++++++ 19.95 days [28-06-12]
private.bars2 = function(self, name, totaleffort, effort)
	
	printf("   %25s     : ", color.bold..name..color.reset)
	private.bars(self, totaleffort.teamdays, effort.teamdays)
	printf(" %.2f days [%s]\n", effort.teamdays, effort.date:fmt("%y-%m-%d"));
end

-- feature     : ++++++++ (21.56%)
private.bars3 = function(self, name, totalpoints, points)
	
	printf("   %25s     : ", color.bold..name..color.reset)
	private.bars(self, totalpoints, points)

	local percent = points/totalpoints * 100
	printf(" (%.2f%%)\n", percent);
end

category.graph_severity = function(self, start)
	local totalpoints = self:points()

	local sorted = table.sortbyidx(self["severity"])
	for _, p in pairs(sorted) do
		local name = p[1]
		local points = p[2]:points()

		private.barsdays = 0
		private.bars3(self, name, totalpoints, points)
	end
end

category.graph_priority = function(self, start)
	local totalpoints = self:points()
	local totaleffort = self.team:effort(start, totalpoints)

	private.barsdays = 0
	local sorted = table.sortbyidx(self["priority"])
	for _, p in pairs(sorted) do
		local name = p[1]
		local coname = self.priorities[name] or "Unknown"
		local effort = self.team:effort(start, p[2]:points())

		private.bars1(self, name, coname, start, totaleffort, effort)
		effort = self.team:effort(date(effort.date):adddays(1), 1) -- go to the next workday
		start = effort.date
	end
end

category.graph_member_load = function(self, start)
	local totalpoints = self:points()
	local totaleffort = self.team:effort(start, totalpoints)

	local sorted = table.sortbyidx(self["assigned"])
	for _, p in pairs(sorted) do
		local name = p[1]
		local tl = p[2]
		local effort = self.team:member_effort(name, start, tl:points(), name)

		private.barsdays = 0
		private.bars2(self, name, totaleffort, effort)
	end
end

category.graph_member_performance = function(self, start, today)
	local bdays = date.diff(today, start):spandays()

	local sorted = table.sortbyidx(self["assigned"])
	for _, p in pairs(sorted) do
		local name = p[1]
		local donepoints = p[2]:points()
		local member = self.team:member_points(name, start, bdays)

		private.barsdays = 0
		printf("   %25s     : ", color.bold..name..color.reset)
		private.bars(self, member.points, donepoints)
		printf(" (%.2f%%) %.2f pts a day\n", donepoints/member.points * 100, donepoints/member.days);
	end
end

