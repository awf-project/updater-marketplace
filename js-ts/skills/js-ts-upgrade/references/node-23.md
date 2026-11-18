# Upgrade from Node.js 22 to 23

- CommonJS loaders catching `ERR_REQUIRE_ESM` → compare the source 22.x patch because `require(esm)` was backported. Verify export shapes and retain dynamic import for graphs with top-level await.
- Replace removed `util.isBuffer(value)` with `Buffer.isBuffer(value)`. If a binary protocol writer computes offsets or lengths, reject an out-of-bounds write or size the buffer to fit the encoded bytes. Test a packet that exactly fits and one byte beyond.
- Deep assertions on `WeakMap` or `WeakSet` → distinct weak collections now compare unequal. Assert `map.get(knownKey)` or `set.has(knownKey)` when the fixture is testing stored entries.
- Windows x86 builds → move off 32-bit Node. If compiling Node itself, verify C++20 support. Load native addons on the deployed architecture.

[23.0.0 release](https://nodejs.org/en/blog/release/v23.0.0), [Patch history](https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V23.md)
