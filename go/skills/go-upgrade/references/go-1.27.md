# Upgrade from Go 1.26 to 1.27

- The app publishes or persists JSON or uses experimental v2. [JSON compatibility](#json-compatibility)
- Builds enable goroutineleakprofile or override timers or TLS. [Retired runtime settings](#retired-runtime-settings)
- CI parses test events, uses Bazaar modules, or inspects require blocks. [Build and test automation](#build-and-test-automation)

## JSON compatibility

The v1 API now runs on the v2 implementation. Exercise existing imports before considering an API migration. Include custom marshalers, error handling, and nil and empty values. Compare exact bytes where signed or hashed payloads require them.

For experimental v2 callers, move the `inline` option to `embed`. Remove uses of `DiscardUnknownMembers`, the `unknown`/`format` tag options, or `SkipFunc` from experimental v2 call sites. Where code reads numeric `jsontext.Token` values, handle the new error result before consuming the number. Verify unknown-field handling and custom handler order.

## Retired runtime settings

Remove `GOEXPERIMENT=goroutineleakprofile` from build scripts and verify profile collection with the target binary. Locate `GODEBUG`, `godebug`, and `//go:debug` overrides. For removed settings, final-default values can still be accepted in source directives, while obsolete values can fail the build.

If `asynctimerchan=1` kept the old timer behavior, remove the override. Replace `len(t.C)` readiness polling with a nonblocking `select` where consuming the tick is intended. Timer channels are now synchronous even with an older module floor. Re-test the deployed peers for any legacy TLS settings identified on the [1.26 step](go-1.26.md#tls-peers).

## Build and test automation

Use the `stdversion` diagnostics now enabled by `go test` to find standard-library uses newer than the relevant module or file floor. Fix the API use or version-gate the newer implementation when retaining older Go.

Accept optional `OutputType` on JSON output events. Migrate direct Bazaar origins. When `go mod tidy` merges `require` blocks for modules declaring 1.27+, compare selected versions using `go list -m all` before adjusting layout-sensitive scripts.

[Release notes](https://go.dev/doc/go1.27)
