CONFIG_FORMAT = {
	class_paths = {
		type = 'table',
		key = { type = 'number' },
		value = { type = 'string' }
	},
	main = { type = 'string' },

	libraries = {
		type = 'table',
		key = { type = 'string' },
		value = { type = 'string' }
	},
	defines = {
		type = 'table',
		key = { type = 'string' }
	},

	target = {
		type = 'string',
		enum = {
			'cpp',
			'eval',
			'hl',
			'java',
			'js',
			'jvm',
			'lua',
			'neko',
			'php',
			'pyhton'
		}
	},
	output = { type = 'string' },

	hxml_prefix = { type = 'string' }
}

local function config_check(data, key, value)
  if data == nil then
    error(string.format("Unknown field '%s' in sobfile.lua", key))
  end

  local value_type = type(value)
  if data.type ~= nil and value_type ~= data.type then
    error(string.format(
      "Field '%s': expected %s, got %s (%s)",
      key, data.type, value_type, tostring(value)
    ))
  end

  if value_type == 'table' then
    if data.length ~= nil and #value ~= data.length then
      error(string.format(
        "Field '%s': expected array of length %d, got %d elements",
        key, data.length, #value
      ))
    end

    for k, v in pairs(value) do
      if data.key ~= nil then
        config_check(data.key, key .. '[key]', k)
      end
      if data.value ~= nil then
        config_check(data.value, key .. '[value]', v)
      end
    end

  elseif data.enum ~= nil then
    local has_match = false
    for _, v in ipairs(data.enum) do
      if value == v then
        has_match = true
        break
      end
    end
    if not has_match then
      error(string.format(
        "Field '%s': invalid value '%s'. Allowed: %s",
        key, tostring(value), table.concat(data.enum, ", ")
      ))
    end

  elseif value_type == 'number' then
    if data.min ~= nil and value < data.min then
      error(string.format(
        "Field '%s': value %s must be ≥ %s",
        key, tostring(value), tostring(data.min)
      ))
    elseif data.max ~= nil and value > data.max then
      error(string.format(
        "Field '%s': value %s must be ≤ %s",
        key, tostring(value), tostring(data.max)
      ))
    end
  end
end

local conf = {}
conf.hxml = require('sob.hxmlbuild')

return setmetatable(conf, {
	__newindex = function(t, k, v)
		config_check(CONFIG_FORMAT[k], k, v);
		rawset(t, k, v)
	end
})
