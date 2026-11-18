# Upgrade from TypeScript 6.0 to 7.0

- Transformers, linters, or custom tooling import typescript. [Compiler API compatibility](#compiler-api-compatibility)
- Build scripts pass source arguments or published types change. [CLI and declarations](#cli-and-declarations)
- allowJs, checkJs, JSDoc, or an editor preview is configured. [JavaScript and editor checks](#javascript-and-editor-checks)

## Compiler API compatibility

Locate who resolves the JavaScript API. Give API consumers `@typescript/typescript6` if they are not yet compatible. If an external tool requires the bare `typescript` specifier, use an alias there and install the native CLI under a second alias. For example, upstream pairs `"typescript": "npm:@typescript/typescript6@^6.0.2"` with `"@typescript/native": "npm:typescript@^7.0.2"`. Verify `tsc --version` and `tsc6 --version` from the workspace, then run the affected transform or lint command.

## CLI and declarations

Use `tsc -p` for the intended project and `--ignoreConfig` only for deliberately isolated files. Revisit removals identified on the [6.0 bridge](typescript-6.0.md#resolver-and-70-bridge). Compare JavaScript entry points, declarations, and downstream imports. Enable `--stableTypeOrdering` on 6.0 when isolating inference/order differences.

## JavaScript and editor checks

Check value names used as JSDoc types and use `typeof` where the type of a value was meant. For a JS enum object, replace legacy `@enum` typing with a typedef of `(typeof E)[keyof typeof E]` when callers require the union of its values. Move typedef names written after the comment into the `@typedef` tag. For JS packages, check both diagnostics and declaration output. Exercise workspace editor integration independently when replacing the native preview.

If target CI has performance issues, compare wall time and peak memory. Use `--singleThreaded` as a comparison when isolating parallel build behavior.

[Release announcement](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/)
