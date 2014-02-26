-- todo: change 'bug' for 'data'
--
taskunit = newclass("taskunit")

taskunit.check = function(self, alarm)
	local id = self.id
	local bug = self.bug

	local noprint = function() end
	local alarmprint = {
		noinfo       = alarm and (alarm.noinfo or alarm.all) and printf or noprint,
		noassigned   = alarm and (alarm.noassigned or alarm.all)          and printf or noprint,
		noeffort     = alarm and (alarm.noeffort or alarm.all) and printf or noprint,
		ignore       = alarm and (alarm.ignore or alarm.all) and printf or noprint,
		invalidfield = alarm and (alarm.invalidfield or alarm.all) and printf or noprint,
	}
	--
	-- basic check before continue verifying 
	-- the integrity of task data
	--
	if not bug then
		alarmprint.noinfo("Task %s not found in either planned or unplanned files.\n", tostring(id))
		return nil
	end
	if bug.ignore then
		if bug.reason then
			alarmprint.ignore("Ignored task %s because %s\n", tostring(id), bug.reason)
		end
		return nil
	end

	local fieldtype

	if bug.group then
		fieldtype = {
			["desc"]        = {type="string", required = true},
			["status"]      = {type="string", required = true},
			["priority"]    = {type="number", required = true},
		}
	else
		fieldtype = {
			["assigned"]    = {type="string", required = true},
			["severity"]    = {type="string", required = true},
			["desc"]        = {type="string", required = true},
			["status"]      = {type="string", required = true},
			["priority"]    = {type="number", required = true},
			["effort"]      = {type="number", required = true},
			["opendate"]    = {type="date",   required = true},
			["closeddate"] = {type="date",   required = false},
		}
	end

	--
	-- check the types
	--
	for fid, f in pairs(fieldtype) do
		if f.required or bug[fid] then
			if not bug[fid] then
				alarmprint.invalidfield("Task %s has no %s\n", tostring(id), fid)
				return nil
			elseif f.type == "date" then
				if date(bug[fid]) == nil then
					alarmprintf.invalidfield("Task %s with invalid date in %s field\n", tostring(id), fid)
					return nil
				end
			elseif type(bug[fid]) ~= f.type then
				alarmprint.invalidfield("Task %s with invalid type in %s field\n", tostring(id), fid)
				return nil
			end
		end
	end

	--
	-- check all fields and its value to provide a 
	-- understandable error for user
	--
	check = {
		status = {
			"OPEN",
			"CLOSED",
		},
	}
	for field, val in pairs(bug) do
		local checktable = check[field]
		if checktable then
			if not table.find(checktable, val) then
				alarmprint.invalidfield("Task %s: %s field must be one of them (%s)\n", id, field, tostring(val))
				for _, val in pairs(checktable) do
					alarmprint.invalidfield("-> %s\n", val)
				end
				return nil
			end
		end
	end
	
	--
	-- check the coherence between two fields or more
	-- do not stop points
	--
	if bug.status == "CLOSED" and bug.confirm then
		alarmprint.noassigned("Task %s is closed with unconfirmed assigned\n", tostring(id))
	end

	return self
end

taskunit.init = function(self, id, bug, info)
	self.id = id
	self.bug = nil

	if not bug or not info then
		return
	end

	self.bug = table.merge(bug, info)
end

taskunit.add = function(self, t)
	self.links = self.links or {}
	self.links[t.id] = t
end

taskunit.points = function(self)
	local points = 0

	if self.links then
		for id, tu in pairs(self.links) do
			points = points + tu:points()
		end
	else
		points = self.bug.effort
	end
	return points
end

taskunit.printable = function(self)
	local t = {}
	local bug = self.bug
	local id = self.id
	local links = {}

	local eff, severity

	if self.links then
		-- with links, the effort is sum of linked tasks
		eff = 0
		for _, tu in pairs(self.links) do
			eff = eff + tu:points()
			table.insert(links, tu:printable())
		end
		severity = "link"
	else
		-- assume my own effort
		eff = bug.effort
		severity = bug.severity
	end

	local val = table.clone(bug)

	val.id = id
	val.effort = eff
	val.links = links

	table.insert(t, val)

	return t
end

taskunit.get = function(self, val)
	if val then
		return self.bug[val]
	else
		return self.bug
	end
end

taskunit.print = function(t, format, usecolor, level)
	local level = level or 0
	local str = ""
	local export
	local cor = {
		feature     = color.green,
		bug         = color.white,
		enhancement = color.yellow,
		verification= color.blue,
		link        = color.cyan,
	}

	-- get the format in Config file or use the default
	if format and (not Config.export or not Config.export[format]) then
		printf("Format %s is not in config file\n", format)
		return
	end

	if format then
		export = Config.export[format]
	else
		export = {
			format = "[%s]\n%-80s - %.1f pts (%s)", 
			args = {"id", "desc", "effort", "severity"}
		}
	end

	-- set the header
	if export.header then
		str = str..export.header.."\n"
	end

	-- compose the string according format and arguments given for the user
	for i, v in pairs(t) do
		local fields = {}
		for _, a in pairs(export.args) do
			local val = v[tostring(a)]
			if not val then
				printf("Invalid argument %s in your config file. Check export section.\n", tostring(a))
				table.print(v)
				return nil
			else
				table.insert(fields, val)
			end
		end

		local ok, str1
		if usecolor then
			local tcolor = cor[v.severity] or cor.bug
			ok, str1 = pcall(string.format, tcolor..export.format..color.reset, unpack(fields))
		else
			ok, str1 = pcall(string.format, export.format, unpack(fields))
		end
		if not ok then
			printf("Invalid number of arguments. Check the number of arguments expected in export section.\n")
			return nil
		end
		str1 = string.rep("   ", level)..str1
		str1 = string.gsub(str1, "\n", "%1"..string.rep("   ", level))
		str = str..str1.."\n"

		for lid, l in pairs(v.links) do
			str = str..taskunit.static.print(l, format, usecolor, level+1)	
		end
	end
	return str
end

