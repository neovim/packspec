# pkg.json

`pkg.json` is a wild-west "package" format for defining packages without a package system.
It's a (very) limited subset of NPM's `package.json` that allows any project to declare dependencies on arbitrary URLs.

The initial use-case is for Vim and Emacs plugins (which can be downloaded from anywhere), but the format is designed to be generic.

# TL;DR

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

# Features

- `pkg.json` is just a way to declare dependencies on URLs and versions
- Decentralized ("federated", omg)
- Subset of `package.json`
- Upstream dependencies don't need a `pkg.json` file.
- Gives aggregators a way to find plugins for their `engine`.

# Used by:

- [lazy.nvim](https://github.com/folke/lazy.nvim/)
- TBD

# Limitations

- No client spec (yet): only the format is specified, not client behavior.
- No official client (yet)
- TODO: support conflicting dependencies using git worktree.

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
- lazy.nvim [pkg.json impl](https://github.com/folke/lazy.nvim/pull/910/files#diff-eeb8f2e48ace6e2f4c40bf159b7f59e5eb1208e056a3f9f1b9cc6822ecb45371)
- [A way for artifacts to depend on other artifacts.](https://sink.io/jmk/artifact-system)
