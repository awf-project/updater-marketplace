# Upgrade from Zig 0.13 to 0.14

- build.zig uses old artifact fields or writes generated sources. [Artifact build definitions](#artifact-build-definitions)
- build.zig.zon names or fingerprints need attention. [Package identity](#package-identity)
- Fields collide with declarations or unmanaged containers use old empty values. [Names and containers](#names-and-containers)

## Artifact build definitions

For a 0.15 migration, move source path, target, optimize, imports, and dependency linkage to the module used as `.root_module`. Check executable, library, and test definitions separately. Use `addUpdateSourceFiles` to update tracked files and pass a `LazyPath` to `addRemoveDirTree`. Build generators through their real steps and compare generated output.

## Package identity

In `build.zig.zon`, rewrite a string package name such as `.name = "example"` as the enum literal `.name = .example`. Run `zig build` and apply the compiler’s suggested `.fingerprint` if the field is missing. Keep an existing fingerprint when upgrading the same package. Verify dependency resolution and any local overrides using a fresh package cache.

## Names and containers

For functions marked with `@setCold(true)`, place `@branchHint(.cold)` at the start of the function body. A hint inside a conditional applies to that branch.

If a field and a declaration share a name, rename one and update its callers. Preserve external field names where they are part of a serialized format. Inspect generated source for the same collision. Initialize empty unmanaged lists and maps with `.empty` and test a mutation followed by cleanup.

[Release notes](https://ziglang.org/download/0.14.0/release-notes.html)
