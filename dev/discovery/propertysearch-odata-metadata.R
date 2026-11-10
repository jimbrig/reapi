
readRenviron(".Renviron")
req_save_file <- file.path(this.path::this.dir(), "requests", "PropertySearch.OData.metadata.v2.request.json")
resp_save_file <- file.path(this.path::this.dir(), "responses", "PropertySearch.OData.metadata.v2.response.xml")

# "Get the OData v4 metadata (CSDL) for the PropertySearch entity set"
# "Returns the CSDL XML (application/xml) describing the PropertySearch entity type — every field, its type and its nesting — which OData clients read to discover the schema and build queries. Not metered."
# ^ not sure what "CSDL" stands for
search_odata_metadata_request <- httr2::request("https://api.realestateapi.com/v2/PropertySearch/odata/$metadata") |>
  httr2::req_method("GET") |>
  httr2::req_headers(
    "X-Api-Key" = Sys.getenv("REAPI_API_KEY"),
    "X-User-Id" = Sys.getenv("REAPI_USER_ID")
  ) |>
  httr2::req_user_agent("reapi/0.0.1")

search_odata_metadata_request |> httr2::req_get_body() |> jsonlite::write_json(req_save_file, auto_unbox = TRUE, pretty = TRUE)
# no request body, so not necessary...

search_odata_metadata_response <- httr2::req_perform(search_odata_metadata_request, path = resp_save_file)
httr2::resp_content_type(search_odata_metadata_response)
# application/xml
search_odata_metadata_response_body_xml <- httr2::resp_body_xml(search_odata_metadata_response)
# search_odata_metadata_response_body <- xml2::xml_

# now i need to figure out how this can be parsed properly into an R structure
# and whether it is something that can provide utility or value or not with
# regard to the /v2/PropertySearch/odata & new /v2/PropertySearch/odata/PropertySearch
# endpoints

# regarding /v2/PropertySearch/odata (already has prior implementation in landrise.reapi also):
# "Query property data with OData v4 query options"
# "OData v4 front end to /v2/PropertySearch for standard OData and RESO tooling (Power BI, Excel, RESO Web API clients). Filter with $filter (e.g. address/city eq 'Austin'), page with $top (up to 1,000) and $skip, sort with $orderby, project fields with $select, and add $count=true for the total."
# "With no query options at all, returns the OData service document instead of data. Requires the PropertySearch scope; data pages are metered, the service document is not."
# with params:
# $filter, $top, $skip, $orderby, $select, $count, $format

# regarding /v2/PropertySearch/odata/PropertySearch:
# "Query the OData v4 PropertySearch entity set"
# "The canonical entity-set URL that strict OData clients resolve from the service document. Accepts the same query options and returns the same results as /v2/PropertySearch/odata."
# and has params:
# $filter, $top, $skip, $orderby, $select, $count, $format
