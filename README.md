# pkg.json

`pkg.json` is a wild-west "package" format for defining packages without a package system.
It's a (very) limited subset of NPM's `package.json` that allows any project to declare dependencies on arbitrary URLs.

The initial use-case is for Vim and Emacs plugins (which can be downloaded from anywhere), but the format is designed to be generic.

See [/docs](https://github.com/neovim/packspec/tree/main/docs) for full documentation.

## TL;DR

```
{
  "name" : "lspconfig", // OPTIONAL cosmetic name, not used for resolution nor filesystem locations.
  "description" : "Quickstart configurations for the Nvim-lsp client", // OPTIONAL
  "engines": {
      "nvim": "^0.10.0",
      "vim": "^9.1.0"
  },
  "repository": { // REQUIRED
      "type": "git", // reserved for future use
      "url": "https://github.com/neovim/nvim-lspconfig"
  },
  "dependencies" : { // OPTIONAL
    "https://github.com/neovim/neovim" : "0.6.1",
    "https://github.com/lewis6991/gitsigns.nvim" : "0.3"
  },
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
- LuaRocks + Nvim is starting to see [progress](https://github.com/nvim-neorocks), but momentum will take time.
  A decentralized, lowest-common-denominator, "infectious" approach can be tried without losing much time or effort.
- There's no central _asset registry_, just a bunch of URLs. (Though "aggregators" are possible and welcome.)
- LuaRocks has 10x more scope than `pkg.json` and [unresolved edge cases](https://github.com/luarocks/luarocks/issues/905).
  `pkg.json` side-steps that by punting the ecosystem-dependent questions to the client.

## Release

TBD
