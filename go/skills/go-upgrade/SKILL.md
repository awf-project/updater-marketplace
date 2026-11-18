---
name: go-upgrade
description: Plan or apply a Go toolchain upgrade for an existing application or module. Use for moving between Go releases, updating module and workspace requirements, and verifying each migration step.
---

# Upgrade a Go application

Check the active `go.mod` or `go.work`, CI/builder pins, and `GOTOOLCHAIN` against the requested toolchain or minimum. Use `GOTOOLCHAIN=local go version` to identify the bundled toolchain without triggering a download. Derive the effective version from toolchain selection. The `go` directive sets a minimum and can select compatibility defaults. The `toolchain` directive suggests a toolchain. [Go toolchains](https://go.dev/doc/toolchain)

If the current project already satisfies the requested target across in-scope pins and environments, report a no-op and stop before loading migration references or running build checks. Honor exact patch pins and any verification the user explicitly requests. Resolve “latest” from [Go release history](https://go.dev/doc/devel/release).

## Migration checks by target series

- [Go 1.25](references/go-1.25.md), [Go 1.26](references/go-1.26.md), [Go 1.27](references/go-1.27.md)
- Read the official Go notes for every crossed series in order, then match changes to the module directive, build flags, deployed targets, and APIs in use. Read the release history entries for the selected patch range. [Go release history](https://go.dev/doc/devel/release)

## Apply and verify

- In a plan, tie each action to a project file, pin, or affected runtime behavior and cite the release entry that calls for it. If the upgrade requires no application code edits, change only the in-scope pins and verify on the target.
- Test runtime defaults with the app's actual `go` directive and `GODEBUG` settings. Raise the module floor with `go get go@<version>` when the support policy or required code calls for it. Inspect module, checksum, workspace, and vendor changes from that operation. [Go compatibility settings](https://go.dev/doc/godebug), [Managing Go version requirements](https://go.dev/doc/toolchain#managing-go-version-module-requirements-with-go-get)
- Test affected modules with the selected toolchain and at any retained minimum. Include standalone module builds and release combinations such as cgo and race builds where supported.
