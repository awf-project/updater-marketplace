# Updater Marketplace

Plugins for Claude Code and Codex that guide application upgrades through successive programming language releases.

| Plugin | Skill | Migration checks |
| --- | --- | --- |
| `php` | [PHP Upgrades](php/skills/php-upgrade/SKILL.md) | PHP 8.2 → 8.5, [Symfony](php/skills/php-upgrade/references/symfony/index.md), [API Platform](php/skills/php-upgrade/references/api-platform/index.md), [Sylius](php/skills/php-upgrade/references/sylius/index.md) |
| `go` | [Go Upgrades](go/skills/go-upgrade/SKILL.md) | 1.24 → 1.25 → 1.26 → 1.27 |
| `zig` | [Zig Upgrades](zig/skills/zig-upgrade/SKILL.md) | 0.13 → 0.14 → 0.15 → 0.16 → 0.17 |
| `rust` | [Rust Upgrades](rust/skills/rust-upgrade/SKILL.md) | 1.97 → 1.98 → 1.99 → 1.100 and edition 2021 → 2024 |
| `js-ts` | [JavaScript and TypeScript Upgrades](js-ts/skills/js-ts-upgrade/SKILL.md) | Node.js 22 → 23 → 24 → 25 → 26 and TypeScript 5.8 → 5.9 → 6.0 → 7.0 |

## Install from GitHub

Add the `awf-project/updater-marketplace` GitHub repository as a marketplace, then install a plugin. Replace `php` with the plugin name from the table to install another language.

**Claude Code**

```sh
claude plugin marketplace add awf-project/updater-marketplace
claude plugin install php@updater-marketplace
```

**Codex**

```sh
codex plugin marketplace add awf-project/updater-marketplace
codex plugin add php@updater-marketplace
```

Start a new session in the application repository and ask, for example, “Plan this application's PHP upgrade from 8.2 to 8.5 and list the checks for each step.”

The skill checks the project's effective version and pins first. If the target is already satisfied, it reports a no-op before loading migration references. For each release crossed, the agent reads the official release notes and matches them to the project’s code, configuration, or deployment pins. Plans include only applicable changes and the checks that demonstrate them. Patch-only upgrades use the upstream entries between the installed and target patches.

## Add a language or release

Register each language plugin in `.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json`, using the same root-level directory in both. Add `<language>/.codex-plugin/plugin.json` and keep its plugin version in sync with the Claude catalog entry.

Keep one main skill per plugin at `<plugin>/skills/<plugin>-upgrade/SKILL.md`. Link each reference from the skill or the component's release index. A short checklist works for a narrow release. If a release has several migration paths, give each its own section and put applicability links at the top.

Read the official stable release entry before writing or revising each guide. Link it from the guide and identify patch-specific behavior by version. Lead each check with the API, setting, or runtime behavior that makes it apply. Include migration order, compatibility options, examples, or regression cases when they affect what the project should do. Link to upstream migration and release notes for exact patches and the full history.
