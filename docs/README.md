# pkg.json

`pkg.json` allows artifacts to depend on other artifacts, by URLs.
You can think of it as a "federated package spec": it's just a JSON file that
lists URLs in a simple format that is dead simple to write a client for.

The initial use-case is for Vim and Emacs plugins (which can be downloaded from
anywhere). But the format is designed to be ecosystem-agnostic: it's just
a formalized way to list dependencies by URL.

# Features

- `pkg.json` is just a way to declare dependencies on URLs and versions
- Decentralized ("federated", omg)
- Subset of `package.json`
- Upstream dependencies don't need a `pkg.json` file.
- No client spec (yet): only the format is specified, not client behavior.
- No official client (yet)
- TODO: support conflicting dependencies using git worktree.
- Useful for: vim, nvim, emacs, (others?)
- Used by:
    - [lazy.nvim](https://github.com/folke/lazy.nvim/)
    - TBD

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
