# Upgrade from Rust 1.99 to 1.100

- Code relies on never fallback or defines impls for Infallible and the never type. [Type inference and trait coherence](#type-inference-and-trait-coherence)
- Cargo emits cargo unused dependencies diagnostics. [Dependency lints](#dependency-lints)
- CI reads intermediate paths, installs tools, or sorts toolchain pins. [Build layout and installed tools](#build-layout-and-installed-tools)

## Type inference and trait coherence

Never-type fallback changes to `!` on all editions. When inference or a trait bound changes, annotate the intended result type. For example, if `f<T: Default>() -> Result<T, E>` was called as `f()?;` solely for its side effect, use `f::<()>()?;` to preserve unit as the result type. `Infallible` now aliases `!`, so inspect impl pairs that now overlap and consolidate them where they refer to the same case. Compile downstream code if a public bound or signature changes.

## Dependency lints

Check whether the dependency is used under a platform, optional feature, test, or build configuration before removing it. Run the affected target and feature combinations after any manifest edit. Package-wide builds alone can miss uses in feature-specific code.

## Build layout and installed tools

In scripts that glob intermediate paths, consume `cargo build --message-format=json` and select `compiler-artifact` records by target and package. Use `executable` for a runnable artifact, or `filenames` for library outputs. Verify cache restoration separately. Compare version components numerically so 1.100 follows 1.99. `cargo install` uses the crate's published lockfile when present. Smoke-test tools in the final build image when prior workflows depended on fresh dependency resolution. [Cargo JSON output](https://doc.rust-lang.org/stable/cargo/reference/external-tools.html#json-messages)

[Release notes](https://doc.rust-lang.org/releases.html#version-11000-2026-11-12)
