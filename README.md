# Plugin metadata specification

The neovim package specification supports a single, top-level package metadata file. This file can be *either* 'plugin.lua' or 'plugin.json'. The file is a superset of the Rockspec File Format and can contain the following fields

* `package` : String, the name of the package

* `version` : String, the version of the package. Should obey semantic versioning conventions, for example `0.1.0`. Plugins should have a git commit with a `tag` matching this version. For all version identifiers, implementation should check for a `version` prefixed with `v` in the git repository, as this is a common convention.

* `specification_version` : String, the current specification version. (0.1.0) at this time.

* `source` : Table, the source is a table that contains a `url` field, which points to the git repository of the current package.

* `description` : Table, the description is a table that includes the following nested fields:
	* `summary` : String, a short description of the package, typically less than 100 character long.
	* `detailed` : String, a long-form description of the package, this should convey the package's principal functionality to the user without being as detailed as the package readme.
	* `homepage` : This is the homepage of the package, which in most cases will be the GitHub URL.
	* `license` : This is [SPDX](https://spdx.org/licenses/) license identifier. Dual licensing is indicated via joining the relevant licenses via `/`.

* `dependencies`
  * `version` Taken from rockspec. Accepted operators are the relational operators of Lua: == ~= < > <= >= , as well as a special operator, ~>, inspired by the "pessimistic operator" of RubyGems ("~> 2" means ">= 2, < 3"; "~> 2.4" means ">= 2.4, < 2.5"). No operator means an implicit == (i.e., "lfs 1.0" is the same as "lfs == 1.0"). "lua" is an special dependency name; it matches not a rock, but the version of Lua in use.

# Example

```lua
package = "lspconfig"
version = "0.1.2"
specification_version = "0.1.0"
source = {
  url = "https://github.com/neovim/nvim-lspconfig.git",
}
description = {
   summary = "Quickstart configurations for the Nvim-lsp client",
   detailed = [[
   	lspconfig is a set of configurations for language servers for use with Neovim's built-in language server client. Lspconfig handles configuring, launching, and attaching language servers.
   ]],
   homepage = "https://github.com/neovim/nvim-lspconfig/", 
   license = "Apache-2.0" 
}
dependencies = {
   neovim = {
      version = ">= 0.6.1",
      source = "https://github.com/neovim/neovim.git"
   },
   gitsigns = {
      version = "> 0.3",
      source = "https://github.com/lewis6991/gitsigns.nvim.git"
   }
}
```

And in json format
```json
{
  "package" : "lspconfig",
  "version" : "0.1.2",
  "specification_version" : "0.1.0",
  "source" : {
     "url" : "https://github.com/neovim/nvim-lspconfig.git",
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
      "source" : "https://github.com/neovim/neovim.git"
    },
    "gitsigns" : {
      "version" : "> 0.3",
      "source" : "https://github.com/lewis6991/gitsigns.nvim.git"
    }
  }
}
```
