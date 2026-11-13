# pkg.json

`pkg.json` is a wild-west "package" format for defining packages without a package system.
It's a (very) limited subset of NPM's `package.json` (except dependencies) that allows any project to declare dependencies on arbitrary URLs.

The initial use-case is for Vim and Emacs plugins (which can be downloaded from anywhere), but the format is designed to be generic.

# TL;DR

```json
{
  "name": "best-plugin.nvim",
  "description": "The best plugin for Neovim",
  "version": "1.0.0",
  "engines": {
      "nvim": ">=0.13.0",
      "vim": ">=9.1.0"
  },
  "scripts": {
    "install": "scripts/install.lua",
    "preupdate": "scripts/preupdate.vim",
    "update": "scripts/update.vim",
    "preuninstall": "scripts/preuninstall.lua"
  },
  "dependencies": [
    {
      "src": "https://github.com/user/plugin1"
    },
    {
      "src": "https://github.com/user/plugin2",
      "version": ">=1.0.0"
    },
    {
      "src": "https://github.com/user/plugin3",
      "version": "'branch'"
    }
  ]
}
```

# Features

- `pkg.json` is just a way to declare dependencies on URLs and versions
- Decentralized ("federated", omg)
- Subset of `package.json` (except dependencies)
- Upstream dependencies don't need a `pkg.json` file.
- Gives aggregators a way to find plugins for their `engine`.

# Used by:

- [vim.pack](https://neovim.io/doc/user/helptag.html?tag=vim.pack) (official client)
- [lazy.nvim](https://github.com/folke/lazy.nvim/)
- TBD

# Limitations

- No client spec (yet): only the format is specified, not client behavior.
- No official client (yet)

# Package requirements

The [package specification](./spec.md) specifies the structure of a package and the `pkg.json` format.

- Dependency URLs are expected to be git repos.
- TODO: support other kinds of artifacts, like zip archives or binaries.

# Client requirements

- `git` (packages can live at any git URL)
- JSON parser
- [client guidelines](./client-spec.md)

# Design

1. Support _all "assets" or "artifacts" of any kind_. 
1. Why JSON:
    - ubiquitous
    - "machine readable" (sandboxed by design): can recursively download an entire dependency tree before executing any code, including hooks. Aggregators such as https://neovimcraft.com/ can consume it.
    - Turing-complete formats (unlike JSON) invite sprawling, special-case behavior (nvim-lspconfig is a [living example](https://github.com/neovim/nvim-lspconfig/pull/2595)).
1. Client requirements are only `git` and a JSON parser.
1. Avoid fields that overlap with info provided by git. Git is a client requirement. Git is the "common case" for servers (but not a requirement).
1. Strive to be a subset of NPM's `package.json`. Avoid unnecessary entropy.
1. No side-effects: evaluating  `pkg.json` not have side-effects, only input and output.

# References

- https://json-schema.org/
- https://github.com/luarocks/luarocks/wiki/Rockspec-format
- [`:h vim.pack-manifest`](https://neovim.io/doc/user/helptag.html?tag=vim.pack-manifest)
- [A way for artifacts to depend on other artifacts.](https://sink.io/jmk/artifact-system)
