# Upgrade from Node.js 24 to 25

- Images or CI call corepack enable or assume package-manager shims. [Corepack and reproducible installs](#corepack-and-reproducible-installs)
- The app uses legacy access constants, recursive rmdir, or GC to close handles. [File access and cleanup](#file-access-and-cleanup)
- Tests instantiate assert.CallTracker. [Call assertions](#call-assertions)

## Corepack and reproducible installs

Node no longer ships Corepack. Provision the pinned package manager or standalone Corepack at the layer that already owns provisioning. Compare `packageManager` with the actual binary and run a frozen install in a clean image without inherited shims.

## File access and cleanup

Move `fs.F_OK`, `R_OK`, `W_OK`, and `X_OK` references on `fs` to `fs.constants`. Replace `fs.rmdir(path, { recursive: true }, cb)` with `fs.rm(path, { recursive: true }, cb)` and retain `rmdir` for empty-directory-only callers. Choose `force` according to the required missing-path behavior. Test both missing and present directories and verify other errors still propagate.

Close `FileHandle` objects in `finally` or with a disposal mechanism supported by the target. Exercise a failure after open.

## Call assertions

For distinct promises passed to a deep equality assertion, await both and compare their resolved values if the test asserts result equality. Node 25 compares promise identity.

For `assert.CallTracker`, move to the existing test framework’s mocks. In `node:test`, use `t.mock.fn()` and assert `mock.callCount()` after the awaited call or event. Verify that a missing call fails when the old assertion ran at process exit.

[25.0.0 release](https://nodejs.org/en/blog/release/v25.0.0), [Patch history](https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V25.md)
