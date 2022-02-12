local parse = require("packspec.version_parser")

local unpack = unpack or table.unpack
assert:register("assertion", "err_nil", function(_, arguments)
  local ok, res = pcall(unpack(arguments))
  if ok then
    return res == nil
  else
    return true
  end
end)


describe("version parser", function()
  local p = parse.version

  it("should parse version", function()
    assert.are.same(p("1"), { 1 })
    assert.are.same(p("2.3"), { 2, 3 })
    assert.are.same(p("4.5.6"), { 4, 5, 6 })
    assert.are.same(p("12.34.56"), { 12, 34, 56 })
  end)

  it("should fail on empty string", function()
    assert.err_nil(p, "")
    assert.err_nil(p, " ")
  end)

  it("should fail on invalid characters", function()
    assert.err_nil(p, "x")
    assert.err_nil(p, "1.x")
    assert.err_nil(p, "x.0")
    assert.err_nil(p, "x1.0")
    assert.err_nil(p, "1x.0")
    assert.err_nil(p, "1.x0")
    assert.err_nil(p, "1.0x")
  end)

  it("should fail on spaces between numbers", function()
    assert.err_nil(p, "1 0")
    assert.err_nil(p, "1. 0")
    assert.err_nil(p, "1 .0")
    assert.err_nil(p, "1 . 0")
  end)

  it("should fail on dots delimiting nothing", function()
    assert.err_nil(p, ".")
    assert.err_nil(p, "1..0")
    assert.err_nil(p, "1.")
    assert.err_nil(p, "1.0.")
    assert.err_nil(p, ".1")
    assert.err_nil(p, ".1.0")
  end)
end)


describe("version range parser", function()
  local p = parse.version_range

  it("should parse version", function()
    assert.are.same(p("1"), {
      { { 1 } },
    })
    assert.are.same(p("1.0"), {
      { { 1, 0 } },
    })
  end)

  it("should parse range", function()
    assert.are.same(p("== 1.0"), {
      { { 1, 0 }, "==" },
    })
    assert.are.same(p("~= 1.0"), {
      { { 1, 0 }, "~=" },
    })
    assert.are.same(p(">= 1.0"), {
      { { 1, 0 }, ">=" },
    })
    assert.are.same(p("<= 1.0"), {
      { { 1, 0 }, "<=" },
    })
    assert.are.same(p("> 1.0"), {
      { { 1, 0 }, ">" },
    })
    assert.are.same(p("< 1.0"), {
      { { 1, 0 }, "<" },
    })
    assert.are.same(p("~> 1.0"), {
      { { 1, 0 }, "~>" },
    })
    assert.are.same(p("==1.0"), {
      { { 1, 0 }, "==" },
    })
  end)

  it("should parse multiple ranges", function()
    assert.are.same(p(">= 1.1, < 2.0"), {
      { { 1, 1 }, ">=" },
      { { 2, 0 }, "<" },
    })
    assert.are.same(p(">= 1.1 , < 2.0"), {
      { { 1, 1 }, ">=" },
      { { 2, 0 }, "<" },
    })
    assert.are.same(p(">=1.1,<2.0"), {
      { { 1, 1 }, ">=" },
      { { 2, 0 }, "<" },
    })
    assert.are.same(p(">= 1.1, < 2.0, == 1.2"), {
      { { 1, 1 }, ">=" },
      { { 2, 0 }, "<" },
      { { 1, 2 }, "==" },
    })
  end)

  it("should fail on empty string", function()
    assert.err_nil(p, "")
    assert.err_nil(p, " ")
  end)

  it("should fail on invalid characters", function()
    assert.err_nil(p, "x")
    assert.err_nil(p, "1.0x")
  end)

  it("should fail on invalid operators", function()
    assert.err_nil(p, "=")
    assert.err_nil(p, "~")
  end)

  it("should fail on missing operand", function()
    assert.err_nil(p, "==")
    assert.err_nil(p, "~=")
    assert.err_nil(p, ">=")
    assert.err_nil(p, "<=")
    assert.err_nil(p, ">")
    assert.err_nil(p, "<")
    assert.err_nil(p, "~>")
  end)

  it("should fail on empty expression after comma", function()
    assert.err_nil(p, "1.0,")
    assert.err_nil(p, "1.0, ")
  end)
end)
