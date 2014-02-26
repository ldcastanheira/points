
local show_options = function (t)

	local cb = {}

	for c, option in pairs(t) do
		local desc = option[1]
		local ident = string.format("%s", option[2])
		local func = option[3]
		local args = option[4]

		cb[ident] = {func, args}

		printf("[%s] %s\n", ident or c, desc)
	end

	return cb
end

screen = {
	buff = {},
	start = 0,
}

round = function(val)
	if val - math.floor(val) > 0.5 then
		return math.ceil(val)
	else
		return math.floor(val)
	end
end

screen.ruler = function()
	printf(" ")
	for i=1, 8 do
		printf("        %d", i*10)
	end
	printf("\n")
	for i=1, 80 do
		if math.mod(i, 10) == 0 then
			printf("|")
		else
			printf("%d", math.mod(i, 10))
		end
	end
	printf("\n")
end

screen.add = function (x, y, str)
	x = round(x)
	y = round(y)
	if not screen.buff[y] then
		screen.buff[y] = {}
	end
	if not screen.buff[y][x] then
		screen.buff[y][x] = {}
	end
	screen.buff[y][x] = str
end

screen.clear = function ()
	print("\027[2J")    -- limpa a tela
	print("\027[0;0H")  -- posiciona cursor em (0,0)
	screen.start = 0
end

screen.movex = function (x)
	printf("\r")
	printf("\027[%dC", x)
end

screen.movey = function (y)
	printf("\027[%dB", y)
end

screen.str = function(x, y, str, align, style)
	local xx

	if align == "right" then
		xx = x - string.len(str)
	elseif align == "center" then
		xx = x - (string.len(str)-1)/2
	else
		xx = x
	end

	if xx < 0 then
		xx = 0
	end
	if style and color[style] then
		str = color[style]..str..color.reset
	end
	screen.add(xx, y, str)
end

screen.lineh = function(x, y, xx, str)
	local s = string.rep(str, xx-x)
	
	screen.add(x, y, s)
end

screen.linev = function(x, y, yy, str)
	y = math.floor(y)
	for i=y, yy do
		screen.add(x, i, str)
	end
end

screen.print = function(save)
	local line = 0

	for y, xtable in pairs(screen.buff) do
		local jumpy = y - line

		screen.movey(jumpy)

		for x, str in pairs(xtable) do
			screen.movex(x)
			printf("%s", str)
		end
		printf("\n")
		line = y
	end

	if not save then
		screen.buff = {}
	end
end

screen.menu = function (t)
	local cb = show_options(t)

	printf("Option :")
	local op = io.read()

	if not cb[op] or (cb[op] and type(cb[op][1]) ~= "function") then
		return cb[op][2]
	end

	return cb[op][1](unpack(cb[op][2]))

end


