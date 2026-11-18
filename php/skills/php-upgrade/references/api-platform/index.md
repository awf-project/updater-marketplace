# API Platform upgrades

Resolve the installed `api-platform/core` or split packages and their integration bridges from `composer.lock`. In a Sylius application, use the intended `sylius/api-bundle` or `sylius/sylius` constraint when selecting the API Platform target.

## Release guides

| Starting series | Target series | Guide |
| --- | --- | --- |
| 2.7 | 3.0 | [API Platform 3.0](3.0.md) |
| 3.0 | 3.1 | [API Platform 3.1](3.1.md) |
| 3.1 | 3.2 | [API Platform 3.2](3.2.md) |
| 3.2 | 3.3 | [API Platform 3.3](3.3.md) |
| 3.3 | 3.4 | [API Platform 3.4](3.4.md) |
| 3.4 | 4.0 | [API Platform 4.0](4.0.md) |
| 4.0 | 4.1 | [API Platform 4.1](4.1.md) |
| 4.1 | 4.2 | [API Platform 4.2](4.2.md) |
| 4.2 | 4.3 | [API Platform 4.3](4.3.md) |
| 4.3 | 4.4 | [API Platform 4.4](4.4.md) |
| 4.4 | 5.0 | [API Platform 5.0](5.0.md) |

Read the stable changelog entry for each crossed series and the entries up to the locked target patch. Where the rolling upgrade guide and the tagged release disagree, use the tagged behavior. For example, compare the 4.4.0 denormalization note with the later 5.0.4 validator fix. [API Platform upgrade guide](https://api-platform.com/docs/core/upgrade-guide/), [API Platform releases](https://github.com/api-platform/core/releases)

## API contract checks

- Snapshot affected routes and OpenAPI or GraphQL output before editing metadata. If clients depend on relation IRIs, filter semantics, pagination, or error shapes, include sample responses for those contracts.
- Where integration interfaces or service wiring change, test the real endpoint through custom metadata, provider, processor, listener, or schema decorator code. Cover invalid inputs and authorization failures on affected operations as well as success.
