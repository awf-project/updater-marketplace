# Upgrade from TypeScript 5.8 to 5.9

- BufferSource errors mention Buffer or ArrayBufferLike. [Binary boundaries](#binary-boundaries)
- A scaffolding command invokes `tsc --init`. [Generated configs](#generated-configs)
- A compiler diagnostic or declaration diff points to generic inference. [Inferred public types](#inferred-public-types)

## Binary boundaries

For a `Buffer` diagnostic, first try a compatible updated `@types/node` for the supported Node major. Where a function consumes bytes rather than a backing store, change its contract from `ArrayBuffer` to the appropriate typed-array view. Use `Uint8Array<ArrayBuffer>` only when the view's provenance establishes its backing type. If an independent buffer is needed, `new Uint8Array(view)` copies the visible bytes of a byte view. Test an input with nonzero `byteOffset` to catch copying the entire backing store.

## Generated configs

Projects generating new configs with `tsc --init` get a different template that includes `types: []`. If a scaffolded Node project loses `process` or `Buffer`, include `node` in its template’s `types` and compile a newly generated project. Existing configs are unaffected by `--init`.

## Inferred public types

Compare the old and target declaration output on the same inputs. Add a specific annotation or type argument where it expresses the existing contract. Compile a downstream use to verify that public argument and result types stayed compatible.

[Release notes](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-5-9.html)
