# Check Conditions

These functions are specialized versions of the `reapi` condition
functions that are intended for use in the package's internal checking
functions. They create conditions with specific classes that can be used
to identify and handle errors, warnings, and messages.

## Usage

``` r
reapi_abort_check(
  msg,
  ...,
  parent = NULL,
  call = rlang::caller_env(),
  .envir = parent.frame()
)

reapi_warn_check(msg, ..., call = rlang::caller_env(), .envir = parent.frame())

reapi_inform_check(
  msg,
  ...,
  call = rlang::caller_env(),
  .envir = parent.frame()
)

check_abort(
  msg,
  ...,
  parent = NULL,
  call = rlang::caller_env(),
  .envir = parent.frame()
)

check_warn(msg, ..., call = rlang::caller_env(), .envir = parent.frame())

check_inform(msg, ..., call = rlang::caller_env(), .envir = parent.frame())
```

## Arguments

- msg:

  Character string or vector containing the message to be displayed.
  This gets passed to
  [`cli::cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.html)
  allowing for `cli`'s custom formatting, `glue` interpolation, inline
  markup syntax, and other features.

- ...:

  Passed to
  [`rlang::abort()`](https://rlang.r-lib.org/reference/abort.html),
  [`rlang::warn()`](https://rlang.r-lib.org/reference/abort.html) or
  [`rlang::inform()`](https://rlang.r-lib.org/reference/abort.html).

- call:

  The execution environment of a currently running function, e.g.
  `call = caller_env()`. The corresponding function call is retrieved
  and mentioned in error messages as the source of the error.

  You only need to supply `call` when throwing a condition from a helper
  function which wouldn't be relevant to mention in the message.

  Can also be `NULL` or a [defused function
  call](https://rlang.r-lib.org/reference/topic-defuse.html) to
  respectively not display any call or hard-code a code to display.

  For more information about error calls, see [Including function calls
  in error
  messages](https://rlang.r-lib.org/reference/topic-error-call.html).

- .envir:

  Environment to evaluate the glue expressions in.

## Value

These functions do not return values, but are used for their side
effects, namely creating and signaling conditions. The
[`reapi_abort()`](http://docs.jimbrig.com/reapi/reference/reapi-conditions.md)
function will stop execution, while
[`reapi_warn()`](http://docs.jimbrig.com/reapi/reference/reapi-conditions.md)
&
[`reapi_inform()`](http://docs.jimbrig.com/reapi/reference/reapi-conditions.md)
will allow execution to proceed.

## Details

The condition class hierarchy is structured like so:

where `<reapi_condition>` is the base class for all `reapi` conditions
and sits on top of the existing `rlang` and base R condition classes.

For example, a `reapi` error thrown without any additional custom class
added to it using
[`reapi_abort()`](http://docs.jimbrig.com/reapi/reference/reapi-conditions.md)
will have the following classes:

    [1] "reapi_error" "reapi_condition" "rlang_error" "error" "condition"

This allows for filtering and handling of reapi-specific conditions
while still being compatible with the broader R condition system.

## Functions

- `reapi_abort_check()`: creates an `reapi_error` condition for checks.

- `reapi_warn_check()`: creates an `reapi_warning` condition for checks.

- `reapi_inform_check()`: creates an `reapi_message` condition for
  checks.

## Aliases

- `check_abort()`: alias for `reapi_abort_check()`

- `check_warn()`: alias for `reapi_warn_check()`

- `check_inform()`: alias for `reapi_inform_check()`

## See also

Utility Functions:
[`active_config`](http://docs.jimbrig.com/reapi/reference/active_config.md),
[`utils_pkg`](http://docs.jimbrig.com/reapi/reference/utils_pkg.md)

Conditions:
[`reapi-conditions`](http://docs.jimbrig.com/reapi/reference/reapi-conditions.md)

## Examples

``` r
if (FALSE) { # \dontrun{
reapi_abort("This is a reapi error.")

# catch a condition and check its classes
err <- rlang::catch_cnd(reapi_abort("Error Message"))
class(err)

# catch a warning and check its classes
wrn <- rlang::catch_cnd(reapi_warn("Warning Message"))
class(wrn)

# catch a message and check its classes
msg <- rlang::catch_cnd(reapi_inform("Message"))
class(msg)
} # }
```
