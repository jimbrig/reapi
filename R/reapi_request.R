
#  ------------------------------------------------------------------------
#
# Title : Real Estate API Requests
#    By : Jimmy Briggs
#  Date : 2026-11-02
#
#  ------------------------------------------------------------------------

reapi_request <- function(endpoint = NULL, config = get_reapi_config(), , call = rlang::caller_env()) {
  check_reapi_config(config)
}

#' @importFrom utils getFromNamespace
new_reapi_request <- function(..., call = rlang::caller_env()) {
  httr2_new_request <- utils::getFromNamespace("new_request", "httr2")

}

reapi_req_auth <- function() {

}

