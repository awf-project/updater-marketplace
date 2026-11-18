# Upgrade from TypeScript 5.9 to 6.0

- A tsconfig inherits options or omits strict, module, or target. [Effective compiler defaults](#effective-compiler-defaults)
- The project relies on inferred types or rootDir. [Ambient types and emit paths](#ambient-types-and-emit-paths)
- Aliases, old emit targets, or deprecated compiler options are in use. [Resolver and 7.0 bridge](#resolver-and-70-bridge)

## Effective compiler defaults

Capture `tsc -p <config> --showConfig` for each affected build and test config to inspect explicit and inherited options. Implicit defaults may be absent from that output. For omitted options, account for `strict: true`, `module: "esnext"`, and `target: "es2025"`. Pin values needed by the existing runtime or package contract. Verify diagnostics, emitted JavaScript, and a real consumer of it.

With `noUncheckedSideEffectImports` enabled, fix unresolved imports or declare the actual assets that a bundler provides. Verify that the bundle loads those assets.

## Ambient types and emit paths

TypeScript now defaults `types` to an empty list. Add each ambient package to the config that needs it, such as Node in the app config or the test framework in the test config. Regular imports still resolve their own type dependencies.

When an inferred source root changes, compare emit with the actual package entry points. For a change from `dist/index.js` to `dist/src/index.js`, check whether an explicit `rootDir: "src"` restores the layout. Check declarations and project references as well as JS.

## Resolver and 7.0 bridge

Move from `node` / `node10` or `classic` to the resolver used by the actual runtime or bundler. When removing `baseUrl`, make `paths` targets relative to the defining config and check imports formerly resolved from the base directory. Align aliases in build, runtime, and tests.

Before 7.0, remove `ignoreDeprecations: "6.0"` and resolve findings on 6.0. For ES5 consumers, move downlevel emit to a compiler that still targets ES5 before removing `downlevelIteration`. Replace namespace declarations written as `module Foo {}` with `namespace Foo {}`. Change `assert { type: "json" }` imports to `with { type: "json" }` if the executing runtime supports import attributes. For AMD/UMD/System output or `outFile`, keep the published entry point working through the project’s bundler. Replace file arguments with project mode or use `--ignoreConfig` where deliberate.

[Release notes](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-6-0.html)
