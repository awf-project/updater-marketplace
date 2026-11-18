# Upgrade from PHP 8.2 to 8.3

- The app calls range or number_format with computed inputs. [Core input behavior](#core-input-behavior)
- The app supplies file flags, subclasses DOM, or manages child processes. [Files extensions and child processes](#files-extensions-and-child-processes)
- The code calls get_class or get_parent_class without arguments or increments strings. [Deprecations and string sequences](#deprecations-and-string-sequences)

## Core input behavior

For `range()`, classify call sites as numeric sequences or character sequences. For an increasing numeric sequence, reject or correct a negative step before calling `range()` because 8.3 throws `ValueError`. Exercise mixed bounds and empty strings at call sites accepting user input.

For arrays indexed with negative keys, `$a = [-5 => 1]; $a[] = 2;` now appends at `-4`. If persisted data or a consumer requires the former key `0`, set it explicitly.

Negative precision in `number_format()` now rounds digits before the decimal point. Pass zero where the old zero-precision behavior is required. Check the formatted result for a value that would round differently.

## Files extensions and child processes

Remove invalid flags such as `FILE_APPEND` from `file()` and test empty lines and line endings with the retained flags. Load custom DOM subclasses on the target to catch inherited name or signature conflicts. For `proc_get_status()` before `proc_close()`, test a subprocess that exits with a known nonzero status through the actual wrapper.

## Deprecations and string sequences

Make the intended class or object explicit. Test inherited behavior when choosing between the declaring class and late-static binding. Separate numeric arithmetic from alphanumeric identifiers. Use `str_increment()` when the floor allows it and cover rollover and invalid inputs.

[8.3 release](https://www.php.net/releases/8.3/en.php), [Incompatible changes](https://www.php.net/manual/en/migration83.incompatible.php), [Migration guide](https://www.php.net/manual/en/migration83.php)
