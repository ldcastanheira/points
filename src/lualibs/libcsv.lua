

-- Used to escape "'s by toCSV
function escapeCSV (s)
	if string.find(s, '[,"]') then
		s = '"' .. string.gsub(s, '"', '""') .. '"'
	end
	return s
end

-- Convert from CSV string to table
function fromCSV (s)
	s = s .. ','        -- ending comma
	local t = {}        -- table to collect fields
	local fieldstart = 1
	repeat
		-- next field is quoted? (start with `"'?)
		if string.find(s, '^"', fieldstart) then
			local a, c
			local i  = fieldstart
			repeat
				-- find closing quote
				a, i, c = string.find(s, '"("?)', i+1)
			until c ~= '"'    -- quote not followed by quote?
			if not i then error('unmatched "') end
			local f = string.sub(s, fieldstart+1, i-1)
			table.insert(t, (string.gsub(f, '""', '"')))
			fieldstart = string.find(s, ',', i) + 1
		else                -- unquoted; find next comma
			local nexti = string.find(s, ',', fieldstart)
			table.insert(t, string.sub(s, fieldstart, nexti-1))
			fieldstart = nexti + 1
		end
	until fieldstart > string.len(s)
	return t
end

-- Convert from table to CSV string
function toCSV (tt)
	local s = ""
	for _,p in pairs(tt) do
		s = s .. "," .. escapeCSV(p)
	end
	return string.sub(s, 2)      -- remove first comma
end

function CSVFromFile(filename)
	local t = {}
	local fd = io.open(filename)

	if not fd then
		printf("File %s doesn't exist\n", filename)
		return
	end

	-- the file header 
	s = fd:read()

	local h = fromCSV(s)

	-- the file body
	s = fd:read()
	while s do
		local b = fromCSV(s)

		local f = {}
		for i, field in pairs(b) do
			f[h[i]] = field
		end
		table.insert(t, f)
		s = fd:read()
	end
	fd:close()
	return t
end


