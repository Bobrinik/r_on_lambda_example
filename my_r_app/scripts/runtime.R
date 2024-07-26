# Inspired by:
# https://github.com/aws/aws-lambda-nodejs-runtime-interface-client/blob/main/src/rapid-client.cc
# https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html
library(httr)
library(jsonlite)
source('/var/task/functions.R')

endpoint <- Sys.getenv("AWS_LAMBDA_RUNTIME_API")
if (endpoint == "") {
  stop("AWS_LAMBDA_RUNTIME_API environment variable is not set.")
}

# Function to get the next invocation
get_next <- function() {
  url <- paste0("http://", endpoint, "/2018-06-01/runtime/invocation/next")
  response <- GET(url)

  if (response$status_code != 200) {
    stop("Failed to get next invocation, error ", response$status_code)
  }
  response
}

# Function to post success response
post_success <- function(request_id, response_body) {
  url <- paste0("http://", endpoint, "/2018-06-01/runtime/invocation/", request_id, "/response")
  POST(url, body = toJSON(response_body), encode = "json")
}

# Function to post error response
post_error <- function(request_id, error_message, xray_error) {
  url <- paste0("http://", endpoint, "/2018-06-01/runtime/invocation/", request_id, "/error")
  error_body <- list(
    errorMessage = error_message,
    errorType = "Runtime.Error",
    xrayError = xray_error
  )
  POST(url, body = toJSON(error_body), encode = "json")
}

while (TRUE) {
  tryCatch({
    invocation <- get_next()
    request_id <- invocation$headers$`lambda-runtime-aws-request-id`

    data <- content(invocation, "parsed")

    # Process the request (replace with your actual logic)
    result <- handle_event(data)

    response_body <- list(message = result)
    result <- post_success(request_id, response_body)

    quit(save = "no", status = 0, runLast = FALSE)
  }, error = function(e) {
    post_error(request_id, e$message, "failed")
    quit(save = "no", status = 1, runLast = FALSE)
  })
}