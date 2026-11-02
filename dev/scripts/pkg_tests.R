
#  ------------------------------------------------------------------------
#
# Title : Package Tests
#    By : Jimmy Briggs
#  Date : 2026-11-02
#
#  ------------------------------------------------------------------------

usethis::use_testthat()
httptest2::use_httptest2()
dir.create("inst/httptest2")
file.create("inst/httptest2/redact.R")

usethis::use_test_helper()
usethis::use_test("reapi")

usethis::use_spell_check()
cat(
  "if (requireNamespace(\"spelling\", quietly = TRUE)) {",
  "  spelling::spell_check_test(",
  "    vignettes = TRUE,",
  "    error = FALSE,",
  "    skip_on_cran = TRUE",
  "  )",
  "}",
  "",
  file = "tests/spelling.R",
  sep = "\n",
  append = FALSE
)
spelling::update_wordlist()

suggests <- c(
  "httptest2",
  yaml::read_yaml("dev/attachment.config.yml") |> purrr::pluck("extra.suggests")
) |>
  unique() |>
  sort()

attachment::att_amend_desc(
  extra.suggests = suggests,
  update.config = TRUE,
  path.c = "dev/attachment.config.yml"
)

