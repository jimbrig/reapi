# Package Utilities

Various functions providing mostly internal package-specific logic, but
are still exported for clarity.

All functions here will be prefixed with `pkg_*()` to provide a
consistent, semantic identity and grouping of the common
functionalities.

## Functions

### Package Metadata

- [`pkg_name()`](http://docs.jimbrig.com/reapi/reference/pkg_name.md):
  Get the package name.

- [`pkg_version()`](http://docs.jimbrig.com/reapi/reference/pkg_version.md):
  Get the package version.

- [`pkg_repo()`](http://docs.jimbrig.com/reapi/reference/pkg_repo.md):
  Get the package repository.

### User Agent

- [`pkg_user_agent()`](http://docs.jimbrig.com/reapi/reference/pkg_user_agent.md):
  Get the package user agent.

### System File

- [`pkg_sys()`](http://docs.jimbrig.com/reapi/reference/pkg_sys.md): Get
  the package system file.

### Startup Message

- `pkg_startup_msg()`: Get the package startup message.

### Banner

- `pkg_banner()`: Get the package banner.

## See also

Package Internals:
[`reapi-conditions`](http://docs.jimbrig.com/reapi/reference/reapi-conditions.md)

Utility Functions:
[`active_config`](http://docs.jimbrig.com/reapi/reference/active_config.md),
[`reapi_abort_check()`](http://docs.jimbrig.com/reapi/reference/reapi_abort_check.md)
