return {
  title = "PlugSpec",
  description = "A PlugSpec for a Neovim plugin",
  type = 'object',
  additionalProperties = false,
  properties = {
    package = {
      description = "The name of the package",
      type = "string",
    },
    version = {
      description = [[
        The version of the package. Should obey semantic versioning
        conventions, for example `0.1.0`. Plugins should have a git commit
        with a `tag` matching this version. For all version identifiers,
        implementation should check for a `version` prefixed with `v` in the
        git repository, as this is a common convention.
      ]],
      -- TODO: specify format
      type = "string",
    },
    packspec = {
      description = "The current specification version. (0.1.0) at this time.",
      -- TODO: specify format
      type = "string"
    },
    source = {
      description = [[
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
    },
    description = {
      description = "Description of the package",
      type = 'object',
      additionalProperties = false,
      properties = {
        summary  = {
          description = [[
            Short description of the package, typically less than 100 character
            long.
          ]],
          type = "string"
        },
        detailed = {
          description = [[
            Long-form description of the package, this should convey the
            package's principal functionality to the user without being as
            detailed as the package readme.
          ]],
          type = "string"
        },
        homepage = {
          description = [[
            Homepage of the package. In most cases this will be the GitHub URL.
          ]],
          type = "string"
        },
        license = {
          description = [[
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
              description = [[
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
              -- TODO: specify format
              type = 'string'
            },
            source = {
              description = [[
                Source of the dependency. See previous `source` description.
              ]],
              type = 'string'
            },
            releases_only = {
              description = [[
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
      description = [[
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
              type = 'string'
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
