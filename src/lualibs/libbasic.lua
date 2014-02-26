
-- ------------------------------------------------------------------------

-- Funcao semelhante ao printf do C.
-- ... (any) Argumentos equivalentes ao do printf.
printf = function(...)
	io.write( string.format(unpack(arg)))
end

-- Divide uma string.
-- str (string) String a dividir.
-- pat (string) Pattern a usar, ver manual do lua para sintaxe.
-- parts (number) Número máximo de partes.
--> (table) Tabela cujos elementos são as partes da string.
string.split = function(str, pat, parts)
	local rv = {}
	local pos = 1
	local n = 0
	if string.find("", pat, 1) then -- this would result in endless loops
		error("delimiter matches empty string!")
		return nil
	end
	local n = 1
	while true do
		local first, last = string.find(str, pat, pos)
		if first then -- found?
			table.insert(rv, string.sub(str, pos, first-1))
			pos = last+1
			n = n + 1
			if parts and n == parts then
				table.insert(rv, string.sub(str, pos))
				return rv
			end
		else
			table.insert(rv, string.sub(str, pos))
			return rv
		end
	end

	return nil
end

-- Função para imprimir um texto dentro de um formato de bloco
-- (string) String a ser impressa
-- (number) Largura do bloco
-- (number) Margem esquerda
blockprint = function(s, blocksize, tab)
	local blocks = string.split(s, "\n")

	for _, b in pairs(blocks) do
		local words = string.split(b, " ")
		local cnt = 0

		if tab and type(tab) == "number" then
			printf("%s", string.rep(" ", tab))
		end

		for _, w in pairs(words) do
			printf("%s ", w)
			cnt = cnt + string.len(w) + 1 -- +1 for the space after s
			if cnt > blocksize then
				printf("\n%s", string.rep(" ", tab))
				cnt = 0
			end
		end
		printf("\n")
	end
end

includeas = function(wrapper, filename)
	local file = io.open(filename,"r")

	if not file then
		return false
	end

	local str = file:read("*all")
	local a=string.format(wrapper, str)                                      
	local f, err = loadstring(a)

	file:close()

	if not f then
		printf("%s\n", err)
		return false
	end

	f()
	return true
end

includeastable = function(filename)
	local ok = includeas("__t={ %s }", filename)

	if not ok then
		return nil
	end
	return __t
end


