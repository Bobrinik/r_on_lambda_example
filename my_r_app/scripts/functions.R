# functions.R
library(httr)
library(jsonlite)
library(logger)

# Function to handle_event
handle_event <- function(event) {
  log_info("Processing event")

  # Example processing: concatenate key-value pairs into a single string
  result <- paste(names(event), unlist(event), collapse = "; ")

  log_info("Processing complete")
  return(result)
}