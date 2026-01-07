return function(self, name)
	local hxml = ''
	local function addln(ln)
		hxml = hxml .. ln .. '\n'
	end

	if self.class_paths ~= nil then
		for _, class_path in ipairs(self.class_paths) do
			addln('-cp ' .. class_path)
		end
	end

	if self.main ~= nil then
		addln('-m ' .. self.main)
	else
		error('Main is not specified')
	end

	if self.libraries ~= nil then
		for l, v in pairs(self.libraries) do
			if v == 'latest' then
				addln('-L ' .. l)
			else
				addln('-L ' .. l .. ':' .. v)
			end
		end
	end

	if self.defines ~= nil then
		for d, v in pairs(self.defines) do
			if tostring(v) == '1' then
				addln('-D ' .. d)
			else
				addln('-D ' .. d .. '=' .. v)
			end
		end
	end

	if self.target == nil then
		error('Target is not specified')
	elseif self.target == 'eval' then
		addln('--interp')
	elseif self.output == nil then
		error('Output is not specified')
	else
		addln('--' .. self.target .. ' ' .. self.output)
	end

	local hxml_path = '.sob/' .. name .. '.hxml'
	if self.hxml_prefix ~= nil then
		hxml_path = self.hxml_prefix .. name .. '.hxml'
	end

	local dir = hxml_path:match('(.*[/\\])') or './'
	if dir ~= './' then
		os.execute('mkdir "' .. arg[1] .. dir .. '"')
	end

	local f = io.open(arg[1] .. hxml_path, 'w')
	if f ~= nil then
		f:write(hxml)
		f:flush()
	else
		error(string.format('Failed to save %s', arg[1] .. hxml_path))
	end

	io.stdout:write(hxml_path)
end
