# pkg.json

- `pkg.json` is just a way to declare dependencies on URLs and versions
- Decentralized ("federated", omg)
- Subset of `package.json`
- Upstream dependencies don't need a `pkg.json` file.
- No client spec (yet)
- No official client (yet)
- TODO: support conflicting dependencies using git worktree.
- Useful for: vim, nvim, emacs, (others?)
- Used by:
    - [lazy.nvim](https://github.com/folke/lazy.nvim/)
    - TBD

## Build

    brew install luarocks
    make
    make test

## Run tests

    cd test-npm/
    npm ci
    npm run test

## Release

TBD

