
#  ------------------------------------------------------------------------
#
# Title : Package Development (Ongoing)
#    By : Jimmy Briggs
#  Date : 2026-11-02
#
#  ------------------------------------------------------------------------

# R/ ----------------------------------------------------------------------

# "package"
usethis::use_package_doc()
c("reapi-conditions", "reapi-options") |> purrr::walk(usethis::use_r, open = FALSE)

# aaa & zzz
c("aaa", "zzz") |> purrr::walk(usethis::use_r, open = FALSE)

# initial utilities
c("utils_pkg", "utils_config", "utils_checks", "utils_json", "utils_docs") |> purrr::walk(usethis::use_r, open = FALSE)

# reapi_* modules
c(
  "reapi_config",
  "reapi_request",
  "reapi_response",
  "reapi_perform"
) |>
  purrr::walk(usethis::use_r, open = FALSE)

# inst/ -------------------------------------------------------------------

c("config", "extdata", "schemas", "openapi") |> purrr::walk(~ fs::dir_create(file.path("inst", .x)))

r"(
# reapi configuration
default:
  reapi:
    base_url: "https://api.realestateapi.com"
    api_key: !expr Sys.getenv("REAPI_API_KEY", "")
    api_key_public: !expr Sys.getenv("REAPI_API_KEY_PUBLIC", "")
    user_id: !expr Sys.getenv("REAPI_USER_ID", "")
    openai_api_key: !expr Sys.getenv("OPENAI_API_KEY", "")

testing:

development:

production:
)" |>
  cat(file = "inst/config/config.yml")

file.create("inst/extdata/.gitkeep")
file.create("inst/schemas/README.md")
file.create("inst/openapi/README.md")
