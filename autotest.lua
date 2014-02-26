-- 
--
-- How to use:
-- autotest.lua database

print_team = function(v, team)
	for i in pairs(team) do
		printf("\show - member %s\n", i)
		v:show(i)
	end
end

print_severity = function(v)
	for i in pairs({"bug", "feature", "verification", "enhancement"}) do
		printf("\nshow - severity %s\n", i)
		v:show(i)
	end
end

getlastweek = function(year)
	for i=0, 30 do
		wi = date(year, 12, 31-i):getisoweeknumber()
		if wi > 1 then
			return wi
		end
	end
	error("Last week not found\n")
end

print_nweeks = function(v, today, nweeks)
	local today = (today and date(today)) or date()
	local year = today:getyear()
	local week = today:getisoweeknumber()
	local w = {}

	for i=0, nweeks do 
		wi = week - i
		if wi > 0 then
			table.insert(w, {year = year, week = wi})
		else
			year = year - 1
			wi = getlastweek(year)
			table.insert(w, {year = year, week = wi})
			week = wi + i
		end
	end

	for _, i in pairs(w) do 
		printf("\nshow - week %d year %d\n", i.week, i.year)
		v:show(i.year, i.week)
	end
end

print_priority = function(v)
	for i=0, 10 do 
		printf("\nshow - priority %s\n", i)
		v:show(i)
	end
end

dofile("src/loader.lua")

local Spec = includeastable(arg[1].."/spec.pts")
local projs = table.clone(Spec.projects)

local ex = points:new(arg[1])
for pid, p in pairs(projs) do
	for vid, vv in pairs(p.views) do 
		printf("\n\nTesting project %s view %s\n\n", pid, vid)
		v = ex:select(pid, vid)
		
		-- view class
		v:summary()

		-- progress and its show function
		v:progress()
		for i in pairs({"total", "planned", "unplanned"}) do
			v:show(i, "all")
			v:show(i, "closed")
			v:show(i, "open")
		end

		-- todo and its show function
		v:todo()
		print_severity(v)		
		print_priority(v)		
		print_team(v, vv.team)		

		-- hc and its show function
		v:hc()
		print_severity(v)		
		print_team(v, vv.team)		
		print_nweeks(v, vv.today, 6)

		-- hb and its show function
		v:hb()
		print_severity(v)		
		print_team(v, vv.team)		
		print_nweeks(v, vv.today, 6)
	end
end

