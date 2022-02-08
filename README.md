# Plugin metadata specification

The neovim package specification supports a single, top-level package metadata file. This file can be *either* 'plugin.lua' or 'plugin.json'. The format is loosely based on the [Rockspec Format](https://github.com/luarocks/luarocks/wiki/Rockspec-format) and can contain the following fields:

* `package` : String, the name of the package

* `version` : String, the version of the package. Should obey semantic versioning conventions, for example `0.1.0`. Plugins should have a git commit with a `tag` matching this version. For all version identifiers, implementation should check for a `version` prefixed with `v` in the git repository, as this is a common convention.

* `specification_version` : String, the current specification version. (0.1.0) at this time.

* `source` : Table, the source is a table that contains a `url` field, which points to the git repository of the current package.

* `source` : Table, contains information on how to fetch sources. Contains a url field, which points to upstream repository of the package. url (string, mandatory field) : the URL of the package source archive. Examples: "http://github.com/downloads/keplerproject/wsapi/wsapi-1.3.4.tar.gz", "git://github.com/keplerproject/wsapi.git". Different protocols are supported: 

  * file:// - for URLs in the local filesystem (note that for Unix paths, the root slash is the third slash, resulting in paths like "file:///full/path/filename"
  * git:// - for the Git source control manager 
  * git+https:// - for the Git source control manager when using repositories that need https:// URLs
  * git+ssh:// - for the Git source control manager when using repositories that need SSH login, such as git@example.com/myrepo 
  * http:// - for HTTP URLs
  * https:// - for HTTPS URLs

* `description` : Table, the description is a table that includes the following nested fields:
	* `summary` : String, a short description of the package, typically less than 100 character long.
	* `detailed` : String, a long-form description of the package, this should convey the package's principal functionality to the user without being as detailed as the package readme.
	* `homepage` : This is the homepage of the package, which in most cases will be the GitHub URL.
	* `license` : This is [SPDX](https://spdx.org/licenses/) license identifier. Dual licensing is indicated via joining the relevant licenses via `/`.

* `dependencies`
  * `version` Taken from rockspec. Accepted operators are the relational operators of Lua: == \~= < > <= >= , as well as a special operator, \~>, inspired by the "pessimistic operator" of RubyGems ("\~> 2" means ">= 2, < 3"; "~> 2.4" means ">= 2.4, < 2.5"). No operator means an implicit == (i.e., "lfs 1.0" is the same as "lfs == 1.0"). "lua" is an special dependency name; it matches not a rock, but the version of Lua in use. Multiple version constraints can be joined with a `comma`, e.g. `"neovim >= 5.0, < 7.0"`.
  * `source`: The source of the dependency. See previous `source` description.

* `external_dependencies` : Like dependencies, this specifies packages which are required for the package but should *not* be managed by the neovim package manager, such as `gcc` or `cmake`
  * `version` same as `dependencies`

# Example

```lua
package = "lspconfig"
version = "0.1.2"
specification_version = "0.1.0"
source = {
  url = "git://github.com/neovim/nvim-lspconfig.git",
}
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
  "source" : {
     "url" : "git://github.com/neovim/nvim-lspconfig.git",
  },
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
