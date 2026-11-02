# Real Estate API Request Modifiers

These functions modify the
[`httr2::request()`](https://httr2.r-lib.org/reference/request.html)
object to add various features such as endpoints, authentication, user
agent, body, error handling, retry logic, throttling, logging, caching,
and file saving.

Functions:

- `reapi_req_auth()`: Adds authentication headers to the request.

- `reapi_req_user_agent()`: Sets the user agent for the request.

- `reapi_req_endpoint()`: Adds an endpoint to the request URL.

- `reapi_req_body()`: Sets the body of the request to a JSON object.

- `reapi_req_validate()`: Validates the request body against the
  specified endpoint's parameters.

- `reapi_req_error()`: Sets up ReAPI-specific error handling for the
  request.

- `reapi_req_retry()`: Retries the request if it fails due to transient
  errors.

- `reapi_req_throttle()`: Applies throttling to the request.

- `reapi_req_logger()`: Attaches a logger to the request object for
  logging request details.

- `reapi_req_cache()`: Attaches a custom cache feature to the request
  object for caching responses.

- `reapi_req_cache_key()`: Derives a cache key for the request based on
  its hash and endpoint that is

- `reapi_req_hash()`: Generates a hash for the request based on its
  components.

- `reapi_req_file()`: Generates a file name for saving the request to
  disk.

- `reapi_req_resp_file()`: Generates a file name for saving the response
  to disk.
