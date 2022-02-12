local parse = {}

---@alias Version       number[]
---@alias Operator      "==" | "~=" | "<" | ">" | "<=" | ">=" | "~>"
---@alias VersionExpr   { [1]: Version, [2]: Operator|nil }

---@param s string
---@return Version
function parse.version(s)
  assert(type(s) == "string", "expected string")
  s = assert(s:match("^%s*(.-)%s*$"), "invalid version")

  local v = {}
  while true do
    local p = assert(s:match("^%d+"), "invalid version")
    table.insert(v, tonumber(p))
    s = s:sub(#p + 1)

    if #s == 0 then break end
    assert(s:match("^%."), "invalid version")
    s = s:sub(2)
  end
  return v
end

---@param s string
---@return VersionExpr[]
function parse.version_range(s)
  assert(type(s) == "string", "expected string")
  local res = {}

  while true do
    -- skip leading whitespace
    s = assert(s:match("^%s*(%S.*)"), "empty expression")

    -- parse operator
    local op = s:match("^[=~<>]=") or s:match("^[<>]") or s:match("^~>")
    if op then
      s = assert(s:sub(#op + 1):match("^%s*(%S.*)"), "expected version")
    end

    -- parse version
    local v = assert(s:match("^[%d%.]+"), "expected version")
    table.insert(res, { parse.version(v), op })

    -- next expression
    s = s:sub(#v + 1):match("^%s*(%S.*)")
    if not s then break end
    assert(s:match("^,"), "trailing characters")
    s = s:sub(2)
  end

  return res
end

return parse
