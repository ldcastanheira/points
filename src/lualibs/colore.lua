--| Funções de cores ANSI/VT no terminal.
--- Uso:
--- print(color.red .. "vermelho" .. color.reset)
--- print(color("red", "vermelho"))
--- print(color("boldredongreen", "contraste"))
--- etc.


--% Tabela que vai conter todas as cores criadas.
color = {}


--% Caracter ESC.
local esc = string.char(27)


--% Código de foreground das cores.
local foreground = {
	black  = esc .. "[30m",
	red    = esc .. "[31m",
	green  = esc .. "[32m",
	yellow = esc .. "[33m",
	blue   = esc .. "[34m",
	purple = esc .. "[35m",
	cyan   = esc .. "[36m",
	white  = esc .. "[37m",
}


--% Código de background das cores.
local background = {
	black  = esc .. "[40m",
	red    = esc .. "[41m",
	green  = esc .. "[42m",
	yellow = esc .. "[43m",
	blue   = esc .. "[44m",
	purple = esc .. "[45m",
	cyan   = esc .. "[46m",
	white  = esc .. "[47m",
}


--% Efeitos especiais
local specials = {
	bold        = esc .. "[1m",
	bright      = esc .. "[1m",
	italic      = esc .. "[3m",
	underline   = esc .. "[4m",
	nounderline = esc .. "[24m",
	inverse     = esc .. "[7m",
	reset       = esc .. "[0m",
}


--% Função que cria o código dado o nome da cor.
--@ colorpar (string) String com a descrição da cor.
--- Pode conter efeitos especiais, e duas cores. A primeira será usada no
--- foreground, a segunda no background.
local colorfunc = function(colorpar)
	local rv = ""
	local colorstr = colorpar

	-- Funcao que concatena a cor/efeito no resultado e a/o elimina da string
	-- sendo processada.
	local processa = function(key, val)
		local ini, fim
		ini, fim = string.find(colorstr, key)
		if ini then
			rv = rv .. val
			colorstr = string.sub(colorstr, 1, ini - 1) .. string.sub(colorstr, fim + 1)
		end
	end

	-- Acho todos efeitos especiais e os concateno.
	local rvbk = nil
	while rvbk ~= rv do
		rvbk = rv
		for key,val in pairs(specials) do
			processa(key, val)
		end
	end

	-- Acho a primeira cor.
	local primeira_pos = string.len(colorstr)
	local primeira_cor

	for key,val in pairs(foreground) do
		local pos = string.find(colorstr, key)
		if pos and pos < primeira_pos then
			primeira_pos = pos
			primeira_cor = key
		end
	end

	if primeira_cor then
		processa(primeira_cor, foreground[primeira_cor])
	end

	-- Acho a segunda cor.
	for key,val in pairs(background) do
		processa(key, val)
	end

	color[colorpar] = rv

	return rv
end


--% Função que certa a string dada com a cor dada, efetivamente colorindo a
--- string.
local colorize = function(cor, str)
	return color[cor] .. str .. color.reset
end


--% Metatable de color.
local mt = {}


--% Para que ao chamar uma cor desconhecida essa seja criada automaticamente.
mt.__index = function(table, cor)
	return colorfunc(cor)
end


--% Para que ao chamar color(), color.colorize seja chamada.
mt.__call = function(func, ...)
	return colorize(unpack(arg))
end


setmetatable(color, mt)



