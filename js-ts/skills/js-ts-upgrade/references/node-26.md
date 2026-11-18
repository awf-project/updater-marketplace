# Upgrade from Node.js 25 to 26

- Launchers use experimental type transformation or code uses legacy streams and HTTP APIs. [Removed APIs and flags](#removed-apis-and-flags)
- The app or instrumentation calls module.register. [Module loader hooks](#module-loader-hooks)
- The project uses bundled fetch or selects a Temporal polyfill dynamically. [Fetch and Temporal](#fetch-and-temporal)

## Removed APIs and flags

Move `response.writeHeader()` to `response.writeHead()`. For example, replace `require('_stream_transform')` with `require('node:stream').Transform` so callers still receive the constructor. Test status, headers, and stream errors.

Replace `--experimental-transform-types` with the project's compiler or runner for code that requires transformation. Smoke-test the production command for each affected worker or service. An enum or constructor parameter property needs transformation. Run a production entry point containing one of those constructs through the replacement compiler or runner.

## Module loader hooks

Identify what the hooks do before switching to `module.registerHooks()`. The replacement is synchronous and runs in-thread. If hooks need asynchronous setup, move that setup before registration only if resolution and loading can remain synchronous. Exercise both CommonJS and ESM paths where used. [Loader deprecation](https://nodejs.org/api/deprecations.html#dep0205-moduleregister)

## Fetch and Temporal

Test abort, redirect, streaming, or dispatcher behavior against bundled Undici 8. Installing an unrelated `undici` dependency does not update the version backing global `fetch`.

If feature detection activates native `Temporal`, test parsing or serialization at the boundary and a business date that spans a zone-offset transition where relevant.

[26.0.0 release](https://nodejs.org/en/blog/release/v26.0.0), [Patch history](https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V26.md)
