# Upgrade from Go 1.25 to 1.26

- Scripts invoke go tool doc, go mod init, or go fix. [Module automation](#module-automation)
- The service is latency-sensitive or uses goroutine-leak diagnostics. [Collector and profiles](#collector-and-profiles)
- The app sets CurvePreferences or carries legacy GODEBUG switches. [TLS peers](#tls-peers)

## Module automation

Change invocations of `go tool doc` to `go doc` with the same flags and arguments. Fixtures for `go mod init` should expect a 1.25.0 floor from a 1.26 release toolchain. Check generators that assert the exact manifest or use newer library APIs. Preview analyzer rewrites from `go fix`, and compile accepted changes on the retained minimum.

If CI still publishes `GOOS=windows GOARCH=arm`, remove that unsupported 32-bit build from the 1.26 matrix or retain a separate supported-by-project toolchain for that artifact. An arm64 artifact requires compatible deployment hardware.

## Collector and profiles

Compare allocation rates and tail latency under the release architecture and quotas. Green Tea GC is on by default. Use `GOEXPERIMENT=nogreenteagc` for an isolated comparison if diagnosing a regression.

The `goroutineleak` profile in 1.26 requires `GOEXPERIMENT=goroutineleakprofile`. Verify profile collection and its consumer with the deployed build flags before the 1.27 step.

## TLS peers

Default groups add `SecP256r1MLKEM768` and `SecP384r1MLKEM1024`. Test deployed clients, servers, and proxies with their actual group settings.

Look for `tlsrsakex`, `tls10server`, `tls3des`, `tlsunsafeekm`, and `x509keypairleaf` overrides. Identify the deployed peers or code paths that require them before crossing 1.27.

[Release notes](https://go.dev/doc/go1.26)
