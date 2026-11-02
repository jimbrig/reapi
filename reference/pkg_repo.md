# Package Repository

Get the hosted version control (GitHub) repository for the `reapi`
package as either its full URL form or shorthand `user/repo` format.

## Usage

``` r
pkg_repo(url = FALSE)
```

## Arguments

- url:

  Logical. If `TRUE` returns the full URL for the repository, otherwise
  only returns the repository "reference" in the form `"user/repo"`,
  i.e. `"jimbrig/reapi"`. Defaults to the shorthand reference form via
  `url = FALSE`.

## Value

If `url = TRUE` returns the full URL as a character string, otherwise
returns the repository reference shorthand as a character string.
