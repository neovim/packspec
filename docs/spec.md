# pkg.json format specification

## Example

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

- All top-level fields are optional.
- Dependencies aren't required to have a `pkg.json` file. Only required for the "leaf nodes".
    - `pkg.json` can declare a dependency on any random artifact fetchable by URL. The upstream dependency doesn't need a `pkg.json`.
- Packages distributed as Git repositories SHOULD have a git _tag_ matching its version. Packages SHOULD obey semantic versioning conventions. For all version identifiers, implementation should check for a version prefixed with `v` in the git repository, as this is a common convention.
- Out of scope:
    - "pack" (creating a package), see [`vim.pack`](https://neovim.io/doc/user/helptag.html?tag=vim.pack)
    - "publish" is out of scope, because `pkg.json` is decentralized. Publishing a package means pushing it to a git repo with a top-level `pkg.json`.

## Semantic versioning

Packages SHOULD be [semantically versioned](https://semver.org/). While other versioning schema have uses, semver allows for plugin managers to provide smart dependency resolution.

## File location

Packages MUST have a single, top-level package metadata file named `pkg.json`.
This may be relaxed in the future.

## Fields

- `name` (`string`) Package name
- `description` (`string`) Package description
- `version` (`string`) Package version
- `engines` (`table`) Supported engine versions. Values should be semver ranges (like `>=0.13` or `1.2.3 - 2.3.4`):
     - `nvim` (`string`) Version range for Nvim.
     - `vim` (`string`) Version range for Vim.
- `dependencies`  (`table[]`) A list of data that package declares as its dependencies. All should be installable with a proper client implementation. Each data has the following fields:
    - `src` (`string`) REQUIRED Source to install from.
    - `version` (`string`) Suggested version:
        - If describes a semver constraint (like `">=1.0.0"`), clients will install if it entirely fits into a constraint specified by the user for this package (if present).
        - If quoted string (like `"'branch'"`, `"'tag'"`, `"'abcdef123'"`), describes the branch/tag/commit. Clients will install if a constraint specified by the user (if present) is exactly the same target.
        - If missing, no version is suggested and clients don't have to check for version constraints.
- `scripts` (`table`) Script locations (relative to package's root) to source (allowed file formats depend on the client capabilities):
    - `install` (`string`) Post install script.
    - `preuninstall` (`string`) Pre delete script.
    - `preupdate` (`string`) Pre update script.
    - `update` (`string`) Post update script.
- metadata: `pkg.json` allows arbitrary user-defined fields at any nesting level, as long as they don't conflict with specification-owned fields.
    - Like NPM's `package.json`, this makes the format easy to extend. But application fields should be chosen to avoid potential conflict with fields added to future versions of the spec. For example, `devDependencies` may be added to the spec so applications SHOULD NOT extend the format with that field.

## Changes

Stage 2:
- aligned with [official client implementation](https://neovim.io/doc/user/helptag.html?tag=vim.pack-manifest)

Stage 1:
- renamed `packspec.json` to `pkg.json`  ~~`deps.json`~~ (to hint that it's basically a subset of NPM's `package.json`)
- removed `"version" : "0.1.2",` because package version is provided by the `.git` repo info
- removed `external_dependencies`
- removed `specification_version`. The lack of a "spec version" field means the spec version is `1.0.0`. If breaking changes are ever needed then we could introduce a "spec version" field.
- renamed `"source" : "git:…",` to `repository.url`
- renamed `package` to `name` (to align with NPM)
- changed the shape of `description` from object to string (to align with NPM)
- changed `dependencies` shape to align with NPM. Except the keys are URLs.
    - Leaves the door open for non-URL keys in the future.

## Closed questions

- Top-level application-defined "metadata" field (`client`, `user`, `metadata`, ...?) for use by clients (package managers)?
    - `pkg.json` allows arbitrary application-defined fields, as `package.json` does.
- "Ecosystem-agnostic" means that https://luarocks.org packages can't be consumed?
    - If Nvim plugins can successfully use luarocks then `pkg.json` is redundant. `pkg.json` is only useful for ecosystems that don't have centralized package management.
- Are git submodules/subtrees a viable solution for git-only dependency trees?
    - https://stackoverflow.com/a/61961021/152142
    - pro: avoids another package/deps format
    - con:
        - not easy for package authors to implement (run `git` commands instead of editing a json file)
        - no `engines` field: how will aggregators build a package list?
        - no support for non-git blobs
- Does the lack of a `version` field mean that a manifest file always tracks HEAD of the git repo?
    - The dependents declare what version they need, which must be available as a git tag in the dependency. Thus no need for `pkg.json` to repeat that information. The reason that `package.json` and other package formats need a `version` field is because they _don't_ require a `.git` repo to be present.
- Should consumers of dependencies need to control how a dependency is resolved?
    - `repository.type` is available for future use if we want to deal with that.
- It'd be nice if the spec enforces globally unique names... Then `dependencies` could look like `{ "dependencies": { "plenary.nvim": "1.0.0" } }`
    - Requiring URIs achieves that, without a central registry.
- Should `name` be removed? Because `repository.url` already defines the "name" (which can be prettified in UIs).
    - Defined `name` as OPTIONAL and strictly cosmetic (not used for programmatic decisions or filesystem paths).
- `package.json` has an [`engines` field](https://docs.npmjs.com/cli/v9/configuring-npm/package-json#engines) that declares what software can _run_ the package. Example:
  ```
  "engines": {
      "vscode": "^1.71.0"
  },
- How to deal with dependencies moving to a new host? Should `pkg.json` support "fallback" URLs?
    - The downstream must update its URLs.

## Open questions

- should URL be the version (value) rather than the key? see NPM [URLs as Dependencies](https://docs.npmjs.com/cli/v9/configuring-npm/package-json#urls-as-dependencies)
- via @folke: most important to ideally be in the spec:
    - ✅ dependencies
    - ✅ metadata probably makes sense, NPM itself allows arbitrary fields in `package.json`
    - ❓ build
    - ❓whether the plugin needs/supports setup()
    - ❓main module for the plugin (lazy guesses that automatically, but would be better to have this part of the spec)
- Can `pkg.json` be a strict subset of NPM `package.json` ? The ability to validate it with https://www.npmjs.com/package/read-package-json is attractive...
- Non-git dependencies ("blobs"): require version specifier to be object (instead of string):
    - `"https://www.leonerd.org.uk/code/libvterm/libvterm-0.3.2.tar.gz": { "type": "tar+gzip", "version": "…" }`
    - How can a package manager know the blob has been updated if there's no git info? (Answer: undefined.)
- `scripts` and "build-time" tasks ([lifecycle](https://docs.npmjs.com/cli/v9/using-npm/scripts#life-cycle-operation-order))
    - Scripts must be array of strings (unlike npm package.json).
    - Scripts are run from the root of the package folder, regardless of what the current working directory is.
    - Predefined script names and lifecycle order:
        - These all run after fetching and writing the package contents to the engine-defined package path, in order.
        - `preinstall`
        - `install`
        - `postinstall`
- Naming conflict: what happens if `https://github.com/.../foo` and `https://sr.ht/.../foo` are in the dependency tree?
  ```
   .local/share/nvim/site/pack/github.com/start/
   .local/share/nvim/site/pack/sr.ht/start/
   ```
