# Upgrade from Node.js 23 to 24

- The project uses bundled npm, native addons, or a Windows Node build. [Install and native modules](#install-and-native-modules)
- The app uses AsyncLocalStorage or relies on node:test scheduling. [Async context and subtests](#async-context-and-subtests)
- Launchers use the permission model or code uses fs.truncate or Dirent.path. [Permissions and filesystem](#permissions-and-filesystem)
- The app switches on URLPattern or uses global fetch. [Runtime feature detection](#runtime-feature-detection)

## Install and native modules

For projects using bundled npm, run the clean locked install with npm 11 and verify lifecycle scripts and peer resolution. Test addons in the actual architecture and libc of the final artifact. ClangCL is required to build Node itself on Windows, and addon requirements depend on the addon.

## Async context and subtests

With `AsyncContextFrame` enabled, run two concurrent requests with different context values through the actual callbacks or instrumentation. Check context after asynchronous work and isolation between requests. The runner now waits for subtests automatically. If parent cleanup closes a resource still used by a child, await that child before cleanup or put cleanup in the corresponding test teardown.

## Permissions and filesystem

Use `--permission` in launchers and verify permitted and rejected operations. Replace `fs.truncate(fd, len, cb)` with `fs.ftruncate(fd, len, cb)` and the synchronous form with `fs.ftruncateSync(fd, len)`. Retain `fs.truncate` for path arguments. For a full path, join `Dirent.parentPath` and `name`. Use a nested fixture to test recursive enumeration and relative path handling.

## Runtime feature detection

Exercise the new native `URLPattern` branch where a polyfill is conditionally installed. With bundled Undici 7, verify the headers, redirects, or streaming behavior the application relies on.

[24.0.0 release](https://nodejs.org/en/blog/release/v24.0.0), [Patch history](https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V24.md)
