
#  ------------------------------------------------------------------------
#
# Title : Check Utilities
#    By : Jimmy Briggs
#  Date : 2026-10-16
#
#  ------------------------------------------------------------------------

# inherits ----------------------------------------------------------------

#' Class Inheritance Checks
#'
#' @description
#' These functions perform checks that assert the underlying class of objects passed to them.
#'
#' - `check_inherits()`: checks that object `x` is of class `class` using [base::inherits()]
#' - `check_inherits2()`: checks that object `x` is of class `class` using [base::.class2()]
#' - `check_inherits_any()`: checks that object `x` is at least one of the provided `classes` via [rlang::inherits_any()]
#' - `check_inherits_all()`: checks that object `x` is all of the provided `classes` via [rlang::inherits_all()]
#'
#' If validation fails for any of these functions, an error is thrown via `check_abort()` displaying a friendly
#' error message.
#'
#' @param x The object to check.
#' @param class,classes The name of the class or classes to use during checking.
#' @inheritParams rlang::args_error_context
#'
#' @returns
#' If checks pass, invisibly returns the provided `x` object. If checks fail, a condition error is thrown.
#'
#' @export
check_inherits <- function(x, class, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!inherits(x, class)) {
    check_abort("{.arg {arg}} must inherit from class {.cls {class}}, not {.obj_type_friendly {x}}.", call = call)
  }
  invisible(x)
}

#' @rdname check_inherits
#' @export
check_inherits2 <- function(x, class, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!(class %in% .class2(x))) {
    check_abort("{.arg {arg}} must inherit from class {.cls {class}}, not {.cls {.class2(x)}}", call = call)
  }
  invisible(x)
}

#' @rdname check_inherits
#' @export
#' @importFrom rlang inherits_any
check_inherits_any <- function(x, classes, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!rlang::inherits_any(x, classes)) {
    check_abort(
      "{.arg {arg}} must inherit from one of the classes: {.cls {classes}}, not {.obj_type_friendly {x}}.",
      call = call
    )
  }
  invisible(x)
}

#' @rdname check_inherits
#' @export
#' @importFrom rlang inherits_all
check_inherits_all <- function(x, classes, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!rlang::inherits_all(x, classes)) {
    check_abort(
      "{.arg {arg}} must inherit from all of the classes: {.cls {classes}}, not {.obj_type_friendly {x}}.",
      call = call
    )
  }
  invisible(x)
}

# typeof ------------------------------------------------------------------

check_typeof <- function(x, type, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!identical(typeof(x), type)) {
    check_abort("{.arg {arg}} must be of type {.cls {type}}, not {.obj_type_friendly {x}}.", call = call)
  }
  invisible(x)
}

# empty --------------------------------------------------------------------

#' Check Not Empty
#'
#' @description
#' Checks the provided `x` is not "empty" via [rlang::is_empty()].
#'
#' @inheritParams check_inherits
#'
#' @returns
#' If checks pass, invisibly returns the provided `x` object. If checks fail, a condition error is thrown.
#'
#' @export
#'
#' @importFrom rlang is_empty
check_not_empty <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (rlang::is_empty(x)) {
    check_abort("{.arg {arg}} must not be empty.", call = call)
  }
  invisible(x)
}

# code --------------------------------------------------------------------

#' @importFrom rlang is_function
check_function <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!rlang::is_function(x)) {
    check_abort("{.arg {arg}} must be a function.", call = call)
  }
  invisible(x)
}

# scalars -----------------------------------------------------------------

#' Check String (Scalar)
#'
#' @description
#' Checks the provided `x` is a scalar string via [rlang::check_string()].
#'
#' @inheritParams rlang::check_string
#'
#' @returns
#' If `x` is not a scalar string, an error is thrown. Otherwise, `x` is invisibly
#' returned.
#'
#' @export
#'
#' @importFrom rlang try_fetch check_string
check_string <- function(x, allow_empty = FALSE, allow_na = FALSE, allow_null = FALSE, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  rlang::try_fetch({
    rlang::check_string(x, allow_empty = allow_empty, allow_na = allow_na, allow_null = allow_null, arg = arg, call = call)
  }, error = function(err) {
    check_abort(msg = rlang::cnd_message(err), parent = err, arg = arg, call = call)
  })
  invisible(x)
}

# vectors -----------------------------------------------------------------

# structures --------------------------------------------------------------

check_list <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!is.list(x) || is.data.frame(x)) {
    check_abort("{.arg {arg}} must be a list, not {.obj_type_friendly {x}}.", call = call)
  }
  invisible(x)
}

# names -------------------------------------------------------------------

#' @importFrom rlang is_named
check_named <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!rlang::is_named(x)) {
    check_abort("{.arg {arg}} must be a named vector or list.", call = call)
  }
  invisible(x)
}

#' @importFrom rlang is_named2
check_named2 <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!rlang::is_named2(x)) {
    check_abort("{.arg {arg}} must be a named vector or list.", call = call)
  }
  invisible(x)
}

check_names <- function(x, required, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_named(x, arg = arg, call = call)
  missing_names <- setdiff(required, names(x))
  if (length(missing_names) > 0) {
    check_abort("{.arg {arg}} is missing required names: {.field {missing_names}}.", call = call)
  }
  invisible(x)
}

# dates/times -------------------------------------------------------------

check_date <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_inherits_any(x, classes = c("Date", "POSIXct"), arg = arg, call = call)
}

check_time <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_inherits(x, "POSIXt", arg = arg, call = call)
  check_inherits_any(x, classes = c("POSIXct", "POSIXlt"), arg = arg, call = call)
}

# paths -------------------------------------------------------------------

check_path <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_string(x, allow_empty = FALSE, arg = arg, call = call)
  if (!file.exists(x)) {
    check_abort(
      "{.arg {arg}} must be a valid file or folder path that exists: {.file {x}} does not exist.",
      call = call
    )
  }
  invisible(x)
}

check_folder <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_string(x, allow_empty = FALSE, arg = arg, call = call)
  if (!dir.exists(x)) {
    check_abort("{.arg {arg}} must be a valid folder path: {.path {x}} does not exist.", call = call)
  }
  invisible(x)
}

#' @importFrom tools file_ext
check_file <- function(x, ext = NULL, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_path(x, arg = arg, call = call)
  if (is.null(ext)) {
    return(invisible(x))
  }
  ext <- tolower(ext)
  ext <- gsub("*", "", ext, fixed = TRUE)
  ext <- gsub(".", "", ext, fixed = TRUE)
  if (length(ext) > 1L) {
    if (!any(tools::file_ext(x) %in% ext)) {
      check_abort("{.arg {arg}} must have one of the following extensions: {.field {ext}}.", call = call)
    }
  } else {
    if (tools::file_ext(x) != ext) {
      check_abort("{.arg {arg}} must have the extension {.field {ext}}.", call = call)
    }
  }
  invisible(x)
}

# regex -------------------------------------------------------------------

check_regex <- function(x, pattern, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_string(x, call = call)
  if (!grepl(pattern, x)) {
    check_abort("{.arg {arg}} must match the regular expression pattern: {.field {pattern}}.", call = call)
  }
  invisible(x)
}


# urls --------------------------------------------------------------------

check_url <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_string(x, allow_empty = FALSE, arg = arg, call = call)
  check_regex(x, pattern = "^(http|https)://", arg = arg, call = call)
  invisible(x)
}

check_ipv4 <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_string(x, allow_empty = FALSE, arg = arg, call = call)
  pattern <- "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
  check_regex(x, pattern = pattern, arg = arg, call = call)
  invisible(x)
}


# http --------------------------------------------------------------------

#' @importFrom rlang is_integerish
check_http_status_code <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!rlang::is_integerish(x, n = 1, finite = TRUE) || x < 100 || x > 599) {
    check_abort("{.arg {arg}} must be a single HTTP status code between 100 and 599, not {.val {x}}.", call = call)
  }
  invisible(x)
}

# req/resp ----------------------------------------------------------------

check_request <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_inherits_any(x, c("reapi_request", "httr2_request"), arg = arg, call = call)
}

check_response <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_inherits_any(x, c("reapi_response", "httr2_response"), arg = arg, call = call)
}

# reapi -------------------------------------------------------------------

check_reapi_config <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_inherits(x, class = "reapi_config", arg = arg, call = call)
}

check_reapi_request <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_inherits(x, class = "reapi_request", arg = arg, call = call)
}

check_reapi_response <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_inherits(x, class = "reapi_response", arg = arg, call = call)
}

check_reapi_endpoint <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!x %in% .reapi_endpoints()) {
    check_abort(msg = "{.arg {arg}} is not a valid endpoint for Real Estate API", call = call)
  }
  invisible(x)
}

check_reapi_params <- function(x, arg = rlang::caller_arg(params), call = rlang::caller_env()) {
  check_inherits(x, "reapi_params", arg = arg, call = call)
}

check_reapi_operator <- function(x, arg = rlang::caller_arg(operator), call = rlang::caller_env()) {
  valid_ops <- c("gt", "lt", "eq")
  if (!x %in% valid_ops) {
    check_abort("{.arg {arg}} must be one of {.val {valid_ops}}, not {.val {operator}}", call = call)
  }
  invisible(x)
}

# httr2 -------------------------------------------------------------------

check_httr2_url <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_inherits(x, class = "httr2_url", arg = arg, call = call)
}

check_httr2_request <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_inherits(x, class = "httr2_request", arg = arg, call = call)
}

check_httr2_requests <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_inherits(x, class = "httr2_requests", arg = arg, call = call)
}

check_httr2_response <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_inherits(x, class = "httr2_response", arg = arg, call = call)
}

check_httr2_responses <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_inherits(x, class = "httr2_responses", arg = arg, call = call)
}

check_httr2_headers <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  check_inherits(x, class = "httr2_headers", arg = arg, call = call)
}


# json --------------------------------------------------------------------

check_json_str <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!is_valid_json_str(x)) {
    check_abort("{.arg {arg}} must be a valid JSON string.", arg = arg, call = call)
  }
  invisible(x)
}

check_json_file <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!is_valid_json_file(x)) {
    check_abort("{.arg {arg}} must be a valid path to a JSON file.", arg = arg, call = call)
  }
  invisible(x)
}

# internal ----------------------------------------------------------------

