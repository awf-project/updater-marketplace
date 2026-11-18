# Upgrade from Zig 0.14 to 0.15

- Executable library or test definitions use fields removed in 0.15. [Build root modules](#build-root-modules)
- The code uses old generic readers writers or custom format methods. [Buffered IO and formatting](#buffered-io-and-formatting)
- std.ArrayList operations or owned slices cross a boundary. [ArrayList and allocator ownership](#arraylist-and-allocator-ownership)

## Build root modules

Replace inline `.root_source_file` on `b.addExecutable` with `.root_module = b.createModule(.{ .root_source_file = b.path("src/main.zig"), .target = target, .optimize = optimize })`, substituting the existing source path and settings. Attach imports and linkage to the module that uses them. Build the actual executable, library, and test artifacts, including a configured cross-target when they used separate target options.

## Buffered IO and formatting

Identify which boundary produces or consumes `std.Io.Reader` and `std.Io.Writer`. A stdout port can keep the concrete writer and buffer in scope through the final flush.

```zig
var buffer: [4096]u8 = undefined;
var stdout = std.fs.File.stdout().writer(&buffer);
try stdout.interface.print("{s}\n", .{message});
try stdout.interface.flush();
```

For a type implementing custom `format`, remove the `comptime fmt` and `FormatOptions` parameters and use `pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void`. Select it with `{f}` at the call site. Test redirected output, short reads, and failed writes if those paths matter. Keep flush errors visible to the caller.

## ArrayList and allocator ownership

Start with `.empty` for an unmanaged list and pass its allocator to operations such as `append`, `toOwnedSlice`, and `deinit`. Ensure the caller of a returned slice knows which allocator frees it. Use `std.array_list.Managed` if preserving an API that stores the allocator inside the value. Exercise allocation failure and cleanup before and after ownership moves.

[Release notes](https://ziglang.org/download/0.15.1/release-notes.html)
