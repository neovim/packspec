#! /usr/bin/env lua5.1

local jsonschema = require('jsonschema')
local schema = require('packspec.schema')
-- local inspect = require('inspect')

local validator = jsonschema.generate_validator(schema)

local path = arg[1]

local spec_chunk, err = loadfile(path)
if err then
  error(err)
end

local spec = spec_chunk()

local ok
ok, err = validator(spec)

if not ok then
  error(err)
end
print(string.format('%s successfully validated', path))
