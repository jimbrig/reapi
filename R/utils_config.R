
#  ------------------------------------------------------------------------
#
# Title : Configuration Utilities
#    By : Jimmy Briggs
#  Date : 2025-08-18
#
#  ------------------------------------------------------------------------

# active config ----------------------------------------------------------------

#' Manage Active Configuration
#'
#' @name active_config
#' @family config
#' @family utils
#'
#' @description
#' Functions for quickly accessing or setting the active configuration file and environment
#' for [config::get()].
#'
#' Get:
#'
#' - `get_active_config_env()`: Returns the active configuration run-time environment (`REAPI_CONFIG_ACTIVE`, `R_CONFIG_ACTIVE`).
#' - `get_active_config_file()`: Returns the active configuration file (`REAPI_CONFIG_FILE`, `R_CONFIG_FILE`).
#'
#' Set:
#'
#' - `set_active_config_env(env)`: Sets the active configuration environment
#' - `set_active_config_file(file)`: Sets the active configuration file
#'
#' @returns
#' - `get_active_config_env()`: The active configuration environment as a string.
#' - `get_active_config_file()`: The active configuration file as a string.
#' - `set_active_config_env(env)`: Returns the previous active configuration environment.
#' - `set_active_config_file(file)`: Returns the previous active configuration file.
#'
#' @seealso [config::get()]
NULL

#' @rdname active_config
#' @param default Default environment to return if no active environment is set. Defaults to "default".
#'   Possible values are "default", "development", "production", "testing".
#' @export
get_active_config_env <- function(default = c("default", "development", "production", "testing")) {
  default <- rlang::arg_match(default)
  get_env_cascade(c("REAPI_CONFIG_ACTIVE", "R_CONFIG_ACTIVE"), default = default)
}

#' @rdname active_config
#' @export
#' @param env The configuration environment to set as active.
set_active_config_env <- function(env) {
  old_env <- get_active_config_env()
  Sys.setenv(REAPI_CONFIG_ACTIVE = env, R_CONFIG_ACTIVE = env)
  invisible(old_env)
}

#' @rdname active_config
#' @export
get_active_config_file <- function(default = pkg_sys_config("config.yml")) {
  get_env_cascade(c("REAPI_CONFIG_FILE", "R_CONFIG_FILE"), default = default)
}

#' @rdname active_config
#' @export
#' @param file The configuration file path to set as active.
set_active_config_file <- function(file) {
  old_file <- get_active_config_file()
  check_file(file, ext = "yml")
  Sys.setenv(REAPI_CONFIG_FILE = file, R_CONFIG_FILE = file)
  invisible(old_file)
}

# Renviron ----------------------------------------------------------------

#' Read .Renviron File
#'
#' @description
#' Attempts to read a .Renviron file from the specified path or current working directory.
#' Used during package initialization to load environment variables.
#'
#' @param path Path to .Renviron file. Defaults to current working directory.
#' @param warn Logical. Show warning if file not found? Default `FALSE`.
#'
#' @returns
#' Invisibly returns `TRUE` if file was read successfully, `FALSE` otherwise.
#'
#' @keywords internal
#' @noRd
#' @importFrom cli cli_alert_warning
read_renviron <- function(path = NULL, warn = FALSE) {
  if (is.null(path)) path <- file.path(getwd(), ".Renviron")
  if (!file.exists(path)) {
    if (warn) cli::cli_alert_warning("No .Renviron file found at {.path {path}}.")
    return(invisible(FALSE))
  }
  readRenviron(path)
  invisible(TRUE)
}

# helpers ---------------------------------------------------------------------------------------------------------

#' @keywords internal
#' @noRd
get_env_cascade <- function(env_vars, default = NULL) {
  for (var in env_vars) {
    value <- Sys.getenv(var, unset = "")
    if (value != "") return(value)
  }
  default
}

