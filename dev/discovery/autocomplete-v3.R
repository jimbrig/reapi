
readRenviron(".Renviron")
req_save_file <- file.path(this.path::this.dir(), "requests", "AutoComplete.v3.address.request.json")
resp_save_file <- file.path(this.path::this.dir(), "responses", "AutoComplete.v3.address.response.json")

ip_geolocation <- ipapi::geolocate(NA) |> tibble::as_tibble()

autocomplete_v3_request <- httr2::request("https://api.realestateapi.com/v3/AutoComplete") |>
  httr2::req_method("POST") |>
  httr2::req_headers(
    "Accept" = "application/json",
    "Content-Type" = "application/json",
    "X-Api-Key" = Sys.getenv("REAPI_API_KEY_PUBLIC"),
    "X-User-Id" = Sys.getenv("REAPI_USER_ID")
  ) |>
  httr2::req_user_agent("reapi/0.0.1") |>
  httr2::req_body_json(
    data = list(
      search = "2025 Peach",
      search_types = "A",
      latitude = ip_geolocation$lat,
      longitude = ip_geolocation$lon,
      precision = 10L
    )
  )

autocomplete_v3_request |> httr2::req_get_body() |> jsonlite::write_json(req_save_file, auto_unbox = TRUE, pretty = TRUE)

# saving directly to a file to be sure that JSON parsing is not manipulated by R first...
autocomplete_v3_response <- httr2::req_perform(autocomplete_v3_request, path = resp_save_file)
jsonlite::prettify(readLines(resp_save_file)) |> cat(file = resp_save_file)
# prettifying should not have affected the JSON structure at all..

autocomplete_v3_response_body <- httr2::resp_body_json(autocomplete_v3_response)

# listviewer makes it seem like all of the nulls are empty arrays ([]), but im not sure
# whether they actually are or not... it could be various possible places affecting this also, i.e.
# jsonlite does not provide a "null" argument for the fromJSON function, only toJSON,
# so potentially the JSON null's in the response become "[]" boxes which in turn are
# list()'s in R?
listviewer::jsonedit(autocomplete_v3_response_body)

autocomplete_v3_response_body$data[[1]]
# $searchType
# [1] "A"
# $publicId
# [1] 171565024
# $listingId
# NULL
# $buildingDpbcs
# NULL
# $unitDpbcs
# NULL
# $mlsNumber
# NULL
# $mlsBoardCode
# NULL
# $boardName
# NULL
# $address
# [1] "2025 Peachtree Rd NE, Atlanta, GA, 30309"
# $house
# [1] "2025"
# $street
# [1] "Peachtree Rd  NE"
# $unit
# NULL
# $city
# [1] "Atlanta"
# $county
# [1] "Fulton County"
# $countyId
# [1] "121"
# $state
# [1] "GA"
# $stateId
# [1] "13"
# $stateName
# NULL
# $zip
# [1] "30309"
# $fips
# [1] "13121"
# $latitude
# [1] 33.80965
# $longitude
# [1] -84.39143
# $location
# [1] "POINT(-84.391432 33.809653)"
# $title
# [1] "2025 Peachtree Rd NE, Atlanta, GA, 30309"
# $apn
# NULL

# looks like they are NULL, not list()

# however, if i did not save directly to disk in the req_perform(), and instead
# serialied to a JSON file manually afterwards via something like:
# httr2::resp_body_json(autocomplete_v3_response) |> jsonlite::write_json(resp_save_file, auto_unbox = TRUE, pretty = TRUE)
# then that JSON file's values for the response's JSON null's become {}...

# so there's JSON nulls, []s, and {}s all at play and different tools/parsers do different things... so annoying
# in R, JSON nulls should become R NULL, JSON []s should become list(), and JSON {} should become either a named list or c(), i think?
# lets check

NULL |> jsonlite::toJSON(null = "list")
# {}
NULL |> jsonlite::toJSON(null = "null")
# null
list(NULL) |> jsonlite::toJSON(null = "list")
# [{}]
list(NULL) |> jsonlite::toJSON(null = "null")
# [null]

"null" |> jsonlite::fromJSON(simplifyVector = FALSE)
# NULL
"{}" |> jsonlite::fromJSON(simplifyVector = FALSE)
# named list()
"[]" |> jsonlite::fromJSON(simplifyVector = FALSE)
# list()
"[null]" |> jsonlite::fromJSON(simplifyVector = FALSE)
# [[1]]
# NULL

structure(list(), names = character(0)) |> jsonlite::toJSON()
# {}
c() |> jsonlite::toJSON()
# {}


