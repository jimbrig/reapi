
#  ------------------------------------------------------------------------
#
# Title : GitHub Labels
#    By : Jimmy Briggs
#  Date : 2026-09-02
#
#  ------------------------------------------------------------------------

local({

  gh_labels <- tibble::tribble(
    ~name,           ~description,                                                ~color,
    "feature",       "New feature or enhancement",                                "0e8a16",
    "release",       "Release or version bump",                                   "fbca04",
    "refactor",      "Code change that neither fixes a bug nor adds a feature",   "1d76db",
    "tests",         "Adding or updating tests",                                  "bfe5bf",
    "documentation", "Documentation related tasks",                               "5319e7",
    "maintenance",   "Maintenance related tasks",                                 "f9d0c4",
    "build",         "Build related tasks",                                       "c2e0c6",
    "cicd",          "CI/CD related tasks",                                       "1d76db",
    "dependencies",  "Dependency related tasks",                                  "0e8a16",
    "bug",           "Bug related tasks",                                         "d73a4a",
    "tools",         "Tool related tasks",                                        "bfe5bf",
    "investigation", "Needs investigation or root-cause analysis",                "e99695"
  )

  usethis::use_github_labels(
    labels = gh_labels$name,
    colours = rlang::set_names(gh_labels$color, gh_labels$name),
    descriptions = rlang::set_names(gh_labels$description, gh_labels$name),
    delete_default = TRUE
  )

})
