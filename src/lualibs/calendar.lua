-- all hollidays date
build_holliday_table = function()
	local h = Config.holidays
end

holliday = function(d)
	local h = Config.holidays

	if not h then
		return false
	end
	local year  = d:getyear()
	local month = d:getmonth()
	local day   = d:getday()

	for _, v in pairs(h) do
		local dc = date(v)
		local cyear  = dc:getyear()
		local cmonth = dc:getmonth()
		local cday   = dc:getday()
		if cday == day and cmonth == month and cyear == year then
			return true
		end
	end
	return false
end

-- check if "d" is a weekend day
is_weekend = function(d)
	if d:getisoweekday() == 6 or d:getisoweekday() == 7 or holliday(d) then
		return true
	end
	return false
end

-- check if we really need this function
bdays_in_period = function(startdate, enddate)
	local d = date(startdate)
	local effort = 0
	local i = 0

	while ((enddate-d):spandays() >= 0) do
		if not (d:getisoweekday() == 6 or d:getisoweekday() == 7 or holliday(d)) then
			effort = effort + 1
		end
		i = i + 1
		d = date(startdate):adddays(i)
	end

	return effort
end

