
#  ------------------------------------------------------------------------
#
# Title : Real Estate API Responses
#    By : Jimmy Briggs
#  Date : 2026-11-02
#
#  ------------------------------------------------------------------------

#' @importFrom httr2 resp_content_type
reapi_resp_body <- function(resp, ...) {
  check_response(resp)
  switch(
    httr2::resp_content_type(resp),
    "application/json" = reapi_resp_body_json(resp, ...),
    "application/xml" = reapi_resp_body_xml(resp, ...)
  )
}

#' @importFrom rlang hash
#' @importFrom httr2 resp_body_raw
reapi_resp_body_json <- function(resp, ...) {
  check_response(resp)
  key <- paste0("json-", substr(rlang::hash(list(...)), 1L, 10L))
  if (rlang::env_has(resp$cache, key)) {
    return(resp$cache[[key]])
  }
  resp_body_raw <- httr2::resp_body_raw(resp)
  json <- json_read(resp_body_raw, ...)
  resp$cache[[key]] <- json
  resp$cache[[key]]
}

#' @importFrom httr2 resp_body_xml
reapi_resp_body_xml <- function(resp, ...) {
  check_response(resp)
  httr2::resp_body_xml(resp, check_type = TRUE, ...)
}
