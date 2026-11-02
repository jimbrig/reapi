# Check Not Empty

Checks the provided `x` is not "empty" via
[`rlang::is_empty()`](https://rlang.r-lib.org/reference/is_empty.html).

## Usage

``` r
check_not_empty(x, arg = rlang::caller_arg(x), call = rlang::caller_env())
```

## Arguments

- x:

  The object to check.

- arg:

  An argument name as a string. This argument will be mentioned in error
  messages as the input that is at the origin of a problem.

- call:

  The execution environment of a currently running function, e.g.
  `caller_env()`. The function will be mentioned in error messages as
  the source of the error. See the `call` argument of
  [`abort()`](https://rlang.r-lib.org/reference/abort.html) for more
  information.

## Value

If checks pass, invisibly returns the provided `x` object. If checks
fail, a condition error is thrown.
