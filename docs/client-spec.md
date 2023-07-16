# pkg.json client specification

_Work-in-progress: These guideliens are subject to change._

pkg.json clients...

## Fetching dependencies

- MUST be able to fetch and parse `pkg.json` files
- MUST be able to use `git` to clone dependencies and query git repo info
- MUST be able to fetch tagged commits for specified package versions
- MUST be able to check for updated `pkg.json` files

## Resolving dependencies

- MUST be able to check the current version of `Neovim` and warn on incompatibility
- MUST be able to fetch and manage the specified versions of dependencies transitively: if dependencies have `pkg.json`, read it and process it, recursively.
- MUST either be able to solve for compatible versions of dependency packages across all dependency relationships, or warn users if using a potentially inconsistent version resolution strategy (e.g. picking the first specified version of a dependency).
- MAY remove dependencies when they are no longer required (transitively) by any user-specified packages
