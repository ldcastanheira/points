
project = newclass("project", interactive)

project_rule = function(rules, task, tid)
	local ok, val

	if not rules then
		printf("No project rule\n")
	end

	if type(rules) ~= "function" then
		printf("Wrong project rule format.\n")
	end

	ok, val = pcall(rules, task, tid)

	if not ok then
		printf("Error running project rule for task %s\n", tostring(tid))
		table.print(task)
		printf("   error: %s\n", val)
		return false
	end

	if val then
		return task
	else
		return nil
	end
end

project.init = function(self, projid, proj, tasks, views)
	local tasklist = {}

	self.name = proj.name or "no name"
	printf("Loading project %s - %s\n", color.bold..projid..color.reset, self.name)

	for tid, t in pairs(tasks) do
		local t = project_rule(proj.rule, t, tid)

		if t == false then
			printf("Ignoring project\n")
			return
		end
		tasklist[tid] = t
	end

	self.view = {}
	for vid, v in pairs(views) do
		printf("   Creating view %s\n", color.bold..tostring(vid)..color.reset)
		self.view[vid] = view:new(tasklist, v)
	end

	self.super:init(project.static.public_methods)
end

project.select = function(self, ...)
	local name = arg[1]
	local obj = self.view[name]

	if not obj then
		if name then 
			printf("No view called %s\n", name)
		end
		return nil
	end

	table.remove(arg, 1)
	return obj:select(unpack(arg)) or obj
end

project.public_methods = {
	select = {
		"Select the view inside the project",
		"More than once view can be created inside the project. You can use the function 'list' to see all of them. Afterwards, use 'select' function to select that one you want work with. 'select' function returns the view selected.",
	},
}

