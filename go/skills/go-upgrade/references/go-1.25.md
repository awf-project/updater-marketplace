# Upgrade from Go 1.24 to 1.25

- The service runs with CPU quotas or sets GOMAXPROCS. [CPU limits in containers](#cpu-limits-in-containers)
- CI relies on package discovery, explicit toolchain pins, or debug symbols. [Module layout and build artifacts](#module-layout-and-build-artifacts)
- The app recovers panics or starts workers with WaitGroup. [Panics and workers](#panics-and-workers)
- CI already sets GOEXPERIMENT=jsonv2. [Experimental JSON](#experimental-json)

## CPU limits in containers

Compare source and target with the same cgroup quota and CPU affinity. Record `runtime.GOMAXPROCS(0)`, throughput, and throttling at startup and after a quota change. Kubernetes CPU requests alone do not set the quota. An explicit environment value or positive `runtime.GOMAXPROCS` call overrides automatic tuning.

Check compatibility defaults when retaining an older module floor. Use `go list -f '{{.DefaultGODEBUG}}' ./cmd/server` on the actual main package and inspect explicit `containermaxprocs` or `updatemaxprocs` overrides in deployment.

## Module layout and build artifacts

A `go.mod` `ignore` directive removes directories from package discovery while they can still ship in module archives. Compare `go list ./...` to the expected test inventory. Recheck explicit `toolchain` pins after raising the `go` line because the tool no longer adds a directive automatically.

The compiler defaults to DWARF 5 on supported platforms. Use a target artifact to test any older debugger, crash symbolizer, or other consumer. Consider `GOEXPERIMENT=nodwarf5` as a bridge only if the reader cannot move yet.

## Panics and workers

If a function uses `f.Name()` after `f, err := os.Open(path)` but before checking `err`, handle the error first. On 1.25 a missing file can now panic at the earlier dereference. Exercise recover and re-panic when monitoring parses the message. For vet findings on `WaitGroup.Add`, increment before spawning, or use `WaitGroup.Go` when the floor permits it and the worker cannot panic. Test shutdown with a worker that exits on cancellation.

Tests using the 1.24 `GOEXPERIMENT=synctest` API must move before 1.26. Replace `synctest.Run` with `synctest.Test(t, func(t *testing.T) { ... })`, remove the old experiment flag, and call `synctest.Wait()` before inspecting work that must be blocked.

## Experimental JSON

For a build already opting into `GOEXPERIMENT=jsonv2`, run the same wire fixtures with and without the flag on 1.25 to isolate encoder differences. Include custom marshalers, nil and empty containers, and inputs produced by existing clients.

[Release notes](https://go.dev/doc/go1.25)
