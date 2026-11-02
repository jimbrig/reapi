# Check String (Scalar)

Checks the provided `x` is a scalar string via
[`rlang::check_string()`](https://rlang.r-lib.org/reference/check_type_scalar.html).

## Usage

``` r
check_string(
  x,
  allow_empty = FALSE,
  allow_na = FALSE,
  allow_null = FALSE,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
)
```

## Arguments

- x:

  The argument to check.

- allow_empty:

  Whether the empty string `""` is allowed (`check_string()` only).

- allow_na:

  Whether `NA` values are allowed.

- allow_null:

  Whether `NULL` is allowed.

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

If `x` is not a scalar string, an error is thrown. Otherwise, `x` is
invisibly returned.
