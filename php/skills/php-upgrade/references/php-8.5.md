# Upgrade from PHP 8.4 to 8.5

- Images dynamically load OPcache or use Intl or ODBC. [OPcache and extension builds](#opcache-and-extension-builds)
- Enums or uncomparable objects are compared to booleans or null is used as an offset. [Comparisons and array keys](#comparisons-and-array-keys)
- Legacy casts, cURL cleanup, or old serialization hooks are present. [Deprecations with persisted data](#deprecations-with-persisted-data)

## OPcache and extension builds

Remove `--enable-opcache` or `--disable-opcache` from PHP builds and `zend_extension=opcache.so` or `php_opcache.dll` loading directives. 8.5 builds OPcache into the binary. Keep `opcache.enable` and `opcache.enable_cli` where they select the desired runtime behavior. Check effective enablement per SAPI, including worker and CLI if those differed. Verify ICU 57.1+ and ODBC 3.5 where applicable. If `Collator::SORT_REGULAR` affects menus or reports, compare numeric strings and ordinary strings in one ordered fixture.

## Comparisons and array keys

Determine whether the code intended identity, failure detection, or truthiness before changing the comparison. Exercise both boolean values. For null keys, branch where null means absence or use an explicit empty key when that is the existing storage contract. Check stored shape as well as the warning.

## Deprecations with persisted data

Use canonical cast names and validate `str_increment()` inputs for nonnumeric sequences. Where cURL cleanup used `curl_close()` or `curl_share_close()`, release references at the actual lifetime boundary, including retained references in wrappers.

If replacing `__sleep()` or `__wakeup()`, read an existing payload with the new class and check its public state. Verify newly written payloads with any old application instances that must read them during rollout. [PHP 8.5 deprecations](https://www.php.net/manual/en/migration85.deprecated.php)

[8.5 release](https://www.php.net/releases/8.5/en.php), [Incompatible changes](https://www.php.net/manual/en/migration85.incompatible.php), [Migration guide](https://www.php.net/manual/en/migration85.php)
