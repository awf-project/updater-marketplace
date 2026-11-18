# Upgrade from PHP 8.3 to 8.4

- Deployment installs IMAP, OCI8, PDO_OCI, or PSpell or consumes native handles. [Extensions and loaded modules](#extensions-and-loaded-modules)
- Declarations use Type $value = null. [Nullable signatures](#nullable-signatures)
- The app uses computed exit values or relies on implicit CSV or round behavior. [Exit values CSV and rounding](#exit-values-csv-and-rounding)

## Extensions and loaded modules

Move used extensions to target-compatible PECL builds in the relevant PHP images. Check `php --ri <extension>` for the CLI and exercise an extension-dependent feature on the actual worker or web runtime. Composer's platform emulation checks dependency resolution.

DBA and ODBC handles become objects. Replace `is_resource()` gates with checks for the actual failure sentinel documented by the API. For a successful `odbc_connect()` expect an `Odbc\Connection`, and for a successful `odbc_exec()` an `Odbc\Result`. Preserve the `false` error path. Test successful initialization and failure.

## Nullable signatures

Use explicit nullability, such as `?Type $value = null`. When a required parameter follows, preserve the existing required argument behavior with explicit nullability and no misleading default. Keep parameter names if callers use named arguments. Verify interface and override variance, and exercise positional, named, and null inputs where supported. [Implicitly nullable parameter deprecation](https://www.php.net/manual/en/migration84.deprecated.php)

## Exit values CSV and rounding

For `exit()` and `die()`, pass the intended integer status or string message explicitly. Assert both stdout and process status, especially if a numeric string passed through dynamic input.

Set the CSV escape argument explicitly at read and write boundaries. Preserve the dialect expected by existing consumers and test a quoted field and one containing the escape character. Invalid `round()` modes now throw `ValueError`. If the old fallback was part of the contract, map it explicitly to `PHP_ROUND_HALF_UP` and cover positive and negative ties.

[8.4 release](https://www.php.net/releases/8.4/en.php), [Incompatible changes](https://www.php.net/manual/en/migration84.incompatible.php), [Migration guide](https://www.php.net/manual/en/migration84.php)
