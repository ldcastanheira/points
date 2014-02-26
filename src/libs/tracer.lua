
tracer = { data = {}, net = {} }

tracer_on = function(msg)
	local data = tracer.data
	local net = tracer.net

	if not data[msg] then
		data[msg] = {}
	end

	local p1, p2
	local tb = debug.traceback("", 2)

	p1, p2 = string.find(tb, " *[%w|%p]+:%d+: in function '%w+'")
	local toparse = string.sub(tb, p1, p2)

	p1, p2 = string.find(toparse, "[%w|%p]+:%d")
	local file = string.sub(toparse, p1, p2-2) -- discard the number and : at the end

	p1, p2 = string.find(toparse, ":%d+:")
	local line = string.sub(toparse, p1+1, p2-1)

	p1, p2 = string.find(toparse, "function '%w*'")
	func = string.sub(toparse, p1+10, p2-1)

	local event = {
		time = os.time(), 
		file = file,
		line = line,
		func=func,
	}

	table.insert(data[msg], event)
	table.insert(net, {msg = msg, event = event})
end

tracer_off = function(msg)
	return
end

tracer.clean = function(msg)
	tracer.data = {}
	tracer.net = {}
end

tracer.on = function()
	tl = tracer_on
end

tracer.off = function()
	tl = tracer_off
end

trace_print = function(first, last, nrep)
	if first then
		if last then
			print(string.format("%s:%d:%s %-40s [%s.<%d>.%s]", 
			first.event.file, first.event.line, first.event.func, first.msg, 
			os.date("%y-%m-%d %H:%M:%S", first.event.time), 
			nrep,
			os.date("%y-%m-%d %H:%M:%S", last.event.time)))
		else
			print(string.format("%s:%d:%s %-40s [%s]", 
			first.event.file, first.event.line, first.event.func, first.msg, 
			os.date("%y-%m-%d %H:%M:%S", first.event.time)))
		end
	end
end

tracer.run = function()
	local net = tracer.net
	local first
	local last
	local nrep = 0

	for _, t in pairs(net) do
		if first and t.msg == first.msg then
			last = t
			nrep = nrep + 1
		else
			trace_print(first, last, nrep)			
			first = t
			last = nil
			nrep = 1
		end
	end
	trace_print(first, last)
end

tl = tracer.off

