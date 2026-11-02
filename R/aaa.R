
#  ------------------------------------------------------------------------
#
# Title : Shared Package Resources
#    By : Jimmy Briggs
#  Date : 2026-11-02
#
#  ------------------------------------------------------------------------

# docs --------------------------------------------------------------------

#' Real Estate API Links
#'
#' @name reapi_links
#'
#' @description
#' A collection of useful links related to the Real Estate API.
#'
#' ```{r child = "man/fragments/reapi-links.md"}
#' ```
#'
#' @seealso [reapi_docs()]
NULL

# params ------------------------------------------------------------------

#' Shared Package Parameters
#'
#' @name .shared_params
#'
#' @description
#' Use `@inheritParams .shared_params` in a function's roxygen2 block to import these parameter descriptions.
#'
#' @description
#' Common, shared parameters that can be inherited by other functions in the package.
#'
#' @param req An [httr2::request()] object.
#' @param resp An [httr2::response()] object.
#'
# #' @param config A [reapi_config()] object containing client configuration values for the Real Estate API client.
# #'   Should include `base_url`, `api_key`, `user_id`, and optionally `openai_api_key` for PropGPT requests.
# #'   Defaults to the result of [get_reapi_config()].
# #'
# #' @param cache A `cachem::cache_*()` object for caching responses. Defaults to
# #'   the result of [get_reapi_cache()] which will return `NULL` if no cache is set
# #'   (i.e. `get_reapi_option("cache")`). If `NULL`, caching is disabled.
# #'
# #' @param logger An [lgr::Logger] object used for structured logging. Defaults to the result of
# #'   [get_reapi_logger()] which will return `NULL` if no logger is set (i.e. `get_reapi_option("logger")`).
# #'   If `NULL`, logging is disabled.
# #'
# #' @param validate Logical. Should the request be validated before sending? Defaults to `TRUE`.
# #'   This uses [reapi_req_validate()] to ensure the request body passes JSON schema validation.
# #'
# #' @param tidy Logical. Should the response be tidied before returning? Defaults to `TRUE`.
# #'   This uses [reapi_resp_tidy()] to convert the response to a rectangular, flattened [tibble::tibble()].
# #'
# #' @param perform_opts Additional arguments passed to [reapi_req_perform()]. Defaults to
# #'   [get_reapi_perform_opts()] which returns the active request perform configured options.
# #'
# #' @param config A configuration object for the Real Estate API client. Defaults to
# #'   [get_reapi_config()] which returns the active configuration.
#'
#' @keywords internal
NULL

# request modifiers -----------------------------------------------------------------------------------------------

#' Real Estate API Request Modifiers
#'
#' @name reapi_request_modifiers
#'
#' @description
#' These functions modify the [httr2::request()] object to add various features
#' such as endpoints, authentication, user agent, body, error handling, retry logic,
#' throttling, logging, caching, and file saving.
#'
#' Functions:
#'
#' - `reapi_req_auth()`: Adds authentication headers to the request.
#' - `reapi_req_user_agent()`: Sets the user agent for the request.
#' - `reapi_req_endpoint()`: Adds an endpoint to the request URL.
#' - `reapi_req_body()`: Sets the body of the request to a JSON object.
#' - `reapi_req_validate()`: Validates the request body against the specified endpoint's parameters.
#' - `reapi_req_error()`: Sets up ReAPI-specific error handling for the request.
#' - `reapi_req_retry()`: Retries the request if it fails due to transient errors.
#' - `reapi_req_throttle()`: Applies throttling to the request.
#' - `reapi_req_logger()`: Attaches a logger to the request object for logging request details.
#' - `reapi_req_cache()`: Attaches a custom cache feature to the request object for caching responses.
#' - `reapi_req_cache_key()`: Derives a cache key for the request based on its hash and endpoint that is
#' - `reapi_req_hash()`: Generates a hash for the request based on its components.
#' - `reapi_req_file()`: Generates a file name for saving the request to disk.
#' - `reapi_req_resp_file()`: Generates a file name for saving the response to disk.
#'
# #' @seealso
# #' [reapi_request()], [httr2::request()],
# #' [reapi_req_endpoint()], [reapi_req_auth()], [reapi_req_user_agent()], [reapi_req_body()], [reapi_req_validate()],
# #' [reapi_req_error()], [reapi_req_retry()], [reapi_req_throttle()], [reapi_req_logger()], [reapi_req_cache()],
# #' [reapi_req_cache_key()], [reapi_req_hash()], [reapi_req_file()], [reapi_req_resp_file()]
NULL

# returns -----------------------------------------------------------------

#' Request Returns
#'
#' @name .shared_returns_request
#'
#' @description
#' Returns for functions that return an [httr2::request()].
#'
#' @returns
#' An [httr2::request()] object configured for the Real Estate API.
#'
#' @keywords internal
NULL

#' Response Returns
#'
#' @name .shared_returns_response
#'
#' @description
#' Returns for functions that return an [httr2::response()].
#'
#' @returns
#' An [httr2::response()] object containing the response from the Real Estate API.
#'
#' @keywords internal
NULL

