
#  ------------------------------------------------------------------------
#
# Title : Real Estate API OpenAPI/Swagger Specifications
#    By : Jimmy Briggs
#  Date : 2026-11-04
#
#  ------------------------------------------------------------------------

swagger_download_path <- file.path(this.path::this.dir(), "swagger")
if (!dir.exists(swagger_download_path)) dir.create(swagger_download_path, recursive = TRUE, showWarnings = FALSE)

reapi_swagger_url_prod <- "https://api.realestateapi.com/swagger.json"
reapi_swagger_url_staging <- "https://staging.realestateapi.com/swagger.json"

reapi_swagger_file_prod <- file.path(swagger_download_path, "api.realestateapi.com.swagger.json")
reapi_swagger_file_staging <- file.path(swagger_download_path, "staging.realestateapi.com.swagger.json")

download.file(url = reapi_swagger_url_prod, destfile = reapi_swagger_file_prod)
download.file(url = reapi_swagger_url_staging, destfile = reapi_swagger_file_staging)

reapi_convert_url_prod <- glue::glue("https://converter.swagger.io/api/convert/?url={reapi_swagger_url_prod}")
reapi_convert_url_staging <- glue::glue("https://converter.swagger.io/api/convert/?url={reapi_swagger_url_staging}")

reapi_openapi_from_swagger_prod <- yaml::read_yaml(reapi_convert_url_prod, readLines.warn = FALSE)
reapi_openapi_from_swagger_staging <- yaml::read_yaml(reapi_convert_url_staging, readLines.warn = FALSE)

reapi_endpoint_paths <- names(reapi_openapi_from_swagger_prod$paths)
