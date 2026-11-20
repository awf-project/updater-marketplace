# Upgrade from PHP 8.5 to 8.6

- The web app uses PHP session cookies or a custom save handler. [Sessions](#sessions)
- PostgreSQL connections persist across requests. [Persistent PDO_PGSQL connections](#persistent-pdo_pgsql-connections)
- Input parsers use `trim()`, dynamic flags, or magic property access. [Changed input and property behavior](#changed-input-and-property-behavior)
- Code returns from `finally`, builds queries from objects, or uses mbregex. [Deprecations](#deprecations)
- The deployment ships a compiled Fileinfo database or official Windows binaries. [Deployment checks](#deployment-checks)

## Sessions

`session.use_strict_mode` and `session.cookie_httponly` now default to `1`, and `session.cookie_samesite` defaults to `Lax`. Inspect the actual login response because framework settings can override these defaults. For a cross-site POST callback that needs the existing session, exercise the return trip in a browser. If the cookie must travel with that POST, configure `SameSite=None` with `Secure` over HTTPS. [Session changes](https://www.php.net/manual/en/migration86.incompatible.php)

Custom handlers passed to `session_set_save_handler()` need `create_sid()` and `validateId()` to avoid deprecation. Verify that an existing session resumes and an unknown ID receives a fresh ID. With `session.lazy_write` enabled, a timestamp-aware handler now receives `updateTimestamp()` when a session was read empty and stays empty. Test the store's expiry or deletion behavior if it previously depended on `write()`. For callers of `session_encode()`, use `=== false` to detect failure because an empty session encodes to `''`. [Handler deprecations](https://www.php.net/manual/en/migration86.deprecated.php), [8.6.0 upgrade notes](https://github.com/php/php-src/blob/php-8.6.0/UPGRADING)

## Persistent PDO_PGSQL connections

`PDO::ATTR_PERSISTENT` with PostgreSQL now clears session settings and temporary tables when the last PDO handle using the connection is destroyed. SQL statements created with `PREPARE` survive cleanup. Initialize any required `search_path` when acquiring the connection. Exercise two successive acquisitions in the same worker, release all handles between them, and verify both the effective schema and any named prepared statements the app reuses. [PDO_PGSQL changes](https://www.php.net/manual/en/migration86.incompatible.php)

## Changed input and property behavior

- `trim()`, `ltrim()`, and `rtrim()` now strip form feed by default. If a file format uses it as a page boundary, test a record beginning or ending in `\f` and pass the format's explicit character list.
- `array_filter()`, `array_change_key_case()`, `pathinfo()`, and `scandir()` throw `ValueError` for unsupported modes or flags. Check values supplied by configuration or callers. Filesystem predicates such as `file_exists()` also throw on embedded NUL bytes. Exercise the application's invalid-input path.
- A proxy whose `__isset()` creates the requested property now supplies that stored value directly to `??`, `empty()`, and nested checks such as `isset($proxy->item['key'])`. Test the first access on a fresh proxy if `__get()` also performed normalization or bookkeeping. [Incompatible changes](https://www.php.net/manual/en/migration86.incompatible.php)

## Deprecations

- A `return` in `finally` emits a compile-time deprecation. Keep cleanup in `finally` and express the intended return or recovery in `try` or `catch`. Test both a successful return and a thrown exception because the old return could override either.
- `http_build_query()` deprecates treating objects as arrays, including nested objects. Build the intended query data explicitly and compare the encoded query against an existing fixture, especially for signed URLs. For by-reference `array_walk()` callbacks on objects, preserve any intended property updates when switching to an array.
- `mb_ereg*()` and `mb_split()` are deprecated. When porting UTF-8 patterns to PCRE, compare captures and replacements on multibyte input. For `preg_grep()` with the `u` modifier, distinguish an execution failure on malformed UTF-8 (`false`) from a successful match with no results (`[]`). [Deprecated features](https://www.php.net/manual/en/migration86.deprecated.php), [PCRE changes](https://www.php.net/manual/en/migration86.incompatible.php)

## Deployment checks

Custom compiled Fileinfo magic databases need rebuilding for the bundled file 5.48. Test MIME detection with the deployed database and a representative upload. [Extension changes](https://www.php.net/manual/en/migration86.other-changes.php)

Official Windows builds use VS18 and ship OpenSSL 4. Check native extension DLLs with the target binary. If the app reads `DOMDocument::$documentURI` after loading a local XML file, test with a Windows filesystem path as returned by the bundled libxml2 2.15.3. [Windows support](https://www.php.net/manual/en/migration86.windows-support.php)

[8.6 release](https://www.php.net/releases/8.6/en.php), [Migration guide](https://www.php.net/manual/en/migration86.php), [Patch history from 8.6.0](https://www.php.net/ChangeLog-8.php#8.6.0)
