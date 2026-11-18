---
name: rust-upgrade
description: Plan or apply a Rust toolchain or edition upgrade for an existing crate or workspace. Use for successive Rust compiler releases, Cargo compatibility, MSRV checks, and edition migrations.
---

# Upgrade a Rust project

Compare the effective toolchain, workspace and CI pins, package MSRV (`rust-version`), and inherited or explicit edition against the requested scope. Read the project pin and run `rustup toolchain list` from outside the project to avoid triggering an install. Probe an installed version with `rustc +<installed-toolchain> -Vv` if needed. [Rustup overrides](https://rust-lang.github.io/rustup/overrides.html), [Cargo MSRV](https://doc.rust-lang.org/cargo/reference/rust-version.html)

If the current project already satisfies the request across in-scope versions and pins, report a no-op and stop before loading migration references or running build checks. Run any explicitly requested checks. Resolve “latest” from [Rust releases](https://blog.rust-lang.org/releases/).

## Migration checks by target series

- Read the official release entries for every toolchain version crossed, including patch entries. Match compatibility notes to crate features, targets, and Cargo consumers. An installed `rust-docs` for the target toolchain supplies the release history offline. [Rust 1.98](references/rust-1.98.md), [1.99](references/rust-1.99.md), [1.100](references/rust-1.100.md), [release history](https://doc.rust-lang.org/releases.html)
- For an edition change, first verify the existing edition on the target toolchain. Read the edition release announcement linked from the bridge guide and follow the [Edition Guide](https://doc.rust-lang.org/edition-guide/) for crossed editions and the [2021 to 2024 checks](references/edition-2024.md) for that bridge.

## Apply and verify

- In a plan, tie each action to a project file, pin, or affected runtime behavior and cite the release entry that calls for it. For a toolchain-only upgrade, update the in-scope pins and surface any edition or MSRV blockers.
- Start with the existing lockfile. Trace blockers to dependency MSRV, features, or target support before updating packages. If retaining older Cargo, verify resolver and lockfile compatibility.
- Use `--locked` for checks that consume a tracked lockfile. Test the relevant targets and feature combinations, including doctests and conditional code where changed. Check any retained MSRV.
