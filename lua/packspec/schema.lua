local pat_version = [[(0|[1-9][0-9]*)(\.(0|[1-9][0-9]*))*]]
local pat_range = [[((==|~=|<|>|<=|>=|~>)\s*)?]]..pat_version

local PAT_VERSION = "^"..pat_version.."$"
local PAT_RANGE = "^"..pat_range..[[(\s*,\s*]]..pat_range..[[)*$]]
local PAT_URL = [[^(file|git(\+(https?|ssh))?|https?)://]]

local function dedent(s)
  local lines = {}
  local indent = nil

  for line in s:gmatch("[^\n]*\n?") do
    if indent == nil then
      if not line:match("^%s*$") then
        -- save pattern for indentation from the first non-empty line
        indent, line = line:match("^(%s*)(.*)$")
        indent = "^"..indent.."(.*)$"
        table.insert(lines, line)
      end
    else
      if line:match("^%s*$") then
        -- replace empty lines with empty string
        table.insert(lines, "")
      else
        -- strip indentation on non-empty lines
        line = assert(line:match(indent), "inconsistent indentation")
        table.insert(lines, line)
      end
    end
  end

  lines = table.concat(lines)
  -- trim trailing whitespace
  return lines:match("^(.-)%s*$")
end

return {
  title = "packspec",
  description = "A package specification for Neovim",
  type = 'object',
  additionalProperties = false,
  properties = {
    package = {
      description = "The name of the package",
      type = "string",
    },
    version = {
      description = dedent [[
        The version of the package. Should obey semantic versioning
        conventions, for example `0.1.0`. Plugins should have a git commit
        with a `tag` matching this version. For all version identifiers,
        implementation should check for a `version` prefixed with `v` in the
        git repository, as this is a common convention.
      ]],
      type = "string",
      pattern = PAT_VERSION,
    },
    packspec = {
      description = "The current specification version. (0.1.0) at this time.",
      type = "string",
      pattern = PAT_VERSION,
    },
    ["$schema"] = {
      description = "The optional json schema URI for validation with json-language-server.",
      type = "string"
    },
    source = {
      description = dedent [[
      The URL of the package source archive. Examples:
      "http://github.com/downloads/keplerproject/wsapi/wsapi-1.3.4.tar.gz",
      "git://github.com/keplerproject/wsapi.git". Different protocols are
      supported:

          * `file://` - for URLs in the local filesystem (note that for Unix
            paths, the root slash is the third slash, resulting in paths like
            "file:///full/path/filename"
          * `git://` - for the Git source control manager
          * `git+https://` - for the Git source control manager when using
            repositories that need https:// URLs.
          * `git+ssh://` - for the Git source control manager when using
            repositories that need SSH login, such as git@example.com/myrepo.
          * `http://` - for HTTP URLs
          * `https://` - for HTTPS URLs
      ]],
      type = "string",
      pattern = PAT_URL,
    },
    description = {
      description = "Description of the package",
      type = 'object',
      additionalProperties = false,
      properties = {
        summary  = {
          description = dedent [[
            Short description of the package, typically less than 100 character
            long.
          ]],
          type = "string"
        },
        detailed = {
          description = dedent [[
            Long-form description of the package, this should convey the
            package's principal functionality to the user without being as
            detailed as the package readme.
          ]],
          type = "string"
        },
        homepage = {
          description = dedent [[
            Homepage of the package. In most cases this will be the GitHub URL.
          ]],
          type = "string"
        },
        license = {
          description = dedent [[
            This is [SPDX](https://spdx.org/licenses/) license identifier. Dual
            licensing is indicated via joining the relevant licenses via `/`.
          ]],
          type = "string"
        }
      }
    },

    dependencies = {
      patternProperties = {
        [".*"] = {
          type = 'object',
          additionalProperties = false,
          properties = {
            version = {
              description = dedent [[
                Version constraints on the package.
                  * Accepted operators are the relational operators of Lua:
                    == \~= < > <= >= , as well as a special operator, \~>,
                    inspired by the "pessimistic operator" of RubyGems
                    ("\~> 2" means ">= 2, < 3"; "~> 2.4" means ">= 2.4, < 2.5").
                    No operator means an implicit == (i.e., "lfs 1.0" is the
                    same as "lfs == 1.0"). "lua" is an special dependency name;
                    it matches not a rock, but the version of Lua in use.
                    Multiple version constraints can be joined with a `comma`,
                    e.g. `"neovim >= 5.0, < 7.0"`.
                  * If no version is specified, then HEAD is assumed valid.
                  * If no upper bound is specified, then any commit after the
                    tag corresponding to the lower bound is assumed valid. The
                    commit chosen is up to the plugin manager's discretion, but
                    implementers are strongly encouraged to always use the
                    latest valid commit.
                  * If an upper bound is specified, then the the tag
                    corresponding to that upper bound is the latest commit that
                    is valid
              ]],
              type = 'string',
              pattern = PAT_RANGE,
            },
            source = {
              description = dedent [[
                Source of the dependency. See previous `source` description.
              ]],
              type = 'string',
              pattern = PAT_URL,
            },
            releases_only = {
              description = dedent [[
                Whether the package manager should only resolve version
                constraints to include tagged releases.
              ]],
              type = 'boolean'
            }
          }
        }
      }
    },

    external_dependencies = {
      description = dedent [[
        Like dependencies, this specifies packages which are required for the
        package but should *not* be managed by the Neovim package manager, such
        as `gcc` or `cmake`. Package managers are encouraged to provide a
        notification to the user if the dependency is not available.
      ]],
      patternProperties = {
        [".*"] = {
          type = "object",
          additionalProperties = false,
          properties = {
            version = {
              description = "Same as `dependencies`",
              type = 'string',
              pattern = PAT_RANGE,
            }
          }
        }
      }
    }
  },

  required = {
    "package",
    "source"
  }

}
