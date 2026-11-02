
#  ------------------------------------------------------------------------
#
# Title : reapi Package Initialization
#    By : Jimmy Briggs
#  Date : 2026-09-01
#
#  ------------------------------------------------------------------------

if (FALSE) {
  usethis::create_package("reapi")
  usethis::use_namespace()
  desc::desc_set(
    "Title" = "R API Client for Real Estate API (api.realestateapi.com)",
    "Description" = "Comprehensive API client library package to interface and work with services provided by Real Estate API (api.realestateapi.com)."
  )
  desc::desc_set_dep("R", type = "Depends", version = ">= 4.2.0")
  desc::desc_set_dep("rlang", type = "Imports", version = ">= 1.1.0")
  desc::desc_set_dep("httr2", type = "Imports")
  desc::desc_set("Config/roxygen2/markdown", "TRUE")
  desc::desc_set("Config/roxygen2/version", utils::packageVersion("roxygen2"))
  desc::desc_set("Config/rcmdcheck/ignore-inconsequential-notes", "true")
  desc::desc_set("Config/testthat/edition", "3")
  desc::desc_normalize()
  usethis::use_git()
  usethis::use_github()
  usethis::use_github_links()
  pkg_suggests <- c("knitr", "rmarkdown", "spelling", "testthat", "httptest2", "withr")
  pkg_suggests |> purrr::walk(desc::desc_set_dep, type = "Suggests")

  attachment::att_amend_desc(extra.suggests = pkg_suggests, update.config = TRUE, path.c = "dev/attachment.config.yml")

  file.create("AGENTS.md")
  usethis::use_build_ignore("AGENTS.md")

  usethis::use_github_file(repo_spec = "noclocks/.github", path = ".github/dependabot.yml", save_as = ".github/dependabot.yml")
}
