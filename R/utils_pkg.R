
#  ------------------------------------------------------------------------
#
# Title : Package Utilities
#    By : Jimmy Briggs
#  Date : 2026-09-06
#
#  ------------------------------------------------------------------------

#' Package Utilities
#'
#' @name utils_pkg
#' @family package
#' @family utils
#'
#' @description
#' Various functions providing mostly internal package-specific logic, but are
#' still exported for clarity.
#'
#' All functions here will be prefixed with `pkg_*()` to provide a consistent,
#' semantic identity and grouping of the common functionalities.
#'
#' @section Functions:
#'
#' ### Package Metadata
#'
#' - `pkg_name()`: Get the package name.
#' - `pkg_version()`: Get the package version.
#' - `pkg_repo()`: Get the package repository.
#'
#' ### User Agent
#'
#' - `pkg_user_agent()`: Get the package user agent.
#'
#' ### System File
#'
#' - `pkg_sys()`: Get the package system file.
#'
#' ### Startup Message
#'
#' - `pkg_startup_msg()`: Get the package startup message.
#'
#' ### Banner
#'
#' - `pkg_banner()`: Get the package banner.
#'
#'
NULL

# meta --------------------------------------------------------------------

#' Package Name
#'
#' @description
#' Simply provides the package name: `"reapi"`.
#'
#' @returns
#' The package name as a character string: `"reapi"`.
#'
#' @export
#' @keywords internal
pkg_name <- function() {
  "reapi"
}

#' Package Version
#'
#' @description
#' Retrieve's the version of the current installed `reapi` package.
#'
#' @returns
#' The package version as a character string.
#'
#' @export
#' @keywords internal
#' @importFrom utils packageVersion
pkg_version <- local({
  version <- NULL
  function() {
    if (is.null(version)) {
      version <<- as.character(utils::packageVersion(pkg_name()))
    }
    version
  }
})

#' Package Repository
#'
#' @description
#' Get the hosted version control (GitHub) repository for the `reapi` package as
#' either its full URL form or shorthand `user/repo` format.
#'
#' @param url Logical. If `TRUE` returns the full URL for the repository, otherwise
#'   only returns the repository "reference" in the form `"user/repo"`, i.e. `"jimbrig/reapi"`.
#'   Defaults to the shorthand reference form via `url = FALSE`.
#'
#' @returns
#' If `url = TRUE` returns the full URL as a character string, otherwise returns the
#' repository reference shorthand as a character string.
#'
#' @export
#' @keywords internal
pkg_repo <- function(url = FALSE) {
  if (url) {
    "https://github.com/jimbrig/reapi"
  } else {
    "jimbrig/reapi"
  }
}

# user agent ------------------------------------------------------------------------------------------------------

#' Package User Agent
#'
#' @description
#' Get the user agent string for the `reapi` package. This includes the package name and version in the typical
#' format of `<package-name>/<package-version>`.
#'
#' @returns
#' The user agent string for the package as a character string.
#'
#' @export
#' @keywords internal
pkg_user_agent <- function() {
  paste0(pkg_name(), "/", pkg_version())
}

# system file -----------------------------------------------------------------------------------------------------

#' Package System File
#'
#' @description
#' Functions wrapping [base::system.file()] to provide the path to a packaged file.
#' They are used to access installed package resources.
#'
#' Note that all paths are also normalized via [base::normalizePath()] enforcing
#' `winslash = "/"` as well for cross-platform consistent paths.
#'
#' Currently implemented for the following:
#'
#' - `pkg_sys()`: Root level `system.file()` (`inst/`)
#'
#' - `pkg_sys_config()`: Configuration folder (`inst/config`)
#'
#' - `pkg_sys_extdata()`: `extdata` folder (`inst/extdata`)
#'
#' - `pkg_sys_schemas()`: JSON schemas folder (`inst/schemas`)
#'
#' - `pkg_sys_openapi()`: OpenAPI specification folder (`inst/openapi`)
#'
#' - `pkg_sys_swagger()`: Bundled Swagger folder (`inst/openapi/swagger`)
#'
#' - `pkg_sys_docs()`: Bundled rendered documentation folder (`inst/docs`)
#'
#' @inheritDotParams base::system.file -package
#'
#' @returns
#' Character string with the full normalized file path to the requested resource
#' bundled with this package.
#'
#' @export
#' @keywords internal
#'
#' @seealso [base::system.file()]
#'
#' @examples
#' # access the config.yml
#' pkg_sys("config/config.yml")
#'
#' # or use the convenience wrapper for the config folder:
#' pkg_sys_config("config.yml")
#'
#' # similarly for extdata/
#' pkg_sys("extdata")
#' pkg_sys_extdata()
pkg_sys <- function(...) {
  normalizePath(system.file(..., package = pkg_name()), winslash = "/")
}

#' @rdname pkg_sys
#' @export
pkg_sys_extdata <- function(...) {
  pkg_sys("extdata", ...)
}

#' @rdname pkg_sys
#' @export
pkg_sys_config <- function(...) {
  pkg_sys("config", ...)
}

#' @rdname pkg_sys
#' @export
pkg_sys_schemas <- function(...) {
  pkg_sys("schemas", ...)
}

#' @rdname pkg_sys
#' @export
pkg_sys_openapi <- function(...) {
  pkg_sys("openapi", ...)
}

# docs --------------------------------------------------------------------

#' Package Docs
#'
#' @description
#' Open the browser to the `reapi` documentation:
#'
#' <https://docs.jimbrig.com/reapi/>
#'
#' @returns
#' Invisibly returns the URL to the documentation site.
#'
#' @export
#'
#' @importFrom utils browseURL
pkg_docs <- function() {
  utils::browseURL("https://docs.jimbrig.com/reapi")
  invisible("https://docs.jimbrig.com/reapi")
}

# startup message -------------------------------------------------------------------------------------------------

#' @keywords internal
#' @noRd
#' @importFrom crayon bold cyan yellow
pkg_startup_msg <- function() {
  cli::cli_fmt({
    cli::cli_rule("{.pkg {pkg_name()}} ({.field v{pkg_version()}}) - {.emph Real Estate API Client}")
    cli::cli_alert_info("Visit {.url https://api.realestateapi.com/reference/} for API documentation.")
    cli::cli_bullets(
      c(
        "i" = "Configuration Environment: {.field {get_active_config_env()}}",
        "i" = "Configuration File: {.field {basename(get_active_config_file())}}"
      )
    )
  }, collapse = TRUE)
}

# banner ----------------------------------------------------------------------------------------------------------

#' @keywords internal
#' @noRd
pkg_banner <- function() {
  .pkg_banner_str
}

# environment -----------------------------------------------------------------------------------------------------

#' @keywords internal
#' @noRd
pkg_env_init <- function() {
  if (!exists(".pkg_env")) {
    return()
  }

  # config
  .pkg_env$config <- NULL
}

#' @keywords internal
#' @noRd
#' @importFrom rlang env_get
pkg_env_get <- function(key, default = NULL) {
  rlang::env_get(env = .pkg_env, nm = key, default = default)
}

#' @keywords internal
#' @noRd
#' @importFrom rlang env_poke
pkg_env_set <- function(key, value, create = FALSE) {
  rlang::env_poke(env = .pkg_env, nm = key, value = value, create = create)
}

#' @keywords internal
#' @noRd
#' @importFrom rlang env_cache
pkg_env_cache <- function(key, default) {
  rlang::env_cache(env = .pkg_env, nm = key, default = default)
}

# internal ----------------------------------------------------------------

#' @keywords internal
#' @noRd
#' @seealso https://manytools.org/hacker-tools/ascii-banner/
.pkg_banner_str <- r"(
    _______   ____________  ___  _________    ____
   / ____/ | / /_  __/ __ \/   |/_  __/   |  / __ \
  / __/ /  |/ / / / / /_/ / /| | / / / /| | / /_/ /
 / /___/ /|  / / / / _, _/ ___ |/ / / ___ |/ _, _/
/_____/_/ |_/ /_/ /_/ |_/_/  |_/_/ /_/  |_/_/ |_|

)"
