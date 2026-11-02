
#  ------------------------------------------------------------------------
#
# Title : httptest2 Redaction
#    By : Jimmy Briggs
#  Date : 2024-11-14
#
#  ------------------------------------------------------------------------

function(resp) {
  resp |>
    httptest2::redact_headers(headers = c("X-Api-Key", "X-OpenAI-Key")) |>
    httptest2::redact_cookies()
}

