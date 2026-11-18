---
name: js-ts-upgrade
description: Plan or apply a JavaScript runtime or TypeScript compiler upgrade for an existing application. Use for Node.js releases, TypeScript releases, or changes to the JavaScript compatibility target.
---

# Upgrade a JavaScript or TypeScript application

Identify the requested runtime, workspace compiler, emit target, or package manager. Compare its resolved version or effective config with the corresponding project, CI, and deployment pins. For TypeScript use the workspace binary and `tsc --showConfig` for the affected project. For browsers or other runtimes use their compatibility data and the app's output and polyfill targets.

If the current project already satisfies the request across in-scope versions, pins, and settings, report a no-op and stop before loading migration references or installing dependencies. Run any explicitly requested checks. Resolve “latest” or “latest LTS” from the corresponding upstream release list.

## Migration checks by target series

- Node.js [23](references/node-23.md), [24](references/node-24.md), [25](references/node-25.md), [26](references/node-26.md). [Node.js release history](https://nodejs.org/en/about/previous-releases)
- TypeScript [5.9](references/typescript-5.9.md), [6.0](references/typescript-6.0.md), [7.0](references/typescript-7.0.md). [TypeScript releases](https://github.com/microsoft/TypeScript/releases)

Review crossed releases in order, including Node majors between LTS releases. Use unsupported Node majors only as isolated checkpoints when needed. Read the official release notes for each crossed Node major or TypeScript version and the changelog entries for the selected patches. Match runtime changes to the actual launch command and compiler changes to the workspace config. When runtime and compiler both move, account for tools that use the compiler API.

## Apply and verify

- In a plan, tie each action to a project file, pin, or affected runtime behavior and cite the release entry that calls for it. When implementing, update the in-scope pins and constraints, limit code edits to affected usages, and verify a frozen or immutable install if runtime or dependencies changed.
- On Node changes, load affected module entry points and native addons in the deployed environment. On compiler changes, verify relevant type checks, JavaScript and declaration emit, and downstream imports. On browser target changes, test the oldest supported browser with the required polyfills.
