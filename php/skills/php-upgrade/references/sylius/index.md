# Sylius upgrades

Resolve the target Sylius packages against the installed plugins or Plus modules and PHP, Symfony, Doctrine, and API Platform constraints. Compare the corresponding Sylius Standard tag where the application inherits its config or asset setup. [Sylius releases](https://github.com/Sylius/Sylius/releases), [Sylius Standard releases](https://github.com/Sylius/Sylius-Standard/releases)

## Release guides

| Starting series | Target series | Guide |
| --- | --- | --- |
| 1.13 | 1.14 | [Sylius 1.14](1.14.md) |
| 1.14 | 2.0 | [Sylius 2.0](2.0.md) |
| 2.0 | 2.1 | [Sylius 2.1](2.1.md) |
| 2.1 | 2.2 | [Sylius 2.2](2.2.md) |
| 2.2 | 2.3 | [Sylius 2.3](2.3.md) |

Open the release and its `UPGRADE` file at the target tag. Read the separate patch entry for fixes affecting checkout or persisted orders. For example, the payment retry change is in 2.2.7. Work through older 1.x upgrade guides to reach the 1.14 bridge. [Sylius source and upgrade files](https://github.com/Sylius/Sylius)

## Application checks

- Match changes to actual overrides in resource or model mappings, workflows, Twig hooks, routes, and plugin extension points. For a changed template or asset setup, rebuild assets and exercise the affected view.
- If schema migrations are involved, rehearse them on a representative test database and verify that affected catalog, order, or payment data still loads. Check app compatibility across the deployment and rollback sequence.
- If checkout, payment, or shipment behavior changes, exercise the affected channels and active workflow adapter with test integrations. Compare resulting states and side effects for success and failure.
