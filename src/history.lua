
history = newclass("history")

-- The first week of a year (01) is the one which includes the first
-- Thursday, or equivalently the one which includes January 4. 
-- This works to prevent date like 31/12/2012 return as 
-- week 1 and year 2012 when actually it is week 1 and year 2013
getweek = function(d)
		return (date(d):setisoweekday(5)):getisoweeknumber()
end
getyear = function(d)
		return (date(d):setisoweekday(5)):getyear()
end

history.init = function(self, list, team, datetype, today, start, totalpoints)
	self.team = team
	self.today = today
	self.start = start
	self.nweeks = date.diff(today, start):spandays() / 7
	self.totalpoints = totalpoints

	local h = {}

	for tid, t in pairs(list.bug) do
		local d = date(t:get(datetype))
		local year = getyear(d)
		local week = getweek(d)

		if not h[year] then
			h[year] = {}
		end

		if not h[year][week] then
			h[year][week] = {}
		end

		h[year][week][tid] = t
	end
	for yid, y in pairs(h) do
		for wid, w in pairs(y) do
			if not self[yid] then
				self[yid] = {}
			end
			self[yid][wid] = tasklist:new({bug = w, group = list.group}, list.group)
		end
	end
end

history.show = function(self, year, week)

	if year and type(year) == "number" and year < 2000 then
		year = year + 2000
	end

	return (self[year] and self[year][week]), 2
end

history.burnup = function(self, memberinfo)
	-- self.start                today
	-- |------------------------------|

	local nweeks = self.nweeks

	---------------------------------------------------------------------
	-- calculating historys that fit in the space (maxx-minx)/(sbweeks)
	---------------------------------------------------------------------
	local r = {}
	local sbweeks  = 3 -- space between weeks
	local maxy = 15    -- max point of y dimension
	local minx = 8     -- origin x of graph
	local miny = 5     -- gap between the command line and the top of the graph in dimension x

	local maxval = self.totalpoints
	local baseline = 0
	local accum_points = 0 
	local d = date(self.start)
	for i = 1, math.ceil(nweeks) do -- 'math.ceil' to get uncompleted week
		local ndays = date.diff(self.today, d):spandays()
		local weekdays

		if ndays < 7 then
			weekdays = math.mod(ndays, 7)
		else
			weekdays = 7
		end

		local year = getyear(d)
		local week = getweek(d)

		baseline = baseline + self.team:points(d, weekdays).points
		local t = self[year] and self[year][week]
		if t then
			accum_points = accum_points + t:points()
		end
		table.insert(r, {
			y = year, 
			w = week, 
			baseline = baseline,
			points = accum_points,
		})
		d = date(d):adddays(7)
		if baseline > accum_points then
			if baseline > maxval then
				maxval = baseline
			end
		else
			if accum_points > maxval then
				maxval = accum_points
			end
		end
	end

	---------------------------------------------------------------------
	-- drawning the graph
	---------------------------------------------------------------------
	screen.linev(minx, miny-1, maxy+miny, "|"); 
	screen.str(minx, maxy+miny, string.rep("-", sbweeks))

	local xpos = minx + sbweeks
	local base_ypos
	local last_baseline
	for i, t in pairs(r) do
		local ypos = maxy - maxy * (t.points/maxval) + miny

		if t.points > 0 then
			if math.mod(i, 2) == 1 then
				screen.str(xpos, miny-1, string.format("%2.2f", t.points/t.baseline), "center"); 
			else
				screen.str(xpos, miny-2, string.format("%2.2f", t.points/t.baseline), "center"); 
			end
			screen.linev(xpos, ypos+1, maxy+miny-1, "|"); 
			screen.str(xpos, ypos, "T"); 
		end
		base_ypos = maxy - maxy * (t.baseline/maxval) + miny
		if t.baseline > 1 then
			screen.str(xpos, base_ypos, "."); 
		end
		screen.str(xpos, maxy+miny, string.rep("-", sbweeks))
		screen.str(xpos, maxy+miny+1, color.bold..tostring(t.w)..color.reset)
		screen.str(xpos, maxy+miny+2, color.bold..string.sub(tostring(t.y), 3, 4)..color.reset)
		xpos = xpos + sbweeks
		last_baseline = t.baseline
	end
	screen.str(xpos, base_ypos, string.format("%.2f", last_baseline), "left")

	-- the reference to expect maximum points
	local ypos = maxy - maxy * (accum_points/maxval) + miny

	screen.str(minx-2, ypos, string.format("%.2f", accum_points), "right")
	screen.str(minx-1, ypos, "-", "left")

	screen.print()
end


