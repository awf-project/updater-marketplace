# Upgrade from Zig 0.16 to 0.17

- The build uses b.args, host program lookup, or a custom build runner. [Build arguments and configuration](#build-arguments-and-configuration)
- The project uses @cImport or b.addTranslateC. [C translation and linkage](#c-translation-and-linkage)
- The code uses bit casts reflection removed syntax or backed enum conversions. [Representation and language changes](#representation-and-language-changes)
- The app uses old std names optimization modes or ZON allocation APIs. [Library and ZON ownership](#library-and-zon-ownership)
- The target range crosses 0.17.1 with custom writers or lazy artifacts. [Patch checks for writers and lazy dependencies](#patch-checks-for-writers-and-lazy-dependencies)

## Build arguments and configuration

Use `run_cmd.addPassthruArgs()` and check a real `zig build run -- ...` invocation. Use `b.findProgramLazy` where only an executed step needs the program. Retain eager lookup only where the result affects configuration. Verify a step that does not use the program with that program absent.

Replace custom runner overrides with the supported build server protocol or `--print-configuration` for configuration introspection. Exercise a cached build and the dependency changes the custom runner used to detect.

## C translation and linkage

Move C translation to the official `translate-c` dependency compatible with 0.17. Pass the header, target, optimize setting, and required libraries to `Translator.init`. Import `translator.mod` under the expected module name. Keep header search paths and linkage equivalent to the old translation step. For Linux builds using a custom `libc.txt`, supply `cc_dir` (formerly `gcc_dir`) pointing to the target compiler runtime objects. On Android or OpenHarmony these can be in `crt_dir`.

Compile and link each target using the generated bindings. Check the actual calling ABI and one representative C call where the target is runnable. [Translator options](https://codeberg.org/ziglang/translate-c#options)

## Representation and language changes

For array/vector `@bitCast`, compare golden bytes across supported endiannesses because packing follows logical element order. Where the operation means native memory reinterpretation, inspect the layout and appropriate alignment of the chosen representation. Port `@typeInfo` consumers to fields such as `field_names` and `field_types`. Test declarations previously found through same-file private lookups.

Give `@splat` an array result type when replacing single-element repetition, for example `const zeros: [16]u8 = @splat(0);`. Where an `errdefer` capture was used for logging, catch the error at the fallible call and preserve cleanup in `errdefer`. Use `@backingInt` and `@fromBackingInt` with the exact backing type, and validate untrusted integers before converting to exhaustive enums.

## Library and ZON ownership

Move `std.builtin` references to `std.lang` as applicable. Update optimization tags to `.debug`, `.safe`, `.fast`, or `.small` and build each configured mode. Use `allocator.print` for `std.fmt.allocPrint` and `last()` for old `ArrayList.getLastOrNull()` calls. Test an empty list.

For ZON, move arguments into options. Choose `fromSliceNoAlloc` for the old non-allocating path or `fromSlice` for the allocating path. Keep the arena alive until the last use of parsed values and diagnostics. Exercise an invalid file and consume its diagnostic before teardown.

## Patch checks for writers and lazy dependencies

Confirm a writer returns a write error during flush against the selected patch. With conditional lazy dependencies, run the affected build from a clean cache and verify the dependency is resolved on demand. [0.17.1 release](https://ziglang.org/news/0.17.1-released/)

[Release notes](https://ziglang.org/download/0.17.0/release-notes.html)
