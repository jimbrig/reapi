#  ------------------------------------------------------------------------
#
# Title : Documentation Utilities
#    By : Jimmy Briggs
#  Date : 2025-06-14
#
#  ------------------------------------------------------------------------

#' Open Real Estate API Documentation
#'
#' @description
#' Opens the Real Estate API documentation in a web browser.
#'
#' @returns
#' Opens the documentation URL in the default web browser and invisibly returns
#' the URL.
#'
#' @export
#'
#' @importFrom utils browseURL
#'
#' @seealso [Real Estate API Documentation](https://developer.realestateapi.com/reference/)
reapi_docs <- function() {
  utils::browseURL("https://developer.realestateapi.com/reference/")
  invisible("https://developer.realestateapi.com/reference/")
}
