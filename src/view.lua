
view = newclass("view", interactive)

selectbugs = function(bugs, start, deadline)
	local buglist = { 
		all    = {bug = {}, group = {}},
		open   = {bug = {}, group = {}},
		closed = {bug = {}, group = {}},
	}

	for tid, b in pairs(bugs) do
		local bugtype = nil

		if b.closeddate then
			b.status = "CLOSED"
		else
			b.status = "OPEN"
		end

		if b.group then
			buglist.all.group[tid] = b
			buglist.open.group[tid] = b
			buglist.closed.group[tid] = b
		else
			if not b.opendate then
				-- task will be ignored when trying to create the taskunit object
				-- It's necessary to print the correct message to user
				buglist.all.bug[tid] = b

			elseif (date(b.opendate)-date(deadline)):spandays() <= 0 then
				if b.status == "OPEN" then
					buglist.open.bug[tid] = b
					buglist.all.bug[tid] = b

				elseif (date(b.closeddate)-date(start)):spandays() >= 0 then
					-- The task started before the end view date and it is still
					-- open or closed after the view starting.
					if (date(b.closeddate)-date(deadline)):spandays() < 0 then
						buglist.closed.bug[tid] = b
					else
						-- if task is closed after the end view date, for the
						-- period of the view, this task is still open
						buglist.open.bug[tid] = b
					end
					buglist.all.bug[tid] = b
				end
			end
		end
	end
	return buglist
end

buildtasks = function(buglist, effort, alarm)
	local t = {}

	t.bug = {}
	for id, b in pairs(buglist.bug) do
		local tu

		tu = taskunit:new(id, b, effort[id])
		if tu:check(alarm) then
			t.bug[id] = tu
		end
	end

	t.group = {}
	for id, b in pairs(buglist.group) do
		local tu

		tu = taskunit:new(id, b, {})
		if tu:check(alarm) then
			t.group[id] = tu
		end
	end

	return t
end

view.init = function(self, bugs, view_)
	local dup
	local today = date(view_.today or false)
	local start = date(view_.start)
	local deadline = date(view_.deadline)
	local unplanned_rate = (view_.unplanned and view_.unplanned.rate) or 0

	if date.diff(today, deadline):spandays() > 0 then
		printf("This view is finished\n")
		today = date(view_.deadline)
	end

	self.start = start
	self.deadline = deadline
	self.unplanned_rate = unplanned_rate
	self.today = today

	-- selecting bugs of this view
	buglist = selectbugs(bugs, start, deadline)

	-- looking for unused task in effort files
	for _, efforttype in pairs({"planned", "unplanned"}) do
		if not (view_.effort[efforttype].onlyworth == false) then
			for taskid, _ in pairs(view_.effort[efforttype].tasks) do
				if not buglist.all.bug[taskid] and not buglist.all.group[taskid] then
					printf("Task %s in %s file is worthless\n", taskid, efforttype)
				end
			end
		end
	end

	-- setting effort to use below
	local effort = {}
	effort.planned = view_.effort.planned.tasks
	effort.unplanned = view_.effort.unplanned.tasks
	effort.all, dup = table.tabconcat(effort.planned, effort.unplanned)
	
	if dup then
		for _, bid in pairs(dup) do
			printf("%s task is present in both planned and unplanned file\n", bid)
		end
	end

	-- team
	local pteam = team:new(view_.team, 1-unplanned_rate)
	local uteam = team:new(view_.team, unplanned_rate)
	local tteam = team:new(view_.team)

	--- tasklist
	local tasks = {
		all = {
			all    = buildtasks(buglist.all   , effort.all, {all = true}),
			closed = buildtasks(buglist.closed, effort.all),
			open   = buildtasks(buglist.open  , effort.all),
		},
		planned = {
			all    = buildtasks(buglist.all   , effort.planned),
			closed = buildtasks(buglist.closed, effort.planned),
			open   = buildtasks(buglist.open  , effort.planned),
		},
		unplanned = {
			all    = buildtasks(buglist.all   , effort.unplanned),
			closed = buildtasks(buglist.closed, effort.unplanned),
			open   = buildtasks(buglist.open  , effort.unplanned),
		},
	}

	-- looking for broken links to warn
	tasklist:new(tasks.all.all, {all = true})

	-- locking for tasks that were open before project starts
	-- and appears as unplanned tasks in the project
	for id, t in pairs(tasks.unplanned.all.bug) do
		if date.diff(t:get("opendate"), start):spandays() < 0 then
			printf("Task %s that is considered unplanned has an opendate before view starts.\n", tostring(id))
		end
	end

	-- calculating all points and unplanned points
	local ppoints = view_.planned.points or tasklist:new(tasks.planned.all):points()
	local upoints = ppoints/(1-unplanned_rate) - ppoints
	local tpoints = ppoints + upoints

	-- user functions
	local screen = {
		progress,
		todo,
		hc, -- history closed
		hb, -- history buffer
	}

	-- progress 
	screen.progress = {
		total     = scope:new(tpoints, tasks.all, tteam,
								today, start, deadline, "total", true),
		planned   = scope:new(ppoints, tasks.planned, pteam,
								today, start, deadline, "planned"),
		unplanned = scope:new(upoints, tasks.unplanned, uteam,
								today, start, deadline, "unplanned"),
	}

	-- todo
	screen.todo = {
		category = category:new(tasks.all.open, tteam),
	}

	-- history closed 
	screen.hc = {
		category = category:new(tasks.all.closed, tteam),
		history = history:new(tasks.all.closed, tteam, "closeddate", today,
		start, tpoints),
	}
	
	-- history buffer
	screen.hb = {
		category = category:new(tasks.unplanned.all, uteam),
		history = history:new(tasks.unplanned.all, uteam, "opendate", today, start, upoints),
	}

	-- Saving screens
	self.screen = screen

	self.super:init(view.static.public_methods)
end

view.select = function(self)
	self.lockedfunc = nil
	return self
end

view.summary = function(self)
	printf("                Today : %s\n", self.today:fmt("%y-%m-%d"))
	printf("                Start : %s\n", self.start:fmt("%y-%m-%d"))
	printf("                  End : %s\n", self.deadline:fmt("%y-%m-%d"))
	printf("     Unplanned Effort : %.2f\n", self.unplanned_rate)
end

view.progress = function(self)
	local f = self.screen.progress

	-- total
	f.total:summary(true, false)

	-- planned
	f.planned:summary(true, false)

	-- unplanned
	if (f.unplanned) then
		f.unplanned:summary(true, true)
	end
	self.lockedfunc = f
end

view.todo = function(self)
	-- d must be today if the project has already started otherwise d must be
	-- the project start date
	local d = ((self.start-self.today):spandays() > 0 and self.start) or self.today
	local f = self.screen.todo

	printf("SEVERITY\n")
	f.category:graph_severity(d)
	printf("\nPRIORITY\n")
	f.category:graph_priority(d)
	printf("\nMEMBER LOAD\n")
	f.category:graph_member_load(d)

	self.lockedfunc = f
end

view.hc = function(self)
	local f = self.screen.hc

	printf("SEVERITY\n")
	f.category:graph_severity(self.start)
	printf("\nMEMBER PERFORMANCE\n")
	f.category:graph_member_performance(self.start, self.today)
	printf("\nBURNUP\n")
	f.history:burnup(true)

	self.lockedfunc = f
end

view.hb = function(self)
	local f = self.screen.hb

	printf("SEVERITY\n")
	f.category:graph_severity(self.start)
	printf("BURNUP\n")
	f.history:burnup(true)

	self.lockedfunc = f
end

private = {}

private.print = function(l, arg, usecolor)
	local t, n

	-- get the tasks instance comming from classes
	t, n = l:show(unpack(arg))

	if t then
		return t:print(arg[n+1], usecolor)
	end
end

view.print = function(self, arg, usecolor)
	local f = self.lockedfunc
	local l

	if not f then
		printf("No screen locked\n")
		return
	end

	if f[arg[1]] then
		-- the class was specified
		l = f[arg[1]]
		table.remove(arg, 1)
		return private.print(l, arg, usecolor)
	else
		-- trying all classes of screen
		for _, l in pairs(f) do
			local str = private.print(l, arg, usecolor)
			if str then
				return str
			end
		end
	end
end

view.show = function(self, ...)
	local str = self:print(arg, true)

	if str then
		print(str)
	end
end

view.export = function(self, filename, ...)
	local str = self:print(arg, false)

	local fd = io.open(filename, "w")
	fd:write(str)
	fd:close()
end

view.public_methods = 
{
	progress = {
		short="Prints the scope summary of all, planned and unplanned tasks",
		long="This is the best way to folow the progess of project comparing all tasks that have done with the scope. This function will call the summary method of scope class that should present a graphical evolution for this view.",
		arguments="none",
	},

	todo = {
		short="Prints the summary of all known tasks",
		long="This method prints the effort of all categories using bar graphics.",
		arguments="none",
	},
	hc = {
		short="Prints the summary for all completed tasks",
		long="This method shows a effort bar graphics for severity and members and the effort distribution over time.",
		arguments="none",
	},
	hb = {
		short="Prints the summary for all completed tasks",
		long="This method shows a effort bar graphics for severity and members and the effort distribution over time.",
		arguments="none",
	},
	summary = {
		short="Prints the view information",
		long="Prints how this view see the project dates, unplanned rate and team rate.",
		arguments="none",
	},
	show = {
		short="Prints a list of tasks in a long form for any keyword.",
		long="All graphics have highlighted words (keywords) that have a set of tasks assigned. You can use the show function to list the tasks that associated with this words.",
		arguments="none"
	},
	list = {
		short="Prints a list of tasks in a short form for any keyword.",
		long="All graphics have highlighted words (keywords) that have a set of tasks assigned. You can use the show function to list the tasks that associated with this words.",
		arguments="none"
	},
}

