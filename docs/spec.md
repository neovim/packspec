# pkg.json format specification

## Example

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

- Dependencies aren't required to have a `pkg.json` file. Only required for the "leaf nodes".
    - `pkg.json` can declare a dependency on any random artifact fetchable by URL. The upstream dependency doesn't need a `pkg.json`.
- Version specifiers in `dependencies` follow the [NPM version range spec](https://devhints.io/semver) ~~[cargo spec](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html)~~
    - Supported by Nvim `vim.version.range()`.
    - Extensions to npm version spec:
        - `"HEAD"` means git HEAD. (npm version spec defines `""` and `"*"` as latest stable version.)
    - ~~Do NOT support "Combined ranges".~~
    - Treat any string of length >=7 and lacking "." as a commit-id.
    - Only support commit-id, tags, and HEAD.
    - Tags must contain a non-alphanumeric char.
- Out of scope:
    - "pack" (creating a package)
    - "publish" is out of scope, because `pkg.json` is decentralized. Publishing a package means pushing it to a git repo with a top-level `pkg.json`.
    - "uninstall" https://docs.npmjs.com/cli/v9/using-npm/scripts#a-note-on-a-lack-of-npm-uninstall-scripts

## Semantic versioning

Packages SHOULD be [semantically versioned](https://semver.org/). While other versioning schema have uses, semver allows for plugin managers to provide smart dependency resolution.

## File location

Packages MUST have a single, top-level package metadata file named `pkg.json`.
This may be relaxed in the future.

## Fields

* metadata: `pkg.json` allows arbitrary user-defined fields at any nesting level, as long as they don't conflict with specification-owned fields.
    * Like NPM's `package.json`, this makes the format easy to extend. But application fields should be chosen to avoid potential conflict with fields added to future versions of the spec. For example, `devDependencies` may be added to the spec so applications SHOULD NOT extend the format with that field.
* `package` (String) the name of the package
* `version` (String) the version of the package. SHOULD obey semantic versioning conventions. Plugins SHOULD have a git _tag_ matching this version. For all version identifiers, implementation should check for a `version` prefixed with `v` in the git repository, as this is a common convention.
* `source` (String) The URL of the package source archive. Examples: "http://github.com/downloads/keplerproject/wsapi/wsapi-1.3.4.tar.gz", "git://github.com/keplerproject/wsapi.git". Different protocols are supported: 
    * `file://` - for URLs in the local filesystem (note that for Unix paths, the root slash is the third slash, resulting in paths like "file:///full/path/filename"
* `dependencies` (`List[Table]`) Object whose keys are URLs and values are version specifiers.
    * Compare NPM, where URL is the value rather than the key: [URLs as Dependencies](https://docs.npmjs.com/cli/v9/configuring-npm/package-json#urls-as-dependencies)

## Changes

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
