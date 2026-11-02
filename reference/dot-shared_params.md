# Shared Package Parameters

Use `@inheritParams .shared_params` in a function's roxygen2 block to
import these parameter descriptions.

Common, shared parameters that can be inherited by other functions in
the package.

## Arguments

- req:

  An
  [`httr2::request()`](https://httr2.r-lib.org/reference/request.html)
  object.

- resp:

  An
  [`httr2::response()`](https://httr2.r-lib.org/reference/response.html)
  object.
