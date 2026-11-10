
#  ------------------------------------------------------------------------
#
# Title : Configuration
#    By : Jimmy Briggs
#  Date : 2026-11-02
#
#  ------------------------------------------------------------------------

# NOTE:
# THIS IS STILL EXPERIMENTAL AND WIP

.validate_url <- function(value) {
  if (!is.character(value) || length(value) != 1L) {
    return("must be a scalar character string")
  }
  if (!nzchar(value)) {
    return("must not be empty")
  }
  if (!grepl(pattern = "^https?://[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)+", value)) {
    return("must be a valid URL string format")
  }
  NULL
}

prop_base_url <- S7::new_property(
  name = "base_url",
  class = S7::class_character,
  default = "https://api.realestateapi.com",
  validator = .validate_url
)

reapi_config <- S7::new_class(
  name = "reapi_config",
  package = "reapi",
  properties = list(
    base_url = prop_base_url,
    api_key = S7::new_property(class = S7::class_character, default = quote(Sys.getenv("REAPI_API_KEY"))),
    api_key_public = S7::new_property(class = S7::class_character, default = quote(Sys.getenv("REAPI_API_KEY_PUBLIC"))),
    user_id = S7::new_property(class = S7::class_character, default = quote(Sys.getenv("REAPI_USER_ID"))),
    openai_api_key = S7::new_property(class = S7::class_character, default = quote(Sys.getenv("OPENAI_API_KEY")))
  )
)

check_reapi_config <- function(x, arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!S7::S7_inherits(x, class = reapi_config)) {
    check_abort("{.arg {arg}} must be a valid S7 {.cls reapi_config} class, not {.obj_type_friendly(x)}", call = call)
  }
  invisible(x)
}

read_reapi_config <- function(path = get_active_config_file(), env = get_active_config_env(), ..., call = rlang::caller_env()) {
  check_file(path, ext = c("yaml", "yml"), call = call)
  cfg_init <- reapi_config()
  hold <- config::get(value = "reapi", config = env, file = path) |> purrr::keep_at(S7::prop_names(cfg_init))
  do.call(S7::set_props, args = modifyList(list(`_object` = cfg_init), hold))
}

redact_reapi_config <- function(x, ...) {
  check_reapi_config(x)
  S7::set_props(
    `_object` = x,
    base_url = S7::prop(x, "base_url"),
    api_key = if (!nzchar(S7::prop(x, "api_key"))) "<MISSING>" else "<REDACTED>",
    api_key_public = if (!nzchar(S7::prop(x, "api_key"))) "<MISSING>" else "<REDACTED>",
    user_id = if (!nzchar(S7::prop(x, "user_id"))) "<MISSING>" else S7::prop(x, "user_id"),
    openai_api_key = if (!nzchar(S7::prop(x, "openai_api_key"))) "<MISSING>" else "<REDACTED>"
  )
}

S7::method(print, reapi_config) <- function(x, ...) {
  print_obj <- utils::getFromNamespace("print.S7_object", "S7")
  print_obj(redact_reapi_config(x), ...)
}

S7::method(str, reapi_config) <- function(x, ...) {
  str_obj <- utils::getFromNamespace("str.S7_object", "S7")
  str_obj(redact_reapi_config(x), ...)
}

# reapi_config()
#' <reapi::reapi_config>
#'  @ base_url      : chr "https://api.realestateapi.com"
#'  @ api_key       : chr "<REDACTED>"
#'  @ api_key_public: chr "<REDACTED>"
#'  @ user_id       : chr "<MISSING>"
#'  @ openai_api_key: chr "<REDACTED>"

verify <- S7::new_generic("verify", dispatch_args = "x", fun = function(x, ..., quiet = FALSE) {
  S7::S7_dispatch()
})

S7::method(verify, reapi_config) <- function(x, quiet = FALSE) {
  rlang::try_fetch({ S7::validate(x) }, error = function(err) { return(FALSE) })
  issues <- list(errors = character(), warnings = character(), informs = character())
  messages <- character()
  if (length(S7::prop(x, "api_key")) == 0L || !nzchar(S7::prop(x, "api_key"))) {
    issues$errors <- append(issues$errors, "api_key is not set and is required to perform requests.")
    messages <- append(messages, c("x" = "{.field api_key} is not set. {.field api_key} is required to perform requests."))
  }
  if (length(S7::prop(x, "api_key_public")) == 0L || !nzchar(S7::prop(x, "api_key_public"))) {
    issues$warnings <- append(issues$warnings, "api_key_public is not set and is required to perform /AutoComplete requests.")
    messages <- append(messages, c("!" = "{.field api_key_public} is not set. {.field api_key_public} is required to perform {.field /AutoComplete} requests."))
  }
  if (length(S7::prop(x, "user_id")) == 0L || !nzchar(S7::prop(x, "user_id"))) {
    issues$informs <- append(issues$informs, "user_id is not set. user_is is optional and not required.")
    messages <- append(messages, c("i" = "{.field user_id} is not set."))
  }
  if (length(S7::prop(x, "openai_api_key")) == 0L || !nzchar(S7::prop(x, "openai_api_key"))) {
    issues$warnings <- append(issues$warnings, "openai_api_key is not set and is required to perform /PropGPT requests.")
    messages <- append(messages, c("!" = "{.field openai_api_key} is not set. {.field openai_api_key} is required to perform {.field /PropGPT} requests."))
  }

  n_error <- length(issues$errors)
  n_warn <- length(issues$warnings)
  n_inform <- length(issues$informs)
  n_total <- n_error + n_warn + n_inform
  valid <- if (sum(n_error, n_warn) == 0L) TRUE else FALSE
  out <- structure(
    list(
      valid = valid,
      config = x,
      issues = issues,
      messages = messages
    ),
    class = "reapi_config_verification"
  )
  if (quiet) {
    return(invisible(out))
  }
  if (n_total > 0L) {
    msg_header <- paste0(
      "Found {.field {n_total}} total issues during configuration verification (",
      "{.field {n_error}} Errors; {.field {n_warn}} warnings; {.field {n_inform}} informational messages):"
    )
    cli::cli_bullets(c(msg_header, messages))
  } else {
    reapi_inform(c("v" = "No issues detected in provided configuration."))
  }
  invisible(out)
}

# cfg <- reapi_config()
# res <- verify(cfg)
# Found 1 total issues during configuration verification (0 Errors; 0 warnings; 1 informational messages):
# ℹ user_id is not set.
# res <- verify(cfg, quiet = TRUE)
# str(res)
# List of 4
#  $ valid   : logi TRUE
#  $ config  : <reapi::reapi_config>
#   ..@ base_url      : chr "https://api.realestateapi.com"
#   ..@ api_key       : chr "<REDACTED>"
#   ..@ api_key_public: chr "<REDACTED>"
#   ..@ user_id       : chr "<MISSING>"
#   ..@ openai_api_key: chr "<REDACTED>"
#  $ issues  :List of 3
#   ..$ errors  : chr(0)
#   ..$ warnings: chr(0)
#   ..$ informs : chr "user_id is not set. user_is is optional and not required."
#  $ messages: Named chr "{.field user_id} is not set."
#   ..- attr(*, "names")= chr "i"
#  - attr(*, "class")= chr "reapi_config_verification"
# res2 <- verify(reapi_config(api_key = "", api_key_public = "", user_id = "", openai_api_key = ""))
# Found 4 total issues during configuration verification (1 Errors; 2 warnings; 1 informational messages):
# ✖ api_key is not set. api_key is required to perform requests.
# ! api_key_public is not set. api_key_public is required to perform /AutoComplete requests.
# ℹ user_id is not set.
# ! openai_api_key is not set. openai_api_key is required to perform /PropGPT requests.
# res3 <- verify(reapi_config(user_id = "reapi_user_123"))
# ✔ No issues detected in provided configuration.
