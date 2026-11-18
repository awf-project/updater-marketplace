# Upgrade from Rust 1.98 to 1.99

- CI relies on warm incremental artifacts or uses hyphenated lint keys. [CI caches and Cargo lints](#ci-caches-and-cargo-lints)
- Edition 2024 or newer members inherit dependencies. [Inherited dependency features](#inherited-dependency-features)
- The release builds native x86_64 FFI, UEFI, embedded, or macOS targets. [Patch specific target checks](#patch-specific-target-checks)

## CI caches and Cargo lints

Cargo disables incremental compilation by default under `CI`. Compare a clean and a cache-restored build. If intentionally restoring incremental artifacts, make that setting explicit only for the jobs that benefit. Rename keys such as `unsafe-code` to `unsafe_code` in `[lints.rust]` or `[workspace.lints.rust]`, preserving the configured level. Cargo now warns on hyphenated lint names. [Cargo changelog](https://doc.rust-lang.org/cargo/CHANGELOG.html#cargo-199-2026-10-01)

## Inherited dependency features

On an edition-2024 member, `serde = { workspace = true, default-features = false }` now disables defaults on that dependency edge even when the workspace definition enables them. If the member needs a missing feature, declare it there. Compare `cargo tree -e features` for each affected member as well as the workspace. Cargo can still unify defaults enabled by another dependency edge. Verify the supported combinations in the same target and feature context used by CI.

## Patch specific target checks

Review 1.99.1 for the FFI `bool` return, UEFI/embedded `wcslen`, and macOS `rust-lld` fixes. Exercise both FFI return values and link or start affected target artifacts. Use the exact patch against the project's targets.

[Release notes](https://doc.rust-lang.org/releases.html#version-1990-2026-10-01), [1.99.1](https://doc.rust-lang.org/releases.html#version-1991-2026-10-15)
