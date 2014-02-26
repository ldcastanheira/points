team = newclass("team")

team.init = function(self, projteam, factor)
	factor = factor or 1
	
	self.member = {}
	
	for i, t in pairs(projteam) do
		self.member[i] = t
		self.dedication = factor
	end
end

team.show = function(self)
	local total = 0

	for i, v in pairs(self.member) do
		local totalsprints = 0
		local nsprints = 0

		printf("%s\n", i)
		printf("             rate : %.2f\n", v.rate)
		total = total + v.rate * self.dedication
	end
	printf("Dedication %.2f\n", self.dedication)
	printf("Total %.2f\n", total)
end

team.check = function(self, member)
	if self.member[member] == nil then
		return false
	else
		return true
	end
end

team.is_in_vacation = function(self, member, d)
	local t = self.member[member]

	if t.vacation then
		for _, v in pairs(t.vacation) do
			local ini = v[1] and date(v[1])
			local fin = v[2] and date(v[2])

			if not ini and not fin then
				return nil
			elseif not ini then
				if date.diff(d, fin):spandays()-1 <= 0 then
					return true
				end
			elseif not fin then
				if date.diff(d, ini):spandays() >=0 then
					return nil
				end
			elseif date.diff(d, ini):spandays() >=0 and date.diff(d, fin):spandays()-1 <= 0 then
				return true
			end
		end
	end
	return false
end

team.rate_on_date = function(self, date)
	local rate = 0

	for i, t in pairs(self.member) do
		local vacation = self:is_in_vacation(i, date)

		if vacation == false and not is_weekend(date) then
			rate = rate + t.rate * self.dedication
		end
	end
	return rate, true
end

team.member_rate_on_date = function(self, member, date)
	local t = self.member[member]

	if not t then
		return 1
	end

	local vacation = self:is_in_vacation(member, date)

	if vacation == nil then
		return rate, false
	elseif vacation == false and not is_weekend(date) then
		return t.rate * self.dedication, true
	else
		return 0, true
	end
end

team.points = function(self, startdate, ndays)
	local rate = 0
	local days = 0

	for i=0, ndays-1 do
		local d = date(startdate):adddays(i)
		local rate_on_date = self:rate_on_date(d)
		if rate_on_date > 0 then
			days = days + 1
		end
		rate = rate + rate_on_date
	end
	return { points = rate, days = days}
end

team.member_points = function(self, member, startdate, ndays)
	local rate = 0
	local days = 0

	for i=0, ndays-1 do
		local d = date(startdate):adddays(i)
		local rate_on_date = self:member_rate_on_date(member, d)
		if rate_on_date > 0 then
			days = days + 1
		end
		rate = rate + rate_on_date
	end
	return { points = rate, days = days}
end

team.effort = function(self, startdate, points)
	local days = 0
	local effort = 0
	local d = date()

	while (points > 0) do
		d = date(startdate):adddays(days)
		rate, avail = self:rate_on_date(d)

		if avail == false then
			return {teamdays = effort, days = days, date = d}, false
		end
		if (points < rate) then
			-- don't take the entire day
			effort = effort + points / rate
			days = days + points / rate
			break
		end
		if rate > 0 then
			points = points - rate
			effort = effort + 1
		end
		days = days + 1
	end

	return {teamdays = effort, days = days, date = d}, true
end

team.member_effort = function(self, member, startdate, points)
	local days = 0
	local effort = 0
	local d = date()

	while (points > 0) do
		d = date(startdate):adddays(days)
		rate, avail = self:member_rate_on_date(member, d)

		if avail == false then
			return {teamdays = effort, days = days, date = d}, false
		end
		if (points < rate) then
			-- don't take the entire day
			effort = effort + points / rate
			days = days + points / rate
			break
		end
		if rate > 0 then
			points = points - rate
			effort = effort + 1
		end
		days = days + 1
	end

	return {teamdays = effort, days = days, date = d}, true
end

