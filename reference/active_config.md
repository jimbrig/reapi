# Manage Active Configuration

Functions for quickly accessing or setting the active configuration file
and environment for `config::get()`.

Get:

- `get_active_config_env()`: Returns the active configuration run-time
  environment (`REAPI_CONFIG_ACTIVE`, `R_CONFIG_ACTIVE`).

- `get_active_config_file()`: Returns the active configuration file
  (`REAPI_CONFIG_FILE`, `R_CONFIG_FILE`).

Set:

- `set_active_config_env(env)`: Sets the active configuration
  environment

- `set_active_config_file(file)`: Sets the active configuration file

## Usage

``` r
get_active_config_env(
  default = c("default", "development", "production", "testing")
)

set_active_config_env(env)

get_active_config_file(default = pkg_sys_config("config.yml"))

set_active_config_file(file)
```

## Arguments

- default:

  Default environment to return if no active environment is set.
  Defaults to "default". Possible values are "default", "development",
  "production", "testing".

- env:

  The configuration environment to set as active.

- file:

  The configuration file path to set as active.

## Value

- `get_active_config_env()`: The active configuration environment as a
  string.

- `get_active_config_file()`: The active configuration file as a string.

- `set_active_config_env(env)`: Returns the previous active
  configuration environment.

- `set_active_config_file(file)`: Returns the previous active
  configuration file.

## See also

`config::get()`

Utility Functions:
[`reapi_abort_check()`](http://docs.jimbrig.com/reapi/reference/reapi_abort_check.md),
[`utils_pkg`](http://docs.jimbrig.com/reapi/reference/utils_pkg.md)
