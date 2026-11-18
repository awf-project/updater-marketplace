---
name: php-upgrade
description: Plan or apply PHP, Symfony, API Platform, or Sylius upgrades for an existing application. Use for staged migrations, Composer compatibility checks, and release-specific verification.
---

# Upgrade a PHP application

Compare the in-scope PHP runtime, pins, `require.php`, and `config.platform.php`, or the requested framework's resolved packages in `composer.lock`, with the target. `config.platform.php` can differ from the runtime used by the web app, CLI, workers, and CI. [Composer platform configuration](https://getcomposer.org/doc/06-config.md#platform)

If the current project already satisfies the target across in-scope runtimes, packages, and pins, report a no-op and stop before loading migration references or running Composer updates. Run any explicitly requested checks. For “latest”, resolve the target from the corresponding upstream release list.

## Migration checks by target series

- PHP [8.3](references/php-8.3.md), [8.4](references/php-8.4.md), [8.5](references/php-8.5.md). [PHP downloads](https://www.php.net/downloads.php), [migration guides](https://www.php.net/manual/en/appendices.php), [patch history](https://www.php.net/ChangeLog-8.php)
- [Symfony migration checks](references/symfony/index.md), [upstream releases](https://symfony.com/releases)
- [API Platform migration checks](references/api-platform/index.md), [upstream releases](https://github.com/api-platform/core/releases)
- [Sylius migration checks](references/sylius/index.md), [upstream releases](https://github.com/Sylius/Sylius/releases)

For every PHP or framework series being crossed, read its official release notes and the upstream migration sections for the installed extensions, bundles, and overridden APIs. Include the exact patch entries between the locked and target versions. Prefer a correction in the target release notes over an earlier preview or rolling guide. Resolve coupled Composer constraints in one checkpoint when packages must move together. Use intermediate versions for compatibility checks and maintained versions for deployment.

## Apply and verify

- In a plan, tie each action to a project file, pin, or affected runtime behavior and cite the release entry that calls for it. When implementing, change the in-scope pins and affected usages and keep unrelated Composer updates out of the lockfile.
- Use `composer prohibits <package> <target-version> --locked` to trace blockers in a locked graph. Use `php` as the package for a runtime upgrade. Confirm upstream support for native extensions and framework integrations whose compatibility constraints are broader than their support.
- For implementation, update the required runtime pins, constraints, lockfile, and affected code. Run Composer with the target PHP binary. Use `composer check-platform-reqs --lock` to assess a lockfile and `composer check-platform-reqs` after installation. Exercise changed paths in the application runtime when it differs from the CLI.
