# Package System File

Functions wrapping
[`base::system.file()`](https://rdrr.io/r/base/system.file.html) to
provide the path to a packaged file. They are used to access installed
package resources.

Note that all paths are also normalized via
[`base::normalizePath()`](https://rdrr.io/r/base/normalizePath.html)
enforcing `winslash = "/"` as well for cross-platform consistent paths.

Currently implemented for the following:

- `pkg_sys()`: Root level
  [`system.file()`](https://rdrr.io/r/base/system.file.html) (`inst/`)

- `pkg_sys_config()`: Configuration folder (`inst/config`)

- `pkg_sys_extdata()`: `extdata` folder (`inst/extdata`)

- `pkg_sys_schemas()`: JSON schemas folder (`inst/schemas`)

- `pkg_sys_openapi()`: OpenAPI specification folder (`inst/openapi`)

- `pkg_sys_swagger()`: Bundled Swagger folder (`inst/openapi/swagger`)

- `pkg_sys_docs()`: Bundled rendered documentation folder (`inst/docs`)

## Usage

``` r
pkg_sys(...)

pkg_sys_extdata(...)

pkg_sys_config(...)

pkg_sys_schemas(...)

pkg_sys_openapi(...)
```

## Arguments

- ...:

  Arguments passed on to
  [`base::system.file`](https://rdrr.io/r/base/system.file.html)

  `lib.loc`

  :   a character vector with path names of R libraries. See ‘Details’
      for the meaning of the default value of `NULL`.

  `mustWork`

  :   logical. If `TRUE`, an error is given if there are no matching
      files.

## Value

Character string with the full normalized file path to the requested
resource bundled with this package.

## See also

[`base::system.file()`](https://rdrr.io/r/base/system.file.html)

## Examples

``` r
# access the config.yml
pkg_sys("config/config.yml")
#> [1] "/home/runner/work/_temp/Library/reapi/config/config.yml"

# or use the convenience wrapper for the config folder:
pkg_sys_config("config.yml")
#> [1] "/home/runner/work/_temp/Library/reapi/config/config.yml"

# similarly for extdata/
pkg_sys("extdata")
#> [1] "/home/runner/work/_temp/Library/reapi/extdata"
pkg_sys_extdata()
#> [1] "/home/runner/work/_temp/Library/reapi/extdata"
```
