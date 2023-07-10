#! /usr/bin/env lua5.1

-- local cjson = require('cjson')
local schema = require('packspec.schema')
local format_json = require('utils.format_cjson')
local encoded_json = format_json(schema, "\n", "  ")..'\n'

local file = io.open('schema/packspec_schema.json', 'w')

io.output(file)
io.write(encoded_json)
io.close(file)
