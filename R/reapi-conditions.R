
#  ------------------------------------------------------------------------
#
# Title : reapi Conditions
#    By : Jimmy Briggs
#  Date : 2026-11-02
#
#  ------------------------------------------------------------------------

# topic -------------------------------------------------------------------

#' `reapi` Custom Conditions
#'
#' @name reapi-conditions
#' @aliases conditions
#' @family conditions
#' @family package
#'
#' @description
#' Functions for creating and handling custom reapi-specific conditions, including errors, warnings, and messages.
#'
#' - `reapi_abort()`: creates a condition representing an error and when thrown, aborts execution.
#' - `reapi_warn()`: creates a condition representing a warning condition
#' - `reapi_inform()`: creates a condition representing a message condition
#'
#' These functions wrap [cli::cli_abort()], [cli::cli_warn()], and [cli::cli_inform()] respectively,
#' adding `reapi`-specific context and class names (`reapi_*`) to the condition objects for
#' downstream handling and identification.
#'
#' @details
#' The condition class hierarchy is structured like so:
#'
#' ```plaintext
#' <reapi_condition>
#'   ├── <reapi_error>
#'   │   ├── <reapi_{custom}_error>
#'   ├── <reapi_warning>
#'   │   ├── <reapi_{custom}_warning>
#'   ├── <reapi_message>
#'   └────── <reapi_{custom}_message>
#' ```
#'
#' where `<reapi_condition>` is the base class for all `reapi` conditions
#' and sits on top of the existing `rlang` and base R condition classes.
#'
#' For example, a `reapi` error thrown without any additional custom class added
#' to it using `reapi_abort()` will have the following classes:
#'
#' ```R
#' [1] "reapi_error" "reapi_condition" "rlang_error" "error" "condition"
#' ```
#'
#' This allows for filtering and handling of reapi-specific conditions while
#' still being compatible with the broader R condition system.
#'
#' @param msg Character string or vector containing the message to be displayed. This gets
#'   passed to [cli::cli_bullets()] allowing for `cli`'s custom formatting,
#'   `glue` interpolation, inline markup syntax, and other features.
#' @param cls Optional character vector of additional classes to assign to the condition.
#' @inheritParams cli::cli_abort
#'
#' @returns
#' These functions do not return values, but are used for their side effects, namely
#' creating and signaling conditions. The `reapi_abort()` function will stop
#' execution, while `reapi_warn()` & `reapi_inform()` will allow execution
#' to proceed.
#'
#' @examples
#' \dontrun{
#' reapi_abort("This is a reapi error.")
#'
#' # catch a condition and check its classes
#' err <- rlang::catch_cnd(reapi_abort("Error Message"))
#' class(err)
#'
#' # catch a warning and check its classes
#' wrn <- rlang::catch_cnd(reapi_warn("Warning Message"))
#' class(wrn)
#'
#' # catch a message and check its classes
#' msg <- rlang::catch_cnd(reapi_inform("Message"))
#' class(msg)
#' }
NULL

# abort -------------------------------------------------------------------

#' @rdname reapi-conditions
#' @export
#' @importFrom cli cli_abort
#' @importFrom rlang caller_env
reapi_abort <- function(msg = NULL, cls = NULL, ..., parent = NULL, call = rlang::caller_env(), .envir = parent.frame()) {
  classes <- c(cls, "reapi_error", "reapi_condition")
  cli::cli_abort(message = msg, class = classes, parent = parent, call = call, .envir = .envir, ...)
}

# warn --------------------------------------------------------------------

#' @rdname reapi-conditions
#' @export
#' @importFrom cli cli_warn
reapi_warn <- function(msg = NULL, cls = NULL, ..., .envir = parent.frame()) {
  classes <- c(cls, "reapi_warning", "reapi_condition")
  cli::cli_warn(message = msg, class = classes, .envir = .envir, ...)
}


# inform ------------------------------------------------------------------

#' @rdname reapi-conditions
#' @export
#' @importFrom cli cli_inform
reapi_inform <- function(msg = NULL, cls = NULL, ..., .envir = parent.frame()) {
  classes <- c(cls, "reapi_message", "reapi_condition")
  cli::cli_inform(message = msg, class = classes, .envir = .envir, ...)
}

# checks -------------------------------------------------------------------

#' Check Conditions
#'
#' @family checks
#' @family utils
#' @family conditions
#'
#' @description
#' These functions are specialized versions of the `reapi` condition functions that are intended for
#' use in the package's internal checking functions. They create conditions with
#' specific classes that can be used to identify and handle errors, warnings, and messages.
#'
#' @section Functions:
#' - `reapi_abort_check()`: creates an `reapi_error` condition for checks.
#' - `reapi_warn_check()`: creates an `reapi_warning` condition for checks.
#' - `reapi_inform_check()`: creates an `reapi_message` condition for checks.
#'
#' @section Aliases:
#' - `check_abort()`: alias for `reapi_abort_check()`
#' - `check_warn()`: alias for `reapi_warn_check()`
#' - `check_inform()`: alias for `reapi_inform_check()`
#'
#' @inherit reapi_abort
#'
#' @export
reapi_abort_check <- function(msg, ..., parent = NULL, call = rlang::caller_env(), .envir = parent.frame()) {
  reapi_abort(msg = msg, cls = "reapi_check_error", ..., call = call, .envir = .envir)
}

#' @rdname reapi_abort_check
#' @export
reapi_warn_check <- function(msg, ..., call = rlang::caller_env(), .envir = parent.frame()) {
  reapi_warn(msg = msg, cls = "reapi_check_warning", ..., call = call, .envir = .envir)
}

#' @rdname reapi_abort_check
#' @export
reapi_inform_check <- function(msg, ..., call = rlang::caller_env(), .envir = parent.frame()) {
  reapi_inform(msg = msg, cls = "reapi_check_message", ..., .envir = .envir)
}

#' Convenience Alias for `reapi_abort_check()`
#' @rdname reapi_abort_check
#' @export
check_abort <- reapi_abort_check

#' Convenience Alias for `reapi_abort_warn()`
#' @rdname reapi_abort_check
#' @export
check_warn <- reapi_warn_check

#' Convenience Alias for `reapi_abort_inform()`
#' @rdname reapi_abort_check
#' @export
check_inform <- reapi_inform_check

# config -------------------------------------------------------------------

reapi_abort_config <- function(msg, ..., parent = NULL, call = rlang::caller_env(), .envir = parent.frame()) {
  reapi_abort(msg = msg, cls = "reapi_config_error", parent = parent, ..., call = call, .envir = .envir)
}

reapi_abort_config_api_key <- function(arg = "api_key", call = rlang::caller_env()) {
  reapi_abort(msg = "{.arg {arg}} is required. Set the API key using the environment variable {.envvar ENTRATA_API_KEY}.", parent = get_reapi_config(), call = call, .envir = parent.frame())
}

# request ------------------------------------------------------------------

