
points = newclass("points", interactive)

print("Welcome to Points 1.0")

function safe_include(filename)
	local t = includeastable(filename)

	if not t then
		printf("Error reading %s file\n", filename)
		error()
	end
	return t
end

function points:init(localdir)
	self.project = {}
	local dir = localdir.."/"
	local ttime = os.time()
	local Spec = safe_include(dir.."spec.pts")
	local cfgfile = dir..(Spec.files.config or "config.pts")

	Config = safe_include(cfgfile)

	for _, f in pairs(Spec.files.tasks) do
		-- putting all task in the same table (from now on task will be called bug)
		local t = safe_include(dir..f)

		allbugs = table.merge(t, allbugs)
	end

	for id, t in pairs(allbugs) do
		if t.template then
			if allbugs[t.template] then
				allbugs[id] = table.merge(allbugs[t.template], t)
			else
				printf("Template %s was not found for task %s\n", tostring(t.template), tostring(id))
			end
		end
	end
	for id, t in pairs(allbugs) do
		if t.attach then
			if allbugs[t.attach] then
				allbugs[t.attach].group = true
			end
		end
	end

	local projs = table.clone(Spec.projects)
	for pid, p in pairs(projs) do
		-- generating effort classes from files
		for vid, v in pairs(p.views) do 
			tl ('creating project '..tostring(pid)..' view '..tostring(vid))
			v.effort = {}
			for _, efforttype in pairs({"planned", "unplanned"}) do
				local filename = dir..(v[efforttype] and v[efforttype].file)
				if filename and io.open(filename) then
					v.effort[efforttype] = {tasks = safe_include(filename), onlyworth = v[efforttype].onlyworth}
				else
					v.effort[efforttype] = {tasks = {}, onlyworth = false}
					printf("Error trying to load %s file of project view %s/%s\n", efforttype, pid, vid)
					return
				end
			end
			-- getting the vacations for each one in the team
			for tid, t in pairs(v.team) do
				local member = {}
				local view_vacations = (Spec.vacations[tid] and table.clone(Spec.vacations[tid]))

				member.rate = (type(t) == "number" and t) or t[1]
				member.vacation = view_vacations or {}
				if type(t) == "table" and t.start then
					table.insert(member.vacation, {nil, t.start})
				end
				if type(t) == "table" and t.endd then
					table.insert(member.vacation, {t.endd, nil})
				end
				v.team[tid] = member
			end
		end
		self.project[pid] = project:new(pid, p, allbugs, p.views)
	end
	self.super:init(points.static.public_methods)
	printf("took %d s\n", os.time()-ttime)
end

points.select = function (self, ...)
	local name = arg[1]
	local obj = self.project[name]

	if not obj then
		if name then 
			printf("No project called %s\n", name)
		end
		return nil
	end

	table.remove(arg, 1)
	return obj:select(unpack(arg))
end

points.public_methods = {
	select = {
		"Select the project which you desire to work with",
		"More than once project can be created inside the points. You can use the function 'list' to see all of them. Afterwards, use 'select' function to select that one you want to work. 'select' function returns the project selected.",
	},
}

