---
name: zig-upgrade
description: Plan or apply a Zig compiler upgrade for an existing project. Use for migrating Zig language syntax, standard library APIs, build definitions and packages through successive Zig releases.
---

# Upgrade a Zig project

Compare `zig version`, project, CI and container pins, and the requested target. Check `.minimum_zig_version` in `build.zig.zon` separately from the compiler pin. For development builds compare the exact compiler commit. Resolve “latest stable” from [Zig downloads](https://ziglang.org/download/).

If the current project already satisfies the request across in-scope versions and pins, report a no-op and stop before loading migration references or building. Run any explicitly requested checks.

## Migration checks by target series

- [Zig 0.14](references/zig-0.14.md), [0.15](references/zig-0.15.md), [0.16](references/zig-0.16.md), [0.17](references/zig-0.17.md)
- Read the official release notes for each crossed series and any intervening patch announcements. Match the language, stdlib and build changes to the exact compiler and targets in use. Resolve API discrepancies against the build or stdlib declarations of the exact compiler revision.

## Apply and verify

- In a plan, tie each action to a project file, pin, or affected runtime behavior and cite the release entry that calls for it. Limit implementation edits to the in-scope pins and affected usages.
- For implementation, make `build.zig.zon` and `build.zig` work on the target compiler before adapting application source. Refresh package hashes when dependencies change. Raise the declared floor when the new code requires it.
- Use the target compiler for the project's build and test steps. Include affected release targets, optimization modes, and C linkage. Exercise changed IO and allocation paths for ownership and cleanup on failure.
