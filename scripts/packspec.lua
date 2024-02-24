local function fatal(s, ...)
  print(string.format(s, ...))
  os.exit(1)
end

if not arg[1] then
  fatal('usage: %s [files...]', arg[0])
end

local jsonschema = require('jsonschema')
local schema = require('packspec.schema')

local validator = jsonschema.generate_validator(schema)

for _, path in ipairs(arg) do
  local spec
  if path:match('%.lua$') then
    local chunk, err = assert(loadfile(path))
    if err then
      fatal('%s: loading failed\n%s', path, err)
    end

    spec = {}
    setfenv(chunk, spec)

    local ok
    ok, err = pcall(chunk)
    if not ok then
      fatal('%s: evaluation failed\n%s', path, err)
    end
  elseif path:match('%.json$') then
    local file, err = assert(io.open(path, 'rb'))
    if err then
      fatal('%s: failed to open file\n%s', path, err)
    end

    local json = (file:read('*a'))
    file:close()
    if not json then
      fatal('%s: could not read the file', path)
    end

    spec, err = vim.json.decode(json)
    if err then
      fatal('%s: decoding json failed\n%s', path, err)
    end
  else
    fatal('invalid filename, expected lua or json file: %s', path)
  end

  local ok, err = validator(spec)
  if not ok then
    fatal('%s: validation failed\n%s', path, err)
  end

  print(string.format('%s: OK', path))
end
