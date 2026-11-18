# Upgrade from Rust edition 2021 to 2024

- Any crate in scope moves from edition 2021 to 2024. [Prepare the workspace](#prepare-the-workspace)
- The code uses `if let` expressions, opaque returns, or exported macros. [Temporary lifetimes and public types](#temporary-lifetimes-and-public-types)
- A caller uses `.into_iter()` on `Box<[T]>`. [Boxed slice iteration](#boxed-slice-iteration)
- FFI, unsafe attributes, static mut, or process environment mutation is present. [Unsafe boundaries](#unsafe-boundaries)

## Prepare the workspace

Confirm Rust 1.85+ and verify the current edition on the target toolchain first. Run `cargo fix --edition` while the crate is still declared as 2021. Include targets and feature combinations that reach conditional code. Review the diff before changing manifests, then run the affected tests and doctests on 2024.

Update the actual source of the edition, including `[workspace.package]` for inheriting members. A virtual workspace can select its resolver independently. Declare resolver 3 explicitly if choosing it, then compare features and the lockfile at the retained MSRV. [Cargo resolver](https://doc.rust-lang.org/edition-guide/rust-2024/cargo-resolver.html)

## Temporary lifetimes and public types

An `if let` scrutinee temporary can drop before the `else` branch. Exercise both branches where a lock, borrow, or cleanup relies on drop order. Bind a value explicitly if its lifetime is part of behavior. Review tail-expression temporary drops when the compiler points to a temporary borrowing a local.

For public return-position `impl Trait`, check whether the new inferred capture reaches an otherwise unused lifetime and changes downstream borrow behavior. Use an explicit capture bound when the contract requires it. Check `macro_rules!` arms whose `expr` matches can change, including `expr_2021` when preserving the old matcher. Compile representative downstream usages. [Lifetime capture](https://doc.rust-lang.org/edition-guide/rust-2024/rpit-lifetime-capture.html), [Macro fragments](https://doc.rust-lang.org/edition-guide/rust-2024/macro-fragment-specifiers.html)

## Unsafe boundaries

Review signatures and ABIs before adding `unsafe extern`. Audit `#[unsafe(no_mangle)]` and similar attributes for their actual safety invariants. Move unsafe operations into explicit blocks that document the invariant. When a reference to `static mut` is rejected, review synchronization and aliasing before choosing a replacement.

For code mutating process-global environment variables, establish why the operation is safe or pass per-command environment settings through `Command` where that matches the behavior. Exercise the affected platform or FFI boundary. [Unsafe extern blocks](https://doc.rust-lang.org/edition-guide/rust-2024/unsafe-extern.html), [Newly unsafe functions](https://doc.rust-lang.org/edition-guide/rust-2024/newly-unsafe-functions.html)

## Boxed slice iteration

For a `Box<[T]>` receiver, method-call `.into_iter()` now yields owned elements. Use `.iter()` where the loop should borrow and the caller still needs the boxed slice afterwards. Compile a caller that reuses it after the loop.

[Rust 1.85 and edition 2024 release](https://blog.rust-lang.org/2025/02/20/Rust-1.85.0/), [Edition Guide](https://doc.rust-lang.org/edition-guide/rust-2024/index.html)
