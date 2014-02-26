
schedule = newclass("schedule")

schedule.init = function(self, buglist, effort, team, today)
	self.team = team
	self.tasks = tasks:new(buglist, effort, team, {"severity", "priority", "assigned"})
	self.today = today
end

schedule.show = function(self)
	return self.tasks, 0
end

schedule.summary = function(self, nweeks)
	local t = self.tasks

	printf("SEVERITY\n")
	t:summary_severity(self.today)
	printf("PRIORITY\n")
	t:summary_priority(self.today)
	printf("\nMEMBER LOAD\n")
	t:summary_member(self.today)
end

