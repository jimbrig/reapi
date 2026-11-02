# `reapi` Custom Conditions

Functions for creating and handling custom reapi-specific conditions,
including errors, warnings, and messages.

- `reapi_abort()`: creates a condition representing an error and when
  thrown, aborts execution.

- `reapi_warn()`: creates a condition representing a warning condition

- `reapi_inform()`: creates a condition representing a message condition

These functions wrap
[`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html),
[`cli::cli_warn()`](https://cli.r-lib.org/reference/cli_abort.html), and
[`cli::cli_inform()`](https://cli.r-lib.org/reference/cli_abort.html)
respectively, adding `reapi`-specific context and class names
(`reapi_*`) to the condition objects for downstream handling and
identification.

## Usage

``` r
reapi_abort(
  msg = NULL,
  cls = NULL,
  ...,
  parent = NULL,
  call = rlang::caller_env(),
  .envir = parent.frame()
)

reapi_warn(msg = NULL, cls = NULL, ..., .envir = parent.frame())

reapi_inform(msg = NULL, cls = NULL, ..., .envir = parent.frame())
```

## Arguments

- msg:

  Character string or vector containing the message to be displayed.
  This gets passed to
  [`cli::cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.html)
  allowing for `cli`'s custom formatting, `glue` interpolation, inline
  markup syntax, and other features.

- cls:

  Optional character vector of additional classes to assign to the
  condition.

- ...:

  Passed to
  [`rlang::abort()`](https://rlang.r-lib.org/reference/abort.html),
  [`rlang::warn()`](https://rlang.r-lib.org/reference/abort.html) or
  [`rlang::inform()`](https://rlang.r-lib.org/reference/abort.html).

- parent:

  Supply `parent` when you rethrow an error from a condition handler
  (e.g. with
  [`try_fetch()`](https://rlang.r-lib.org/reference/try_fetch.html)).

  - If `parent` is a condition object, a *chained error* is created,
    which is useful when you want to enhance an error with more details,
    while still retaining the original information.

  - If `parent` is `NA`, it indicates an unchained rethrow, which is
    useful when you want to take ownership over an error and rethrow it
    with a custom message that better fits the surrounding context.

    Technically, supplying `NA` lets `abort()` know it is called from a
    condition handler. This helps it create simpler backtraces where the
    condition handling context is hidden by default.

  For more information about error calls, see [Including contextual
  information with error
  chains](https://rlang.r-lib.org/reference/topic-error-chaining.html).

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
effects, namely creating and signaling conditions. The `reapi_abort()`
function will stop execution, while `reapi_warn()` & `reapi_inform()`
will allow execution to proceed.

## Details

The condition class hierarchy is structured like so:

where `<reapi_condition>` is the base class for all `reapi` conditions
and sits on top of the existing `rlang` and base R condition classes.

For example, a `reapi` error thrown without any additional custom class
added to it using `reapi_abort()` will have the following classes:

    [1] "reapi_error" "reapi_condition" "rlang_error" "error" "condition"

This allows for filtering and handling of reapi-specific conditions
while still being compatible with the broader R condition system.

## See also

Conditions:
[`reapi_abort_check()`](http://docs.jimbrig.com/reapi/reference/reapi_abort_check.md)

Package Internals:
[`utils_pkg`](http://docs.jimbrig.com/reapi/reference/utils_pkg.md)

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
