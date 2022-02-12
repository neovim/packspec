#! /usr/bin/env lua5.1

local function fatal(s, ...)
  print(string.format(s, ...))
  os.exit(1)
end

local path = arg[1]
if not path then
  fatal('usage: %s <file>', arg[0])
end

local jsonschema = require('jsonschema')
local schema = require('packspec.schema')
-- local inspect = require('inspect')

local validator = jsonschema.generate_validator(schema)

local chunk, err = loadfile(path)
if err then
  fatal('%s: loading failed\n%s', path, err)
end

local spec = {}
setfenv(chunk, spec)

local ok
ok, err = pcall(chunk)
if not ok then
  fatal('%s: evaluation failed\n%s', path, err)
end

ok, err = validator(spec)
if not ok then
  fatal('%s: validation failed\n%s', path, err)
end

print(string.format('%s: OK', path))
