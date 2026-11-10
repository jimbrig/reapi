
readRenviron(".Renviron")
req_save_file <- file.path(this.path::this.dir(), "requests", "KeyInfo.v2.request.json")
resp_save_file <- file.path(this.path::this.dir(), "responses", "KeyInfo.v2.response.json")

# "Returns details for the API key sent in the x-api-key header: whether it is a test or live key, its API version, the scopes it carries, the endpoints those scopes unlock (availableEndpoints, each with method, path and a short description), the default rate limit, and links to this documentation."
# Free to call and not metered — a quick way to confirm a key works and to find out which endpoints it can use before you integrate.
key_info_request <- httr2::request("https://api.realestateapi.com/v2/key/info") |>
  httr2::req_method("GET") |>
  httr2::req_headers(
    "Accept" = "application/json",
    "Content-Type" = "application/json",
    "X-Api-Key" = Sys.getenv("REAPI_API_KEY"),
    "X-User-Id" = Sys.getenv("REAPI_USER_ID")
  ) |>
  httr2::req_user_agent("reapi/0.0.1")

key_info_request |> httr2::req_get_body() |> jsonlite::write_json(req_save_file, auto_unbox = TRUE, pretty = TRUE)
key_info_response <- httr2::req_perform(key_info_request, path = resp_save_file)
key_info_response_body <- httr2::resp_body_json(key_info_response)
listviewer::jsonedit(key_info_response_body)

# let's try and make a good spec for this response:
tspec_reapi_key_info_response <- tibblify::tspec_row(
  status_code = tibblify::tib_int(.key = "statusCode", .required = TRUE),
  status_message = tibblify::tib_chr(.key = "statusMessage", .required = TRUE),
  data = tibblify::tib_row(
    .key = "data",
    .required = FALSE,
    key_type = tibblify::tib_chr(.key = "keyType", .required = FALSE),
    key_version = tibblify::tib_int(.key = "version", .required = FALSE),
    key_scopes = tibblify::tib_chr_vec(.key = "scopes", .required = FALSE, .input_form = "scalar_list"),
    key_endpoints = tibblify::tib_df(
      .key = "availableEndpoints",
      .required = FALSE,
      scope = tibblify::tib_chr(.key = "scope", .required = FALSE),
      method = tibblify::tib_chr(.key = "method", .required = FALSE),
      path = tibblify::tib_chr(.key = "path", .required = FALSE),
      description = tibblify::tib_chr(.key = "description", .required = FALSE)
    ),
    rate_limit_requests_per_second = tibblify::tib_int(.key = c("rateLimits", "requestsPerSecond"), .required = FALSE),
    rate_limit_note = tibblify::tib_chr(.key = c("rateLimits", "note"), .required = FALSE),
    docs_spec = tibblify::tib_chr(.key = c("documentation", "openApiSpec"), .required = FALSE),
    docs_swagger_ui = tibblify::tib_chr(.key = c("documentation", "swaggerUI"), .required = FALSE),
    docs_website = tibblify::tib_chr(.key = c("documentation", "website"), .required = FALSE)
  )
)

key_info_response_body_tidy <- tibblify::tibblify(key_info_response_body, spec = tspec_reapi_key_info_response)
dplyr::glimpse(key_info_response_body_tidy)
# Rows: 1
# Columns: 3
# $ status_code    <int> 200
# $ status_message <chr> "OK"
# $ data           <tibble[,9]> <tbl_df[1 x 9]>

key_info_response_body_tidy_alt <- tibblify::tibblify(key_info_response_body, spec = tibblify::unpack_tspec(tspec_reapi_key_info_response))
dplyr::glimpse(key_info_response_body_tidy_alt)
# Rows: 1
# Columns: 11
# $ status_code                    <int> 200
# $ status_message                 <chr> "OK"
# $ key_type                       <chr> "test"
# $ key_version                    <int> 2
# $ key_scopes                     <list<chr>> <"AddressVerification", "AutoComplete", "PropertyAvm", "PropertyComps", "PropertyDetail", "PropertyMapping", "PropertyParcel", "Property…
# $ key_endpoints                  <list<tibble[,4]>> [<tbl_df[9 x 4]>]
# $ rate_limit_requests_per_second <int> 60
# $ rate_limit_note                <chr> "Default rate limit. Some endpoints may have lower limits."
# $ docs_spec                      <chr> "/swagger.json"
# $ docs_swagger_ui                <chr> "/swagger"
# $ docs_website                   <chr> "https://realestateapi.com/docs"

# the unpacked is probably better

key_info_response_endpoints <- key_info_response_body_tidy_alt$key_endpoints[[1]]
dplyr::glimpse(key_info_response_endpoints)
# Rows: 9
# Columns: 4
# $ scope       <chr> "AddressVerification", "AutoComplete", "PropertyAvm", "PropertyComps", "PropertyDetail", "PropertyMapping", "PropertySearch", "PropGPT", "SkipTrace"
# $ method      <chr> "POST", "POST", "POST", "POST", "POST", "POST", "POST", "POST", "POST"
# $ path        <chr> "/v2/AddressVerification", "/v2/AutoComplete", "/v2/PropertyAvm", "/v2/PropertyComps", "/v2/PropertyDetail", "/v2/PropertyMapping", "/v2/PropertySearch", "…
# $ description <chr> "Bulk address matching", "Search suggestions for addresses, cities, zips", "Get automated property valuation", "Find comparable properties and AVM", "Get d…

key_info_response_scopes <- key_info_response_body_tidy_alt$key_scopes[[1]]
key_info_response_scopes
# [1] "AddressVerification"    "AutoComplete"           "PropertyAvm"            "PropertyComps"          "PropertyDetail"         "PropertyMapping"
# [7] "PropertyParcel"         "PropertyPortfolio"      "PropertySearch"         "PropertySearch:Summary" "PropGPT"                "SkipTrace"
