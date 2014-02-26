
scope = newclass("scope")

scope.init = function(self, totalpoints, tl, team, today, start, deadline, name, warn)
	self.task        = {}
	self.task.open   = tasklist:new(tl.open)
	self.task.closed = tasklist:new(tl.closed)
	self.task.all    = tasklist:new(tl.all)
	self.today       = today
	self.start       = start
	self.name        = name or "No name"
	self.team        = team

	self.totalpoints = totalpoints
	self.totaleffort = self.team:effort(start, self.totalpoints)

	self.allpoints = self.task.all:points()

	self.closedpoints = self.task.closed:points()	
	
	self.openpoints = self.task.open:points()	

	dat = self.totaleffort.date
	if warn and date.diff(dat, deadline):spandays() > 0 then
		printf("Scope end date is later than view deadline\n")
	end
end

scope.summary = function(self, cpi, api)
	local lenght = 60
	local min = 20
	local today = self.today
	local ndays = date.diff(today, self.start):spandays()

	-- treating the case when the project hasn't started yet.
	if ndays < 0 then
		ndays = 0
	end
	local todaypoints = self.team:points(self.start, ndays)

	if self.totaleffort.teamdays == 0 then
		printf("You don't have total effort for %s tasks\n", self.name)
		return
	end
	max = min + lenght

	local formatpointer = function(pointer, pointerpoints, totalpoints)
		if pointerpoints > totalpoints then
			str = string.format("%s [%0.2f%%] %d -->", pointer, pointerpoints/totalpoints * 100, pointerpoints)
			return max, str
		else
			str = string.format("%s [%0.2f%%] %d ", pointer, pointerpoints/totalpoints * 100, pointerpoints)
			return min + pointerpoints/totalpoints * lenght, str
		end
	end

	--screen.ruler() -- only for debug
	-- graph
	pos = min
	str = string.format("%s |", self.name)
	screen.str(pos, 3, str, "right", "bold")
	screen.lineh(pos, 3, max, "-"); 
	screen.str(pos-2, 4, self.start:fmt("%y-%m-%d"), "right")
	dat = self.totaleffort.date
	str = string.format("| [%0.2f points]", self.totalpoints)
	screen.str(max, 3, str, "left")
	screen.str(max+2, 4, dat:fmt("%y-%m-%d"), "left")

	local pos, str = formatpointer("today", todaypoints.points, self.totalpoints)
	screen.str(pos, 1, str, "center", "bold"); 
	screen.linev(pos, 2, 2, "|")

	local allpos, str = formatpointer("all", self.allpoints, self.totalpoints) 
	screen.linev(allpos, 4, 5, "|")
	screen.str(allpos, 6, str, "center", "bold"); 

	local closedpos, str = formatpointer("closed", self.closedpoints, self.totalpoints) 
	screen.linev(closedpos, 4, 4, "|")
	screen.str(closedpos, 5, str, "center", "bold"); 

	local openpos, str = formatpointer("open", self.openpoints, self.allpoints) 
	screen.linev(allpos, 7, 7, "|")
	screen.linev(closedpos, 7, 7, "|")
	screen.lineh(closedpos+1, 7, allpos-1, "-")
	screen.str(closedpos, 7, str, "right", "bold"); 

	-- speeds a week
	local closed_index = self.closedpoints / todaypoints.points
	local all_index = self.allpoints / todaypoints.points

	if ndays > 0 then
		str = "  "
		if cpi then
			str = str..string.format("Closed Perf. Index (CPI) %0.2f", closed_index)
		end
		if api then
			str = str.."  "..string.format("All Perf. Index (API) %0.2f", all_index)
		end
		str = str.."\n"
	else
		str = string.format("Not in progress.. Expecting to start %s\n", self.start:fmt("%y-%m-%d"))
	end
	screen.str(min+lenght/2, 8, str, "center"); 

	screen.print()
	
end

scope.show = function(self, val)
	local t = self.task[val]

	return t, 1
end

