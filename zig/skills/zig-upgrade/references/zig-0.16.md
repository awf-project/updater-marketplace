# Upgrade from Zig 0.15 to 0.16

- The app reads arguments or environment or performs file socket clock or process operations. [Process initialization and IO](#process-initialization-and-io)
- The app uses std.fs.cwd or readFileAlloc with an existing maximum size. [Bounded file reads](#bounded-file-reads)
- The code relies on std.Thread.Pool or containers that became unmanaged. [Concurrency and allocations](#concurrency-and-allocations)

## Process initialization and IO

Use `main(init: std.process.Init)` at the CLI boundary and pass `init.io` down to affected operations. Read argument/environment data from the initialization inputs. Keep reusable functions parameterized by the IO and allocator they actually need. Pass `std.testing.io` in relevant tests. Exercise the actual command, missing arguments, and errors or timeouts on supported hosts.

For a duration logger still using `{D}` with a nanosecond count, change the format to `{f}` and pass `std.Io.Duration{ .nanoseconds = ns }`. Keep the existing time unit at the logging boundary.

## Bounded file reads

Use `std.Io.Dir.cwd()` and pass an IO context. With `.limited(limit)`, input at or above the threshold fails with `error.StreamTooLong`. A prior inclusive cap of 4096 bytes becomes a threshold of 4097.

```zig
const bytes = try std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(4097));
defer allocator.free(bytes);
```

Verify 4095, 4096, and 4097-byte files when preserving that cap. For a computed cap, account for representability before adding one. [Zig 0.16 standard library](https://codeberg.org/ziglang/zig/src/tag/0.16.0/lib/std/Io/Dir.zig)

## Concurrency and allocations

Choose the replacement based on whether tasks must overlap or can run synchronously. `std.Io.Group.async` can run inline. If two tasks must make progress together, use `io.concurrent` (or the group equivalent) and handle `error.ConcurrencyUnavailable`. Avoid holding a resource while starting a task that may need it immediately. Test shutdown, cancellation, and completion with a task that reaches the intended blocked or in-flight state.

Pass the same allocator to allocating operations and teardown for newly unmanaged containers. Exercise partial failure and ownership transfer from the caller's entry point.

[Release notes](https://ziglang.org/download/0.16.0/release-notes.html)
