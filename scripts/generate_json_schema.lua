local schema = require('packspec.schema')
-- TODO(justinmk): could eliminate format_cjson if `vim.json.encode()` had formatting options.
local format_json = require('utils.format_cjson')

local encoded_json = format_json(schema, "\n", "  ")..'\n'
local file = assert(io.open('schema/packspec_schema.json', 'w'))
io.output(file)
io.write(encoded_json)
io.close(file)
