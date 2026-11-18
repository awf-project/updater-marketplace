# Upgrade from Rust 1.97 to 1.98

- For `invalid_runtime_symbol_definitions` or `suspicious_runtime_symbol_definitions` on a freestanding `memcpy` or `memset`, compare the exported symbol’s declaration with the target runtime ABI and fix the definition or remove a redundant export. Link the final image to detect duplicate or missing symbols.
- FFI declarations that return `c_void` → regenerate bindings or use unit for C `void` returns. Preserve `c_void` pointer types where required. Exercise existing FFI calls.
- `ambiguous_glob_imports` failures → use explicit imports and compile downstream users of any affected re-export.

- Where a worker moves `std::env::vars()` or `vars_os()` across threads, collect the needed entries into owned values before spawning. The iterators no longer implement `Send` or `Sync`.

[Release notes](https://doc.rust-lang.org/releases.html#version-1980-2026-08-20)
