# The Neovim package specification 

The neovim package specification consists of three components:
1. Guidelines which provide guidance to package authors,
2. the `packspec` file format, and
3. guidelines for `packspec`-compatible plugin manager implementers

This specification is an effort to improve the consistency and reliability of Neovim packages.

# Guidelines for plugin authors

### Semantic versioning

All Neovim packages should be [semantically versioned](https://semver.org/). While other versioning schema have uses, semver allows for plugin managers to provide smart dependency resolution.

# The `packspec` file
The Neovim package specification supports a single, top-level package metadata file. This file can be *either* 'packspec.lua' or 'packspec.json'. The format is loosely based on the [Rockspec Format](https://github.com/luarocks/luarocks/wiki/Rockspec-format) and can contain the following fields:

* `package` (String) the name of the package

* `version` (String) the version of the package. Should obey semantic versioning conventions, for example `0.1.0`. Plugins should have a git commit with a `tag` matching this version. For all version identifiers, implementation should check for a `version` prefixed with `v` in the git repository, as this is a common convention.

* `packspec` (String) the current specification version. (0.1.0) at this time.

* `source` (String) The URL of the package source archive. Examples: "http://github.com/downloads/keplerproject/wsapi/wsapi-1.3.4.tar.gz", "git://github.com/keplerproject/wsapi.git". Different protocols are supported: 

    * `file://` - for URLs in the local filesystem (note that for Unix paths, the root slash is the third slash, resulting in paths like "file:///full/path/filename"
    * `git://` - for the Git source control manager 
    * `git+https://` - for the Git source control manager when using repositories that need https:// URLs
    * `git+ssh://` - for the Git source control manager when using repositories that need SSH login, such as git@example.com/myrepo 
    * `http://` - for HTTP URLs
    * `https://` - for HTTPS URLs

* `description` (Table) the description is a table that includes the following nested fields:
	* `summary` (String) a short description of the package, typically less than 100 character long.
	* `detailed` (String) a long-form description of the package, this should convey the package's principal functionality to the user without being as detailed as the package readme.
	* `homepage` (String) This is the homepage of the package, which in most cases will be the GitHub URL.
	* `license` (String) This is [SPDX](https://spdx.org/licenses/) license identifier. Dual licensing is indicated via joining the relevant licenses via `/`.

* `dependencies` (List[Table]) A list of tables describing the package dependencies. Each entry in the table has the following, only `source` is mandatory:
  * `version` (String) The version constraints on the package.
    * Accepted operators are the relational operators of Lua: == \~= < > <= >= , as well as a special operator, \~>, inspired by the "pessimistic operator" of RubyGems ("\~> 2" means ">= 2, < 3"; "~> 2.4" means ">= 2.4, < 2.5"). No operator means an implicit == (i.e., "lfs 1.0" is the same as "lfs == 1.0"). "lua" is an special dependency name; it matches not a rock, but the version of Lua in use. Multiple version constraints can be joined with a `comma`, e.g. `"neovim >= 5.0, < 7.0"`.
    * If no version is specified, then HEAD is assumed valid. 
    * If no upper bound is specified, then any commit after the tag corresponding to the lower bound is assumed valid. The commit chosen is up to the plugin manager's discretion, but implementers are strongly encouraged to always use the latest valid commit.
    * If an upper bound is specified, then the the tag corresponding to that upper bound is the latest commit that is valid

  * `source` (String|Table) The source of the dependency. See previous `source` description.
  * `releases_only` (Boolean) Whether the package manager should only resolve version constraints to include tagged releases.


* `external_dependencies` (Table) Like dependencies, this specifies packages which are required for the package but should *not* be managed by the Neovim package manager, such as `gcc` or `cmake`. Package managers are encouraged to provide a notification to the user if the dependency is not available.
  * `version` (String) same as `dependencies`

# Example

```lua
package = "lspconfig"
version = "0.1.2"
specification_version = "0.1.0"
source = "git://github.com/neovim/nvim-lspconfig.git",
description = {
   summary = "Quickstart configurations for the Nvim-lsp client",
   detailed = [[
   	lspconfig is a set of configurations for language servers for use with Neovim's built-in language server client. Lspconfig handles configuring, launching, and attaching language servers.
   ]],
   homepage = "git://github.com/neovim/nvim-lspconfig/", 
   license = "Apache-2.0" 
}
dependencies = {
   neovim = {
      version = ">= 0.6.1",
      source = "git://github.com/neovim/neovim.git"
   },
   gitsigns = {
      version = "> 0.3",
      source = "git://github.com/lewis6991/gitsigns.nvim.git"
   }
}
external_dependencies = {
   git = {
      version = ">= 1.6.0",
   },
}
```

And in json format
```json
{
  "package" : "lspconfig",
  "version" : "0.1.2",
  "specification_version" : "0.1.0",
  "source" : "git://github.com/neovim/nvim-lspconfig.git",
  "description" : {
    "summary" : "Quickstart configurations for the Nvim-lsp client",
    "detailed" : "lspconfig is a set of configurations for language servers for use with Neovim's built-in language server client. Lspconfig handles configuring, launching, and attaching language servers",
    "homepage" : "https://github.com/neovim/nvim-lspconfig/", 
    "license" : "Apache-2.0" 
  },
  "dependencies" : {
    "neovim" : {
      "version" : ">= 0.6.1",
      "source" : "git://github.com/neovim/neovim.git"
    },
    "gitsigns" : {
      "version" : "> 0.3",
      "source" : "git://github.com/lewis6991/gitsigns.nvim.git"
    }
  },
  "external_dependencies" : {
    "git" : {
	"version" : ">= 1.6.0",
    },
  }
}
```

# Guidelines for `packspec` implementers

The minimum supported feature set to be considered `packspec`-compatible is:

## Managing package versions
- Must be able to fetch and parse `packspec.json` files
- Must be able to use `git` to retrieve and manipulate package sources
- Must be able to fetch tagged commits for specified package versions
- Must be able to check for updated `packspec.json` files

## Managing Neovim dependencies

- Must be able to check the current version of `Neovim` and warn on incompatibility
- Must be able to retrieve and manage the specified versions of dependencies transitively, starting from user-specified packages
- Must either be able to solve for compatible versions of dependency packages across all dependency relationships, or warn users if using a potentially inconsistent version resolution strategy (e.g. picking the first specified version of a dependency).
- Must be able to remove dependencies when they are no longer required (transitively) by any user-specified packages

## Managing external dependencies

- Must be able to check for the existence of a corresponding executable on the user's system
- Version checking is optional
