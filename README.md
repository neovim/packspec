# pkg.json

> The JSON of package specs.

`pkg.json` is a wild-west "package" format for defining packages without a package system.
It's a (very) limited subset of NPM's `package.json` (except dependencies) that allows any project to declare dependencies on arbitrary URLs.

The initial use-case is for Vim and Emacs plugins (which can be downloaded from anywhere), but the format is designed to be generic.

See [/docs](https://github.com/neovim/packspec/tree/main/docs) for full documentation.

## tl;dr

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

## Build

    brew install luarocks
    make
    make test

## Run tests

    cd test-npm/
    npm ci
    npm run test

## What about LuaRocks?

LuaRocks is a natural choice as the Nvim plugin manager, but defining a "federated package spec" also makes sense because:

- We can do both, at low cost. `pkg.json` is a fairly "cheap" approach.
- LuaRocks is a "centralized" approach that requires active participation from many plugins.
  In contrast, `pkg.json` is a decentralized, "infectious" approach that is useful at the "leaf nodes":
  it only requires the consumer to provide a `pkg.json`, the upstream dependencies don't need to be "compliant" or participate in any way.
- LuaRocks + Nvim is starting to see [progress](https://github.com/lumen-oss), but momentum will take time.
  A decentralized, lowest-common-denominator, "infectious" approach can be tried without losing much time or effort.
- There's no central _asset registry_, just a bunch of URLs. (Though "aggregators" are possible and welcome.)
- LuaRocks has 10x more scope than `pkg.json` and [unresolved edge cases](https://github.com/luarocks/luarocks/issues/905).
  `pkg.json` side-steps that by punting the ecosystem-dependent questions to the client.

## Release

TBD

## TODO

- [x] specify packspec (above)
- [ ] specify ecosystem-agnostic client behavior (report conflicts, fetch things into `pack/` dir, update existing dir, ...)
- [ ] specify what is undefined (i.e. owned by the per-ecosystem "engine", for example vim/nvim packages are fetched into 'packpath')
- [ ] TODO: support other kinds of artifacts, like zip archives or binaries.
- [ ] nested packages in workspace (`foo/pkg.json`, `foo/bar/pkg.json`)
- [ ] Nvim: client can support conflicting dependencies by using git worktree.
