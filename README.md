# `plugin.json`

The neovim package specification supports a single, top-level package metadata file. This file can be *either* 'plugin.lua' or 'plugin.json'. The file is a superset of the Rockspec File Format and can contain the following fields

* `package` : String, the name of the package

* `version` : String, the version of the package. Should obey semantic versioning conventions, for example `0.1.0`. For all version identifiers, implementation should check for a `version` prefixed with `v` in the git repository, as this is a common convention.

* `specification_version` : String, the current specification version. (0.1.0) at this time.


* `source` : Table, the source is a table that contains a `url` field, which points to either the git commit of the current version of the package, or the source tarball.

* `description` : Table, the description is a table that includes the following nested fields:
	* `summary` : String, a short description of the package, typically less than 100 character long.
	* `detailed` : String, a long-form description of the package, this should convey the package's principal functionality to the user without being as detailed as the package readme.
	* `homepage` : This is the homepage of the package, which in most cases will be the GitHub URL.
	* `License` : This is [SPDX](https://spdx.org/licenses/) license identifier. Dual licensing is indicated via joining the relevant licenses via `/`.

* `dependencies`
** TBD

# Example

```lua
package = "lspconfig"
version = "0.1.2"
specification_version = "0.1.0"
source = {
   url = "https://github.com/neovim/nvim-lspconfig/archive/refs/tags/v0.1.2.tar.gz"
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
   "neovim >= 0.6.1"
}
```

And in json format
```json
{
  "package" : "lspconfig",
  "version" : "0.1.2",
  "specification_version" : "0.1.0",
  "source" : {
    "url" : "https://github.com/neovim/nvim-lspconfig/archive/refs/tags/v0.1.2.tar.gz"
  },
  "description" : {
    "summary" : "Quickstart configurations for the Nvim-lsp client",
    "detailed" : "lspconfig is a set of configurations for language servers for use with Neovim's built-in language server client. Lspc onfig handles configuring, launching, and attaching language servers",
    "homepage" : "https://github.com/neovim/nvim-lspconfig/", 
    "license" : "Apache-2.0" 
  },
  "dependencies" : {
     "neovim >: 0.6.1"
  }
}
```
