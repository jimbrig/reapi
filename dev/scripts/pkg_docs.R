
#  ------------------------------------------------------------------------
#
# Title : Package Documentation
#    By : Jimmy Briggs
#  Date : 2026-09-10
#
#  ------------------------------------------------------------------------

# vignettes --------------------------------------------------------------------

usethis::use_vignette("reapi.qmd", title = "Getting Started")

# man folder -------------------------------------------------------------------

c("roxygen", "figures", "fragments") |> purrr::walk(~ fs::dir_create(file.path("man", .x), recurse = TRUE))
fs::file_create("man/roxygen/meta.R")

# roxygen2 ---------------------------------------------------------------------

usethis::use_package_doc()

desc::desc_set("Config/roxygen2/markdown", "TRUE")
desc::desc_set("Config/roxygen2/version", utils::packageVersion("roxygen2"))

attachment::att_amend_desc(use.config = TRUE, path.c = "dev/attachment.config.yml")

# fragments --------------------------------------------------------------------

fs::file_create("man/fragments/reapi-links.md")
fs::file_create("man/fragments/reapi-search.md")
fs::file_create("man/fragments/reapi-request.md")
fs::file_create("man/fragments/reapi-response.md")

# readme -----------------------------------------------------------------------

usethis::use_readme_md()

# changelog --------------------------------------------------------------------

file.create("CHANGELOG.md")
usethis::use_build_ignore("CHANGELOG.md")
usethis::use_github_action(url = "https://github.com/noclocks/.github/blob/main/.github/workflows/changelog.yml")

# badges -----------------------------------------------------------------------

# usethis::use_r_universe_badge()

usethis::use_badge(
  badge_name = "R",
  href = "https://cran.r-project.org/",
  src = paste0(
    "https://img.shields.io/badge/Version-",
    utils::URLencode("\u2265", reserved = TRUE), # >= unicode symbol
    "%204.2.0-blue?style=social&logo=R&logoColor=%23276DC3"
  )
)

usethis::use_badge(
  badge_name = "Status",
  href = "",
  src = "https://img.shields.io/badge/Status-Work%20in%20Progress-brightgreen"
)

usethis::use_badge(
  badge_name = "RealEstateAPI",
  href = "https://api.realestateapi.com/reference",
  src = "https://img.shields.io/badge/RealEstateAPI-Reference%20Documentation-purple"
)

usethis::use_badge(
  badge_name = "Swagger (Production)",
  href = "https://api.realestateapi.com/swagger.json",
  src = "https://img.shields.io/badge/Swagger-Production-brightgreen?logo=swagger&logoColor=%2385EA2D"
)

usethis::use_badge(
  badge_name = "Swagger (Staging)",
  href = "https://staging.realestateapi.com/swagger.json",
  src = "https://img.shields.io/badge/Swagger-Production-brightgreen?logo=swagger&logoColor=%2385EA2D"
)

usethis::use_badge(
  "Automate Changelog",
  "https://github.com/jimbrig/reapi/actions/workflows/changelog.yml",
  "https://github.com/jimbrig/reapi/actions/workflows/changelog.yml/badge.svg"
)

usethis::use_badge(
  "pkgdown",
  "https://github.com/jimbrig/reapi/actions/workflows/pkgdown.yml",
  "https://github.com/jimbrig/reapi/actions/workflows/pkgdown.yml/badge.svg"
)

usethis::use_github_action("check-standard")
file.rename(".github/workflows/R-CMD-check.yaml", ".github/workflows/check.yml")

usethis::use_badge(
  "R-CMD-Check",
  "https://github.com/jimbrig/reapi/actions/workflows/check.yml",
  "https://github.com/jimbrig/reapi/actions/workflows/check.yml/badge.svg"
)

# brand ------------------------------------------------------------------------

brandfetch_api_key <- Sys.getenv("BRANDFETCH_API_KEY")
reapi_brand_request <- httr2::request("https://api.brandfetch.io/v2/brands") |> httr2::req_url_path_append("realestateapi.com") |> httr2::req_auth_bearer_token(token = brandfetch_api_key)
reapi_brand_response <- httr2::req_perform(reapi_brand_request, path = "dev/reapi.brandfetch.response.json")
reapi_brand <- reapi_brand_response |> httr2::resp_body_json()

reapi_banner_url <- reapi_brand$images[[1]]$formats[[1]]$src
download.file(url = reapi_banner_url, destfile = file.path("man/figures/reapi-banner.jpeg"))

# images -----------------------------------------------------------------------

fs::file_copy(
  file.path(fs::path_package("shiny"), "help", "figures", "logo.png"),
  file.path(this.path::this.proj(), "man", "figures", "shiny.png")
)

fs::file_copy(
  file.path(fs::path_package("httr2"), "help", "figures", "logo.png"),
  file.path(this.path::this.proj(), "man", "figures", "httr2.png")
)

download.file(
  url = "https://www.realestateapi.com/assets/img/realestateapi-logo-color.svg",
  destfile = file.path("man", "figures", "reapi-logo-color.svg")
)

download.file(
  url = "https://console.realestateapi.com/logos/realestateapi-logo-white.svg",
  destfile = file.path("man", "figures", "reapi-logo-white.svg")
)

download.file(
  url = "https://www.realestateapi.com/favicon.svg",
  destfile = file.path("man", "figures", "reapi-favicon.svg")
)

download.file(
  url = "https://www.realestateapi.com/favicon.ico",
  destfile = file.path("man", "figures", "reapi-favicon.ico")
)

# pkgdown ----------------------------------------------------------------------

usethis::use_pkgdown_github_pages()
file.rename(".github/workflows/pkgdown.yaml", ".github/workflows/pkgdown.yml")

usethis::use_directory("pkgdown", ignore = TRUE)
fs::file_move("_pkgdown.yml", "pkgdown/_pkgdown.yml")
if (file.exists("man/figures/logo.png")) {
  pkgdown::build_favicons()
}

# LICENSE -----------------------------------------------------------------

usethis::use_mit_license(copyright_holder = "Jimmy Briggs <jimmy.briggs@jimbrig.com>")

# LINKS.md ---------------------------------------------------------------------

fs::file_create("LINKS.md")
usethis::use_build_ignore("LINKS.md")

# NEWS.md ----------------------------------------------------------------------

usethis::use_news_md()
