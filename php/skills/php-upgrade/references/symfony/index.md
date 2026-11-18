# Symfony upgrades

Resolve the target Symfony components against the PHP runtime, third-party bundle constraints, and Flex's `extra.symfony.require` when present. [Symfony releases](https://symfony.com/releases)

## Release guides

| Starting series | Target series | Guide |
| --- | --- | --- |
| 6.4 | 7.0 | [Symfony 7.0](7.0.md) |
| 7.0 | 7.1 | [Symfony 7.1](7.1.md) |
| 7.1 | 7.2 | [Symfony 7.2](7.2.md) |
| 7.2 | 7.3 | [Symfony 7.3](7.3.md) |
| 7.3 | 7.4 | [Symfony 7.4](7.4.md) |
| 7.4 | 8.0 | [Symfony 8.0](8.0.md) |
| 8.0 | 8.1 | [Symfony 8.1](8.1.md) |
| 8.1 | 8.2 (prerelease) | [Symfony 8.2.0-BETA2](8.2.md) |

Use the preceding major's last minor to surface deprecations before crossing a major. Read the release announcement and the component sections of `UPGRADE-<series>.md` at the target tag for every crossed minor. A deprecation introduced in 7.x can often be addressed before its removal in 8.0. For patch-only changes, use the relevant entries in the release history. [Symfony releases](https://github.com/symfony/symfony/releases), [Major upgrade process](https://symfony.com/doc/current/setup/upgrade_major.html)

## Component and integration checks

- If interdependent components are blocked, trace the exact target with `composer prohibits` on the affected components and resolve them together. Align the Flex constraint with explicit package constraints.
- For Flex recipe changes, compare `symfony.lock` and inspect `composer recipes:update` diffs separately from package changes. Merge custom routing, services, and environment settings. [Symfony Flex recipes](https://symfony.com/doc/current/setup/upgrade_minor.html)
- Use the configured PHPUnit Bridge or actual HTTP, worker, and console paths to surface deprecations. If config or recipes changed, compare routing and compile and warm the container in affected environments. [Symfony PHPUnit Bridge](https://symfony.com/doc/current/components/phpunit_bridge.html)
