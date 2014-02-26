
--% Copia uma tabela por conteudo.
--@ src (table) Tabela a copiar.
--:     (table) Copia de src.
table.clone = function(src)
    if type(src) == "table" then
        local dst = {}
        local meta = getmetatable(src)
        if meta then
            setmetatable(dst, meta)
        end
        for k,v in pairs(src) do
            dst[k] = table.clone(v)
        end
        return dst
    else
        return src
    end
end

table.print = function( src, depth, tab )
    tab = tab or "   "

    depth = depth or 100

    if depth == 0 then
        print()
        return
    end

    if type(src) == "table" then
		print()
        for k,v in pairs(src) do
            io.write( string.format(tab.."%s= ", k) )
            table.print( v, depth-1, tab.."   " )
        end
    else
        print( src )
    end
end

table.save = function(src, filename, depth)

	saverec = function( src, depth, tab, fd)
		if type(src) == "table" then
			for k,v in pairs(src) do
				local name
				local delim = {}

				if type(k) == "number" then
					name = string.format("[%d]= ", k)
				else
					name = string.format("[\"%s\"]= ", k)
				end
				if type(v) == "table" then
					delim = { "{\n", "},\n"}
				else
					delim = {"", "\n"}
				end

				fd:write( string.format(tab..name..delim[1]) )
				saverec( v, depth-1, tab.."   ", fd )
				fd:write( string.format(tab..delim[2]) )
			end
		else
			if type(src) == "string" then
				fd:write( "\""..tostring(src).."\"," )
			else
				fd:write( tostring(src).."," )
			end
		end
	end

    local tab = tab or "   "
	local fd = fd or io.open(filename, "w")

    depth = depth or 100

    if depth == 0 then
        return
    end

	if name then
		fd:write( name.."= {\n" )
		saverec(src, depth, tab, fd)
		fd:write("}\n" )
	else
		saverec(src, depth, tab, fd)
	end

	fd:close()
end

table.diff = function (table1, table2)

	local step = level or 0
	local lrt = {} 

	if table.getn(table1) ~= table.getn(table2) then
		print("Warning: Tables have different sizes")
	end

	local field2, value2 = next(table2)

	for field1, value1 in pairs(table1) do

		if type(value1) ~= type(value2) then
			print("Error: Tables have different structures")
			table.insert(lrt, "different structure")
			return lrt
		end

		if type(value1) == "table" then
			printf("Warning: Field %s is a table. Comparing recursively...\n", field1)
			print(value1, value2)
			lrt[field1] = table_diff(value1, value2)

		elseif value1 ~= value2 then
			print("Fields have different values", value1, value2)
			local f1 = string.format("table1:%s", field1)
			local f2 = string.format("table2:%s", field2)
			lrt[f1] = value1
			lrt[f2] = value2
		end

		field2, value2 = next(table2, field2)
	end


	return lrt
end

table.sortbyidx = function(tab)
    local s = {}
    local result = {}

    for i, v in pairs(tab) do
        table.insert(s, i)
    end

    table.sort(s)

    for i, v in pairs(s) do
        table.insert(result, {v, tab[v]})
    end

    return result
end

--% Sort a table of tables
--@ tab table of table
--@ field filed of table used to sort tables
--: table sorted and a new field called idx with table index
--ex: a={["end1"]={rua="cel mach", num=1}, {["end2"]={rua="barao", num=2},..}
--sorted=table.sortbyfield(a, "num")
table.sortbyfield = function(tab, field)
	local tmp = {}
	local ltab = {}

	for i, v in pairs(tab) do
		tmp = v
		tmp.idx=i
		table.insert(ltab, tmp)
	end
	table.sort(ltab, function(a,b) return (a[field] < b[field]) end)

	return ltab
end

table.rep = function(tab, field)
    local s = {}

    for i, v in pairs(tab) do
        rep = v[field]

        if type(rep) ~= "number" then
            printf("Field %s must be a number\n", tostring(field))
        end
        for n=1, rep do
            table.insert(s, v)
        end
    end
    return s
end

table.find = function(tab, val)
	local found = false

	for i, v in pairs(tab) do
		if type(v) == "table" then
			found = table.find(v, val)
		elseif v == val then
			return true
		end
		if found == true then
			return true
		end
	end
	return false
end

table.tabconcat = function(table1, table2)

	if not table1 then
		return table2
	elseif not table2 then
		return table1
	end

	local duptab
	local newtab = table.clone(table1)

	for t, tab in pairs(table2) do
		if newtab[t] then
			if not duptab then
				duptab = {}
			end
			table.insert(duptab, t)
		end
		newtab[t] = tab
	end

	return newtab, duptab
end

table.merge = function(table1, table2)

	if not table1 then
		return table2
	elseif not table2 then
		return table1
	end

	local newtab = table.clone(table1)

	for t, tab in pairs(table2) do
		if newtab[t] then
			if type(newtab[t]) == "table" then
				newtab[t] = table.merge(newtab[t], tab)
			else
				newtab[t] = tab
			end
		else
			newtab[t] = tab
		end
	end

	return newtab
end

insertsortedbyfields = function(tab, valtab, idx, lockedfields, fields)
	local f = fields[1]

	for i=idx, table.getn(tab) do
		local t = tab[i]

		-- if any table has no "f" field, insert here
		if not t[f] or not valtab[f] then
			break
		end

		-- check if some previous fields are unlocked
		for lid, l in pairs(lockedfields) do
			if t[lid] ~= l then
				table.insert(tab, i, valtab)
				return
			end
		end

		-- check if we'll compare fields with same type
		if type(t[f]) ~= type(valtab[f]) then
			table.insert(tab, i, valtab)
			return
		end

		-- if same value, lock field and go to the next field
		if t[f] == valtab[f] and table.getn(fields) > 1 then
			table.remove(fields, 1)
			lockedfields[f] = t[f]
			insertsortedbyfields(tab, valtab, i, lockedfields, fields)
			return
		elseif t[f] > valtab[f] then
			table.insert(tab, i, valtab)
			return
		end
	end
	table.insert(tab, valtab)
end

table.insertsortedbyfields = function(tab, valtab, ...)
	local lockedfields = {}

	arg.n = nil
	insertsortedbyfields(tab, valtab, 1, lockedfields, arg)
end

table.nremove = function(tab, i, n)
	for v=i, n do
		table.remove(tab, v)
	end
	return tab
end

