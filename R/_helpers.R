# Helper function to parse YAML and preserve quoted status
parse_yaml_with_quotes <- function(file) {
  # Read in raw data as character vector
  lines <- readLines(file)
  
  # Captures whether a line had single or double quoted strings or not
  is_quoted <- function(line){grepl("^\\s*(?:[^:]+:\\s*[\"'].*[\"']|-+\\s*([\"']).*\\1)\\s*$"
                                    , line)}
  quoted_lines <- sapply(lines, is_quoted)
  
  # The output needs to be cleaned from nested maps and empty lines
  for (el in names(quoted_lines)) {
    # Drop empty lines
    if (grepl("^\\s*$", el)) {
      quoted_lines <- quoted_lines[!(names(quoted_lines) %in% el)]
    }
    # Drop lines that end in a colon (indicating a nested map)
    if (grepl(".*:$", el)) {
      quoted_lines <- quoted_lines[!(names(quoted_lines) %in% el)]
    }
  }
  # Remove names to clean up vector
  names(quoted_lines) <- NULL
  
  # Function to recursively convert parsed YAML list elements from vectors to lists
  convert_to_list <- function(parsed_data) {
    print("Function start")
    for (i in seq_along(parsed_data)) {
      print(paste("Access element:", i))
      el <- parsed_data[[i]]
      if (is.list(el)) {
        # Recurse deeper
        print(paste("Element", i, "is list, recursing"))
        parsed_data[[i]] <- convert_to_list(el)
        print(paste("Returned from recursion"))
      } else if (length(el) > 1) {
        print(paste("Element", i, "is vector, making list"))
        # Not a list, but has length more than one element == vector
        parsed_data[[i]] <- as.list(parsed_data[[i]])
        break
      }
      # In other cases, continue looping
    }
    return(parsed_data)
  }
  
  # Parse the data as YAML and convert unnamed atomic vectors to lists
  parsed_data <- yaml::yaml.load(lines)
  parsed_data <- convert_to_list(parsed_data)
  
  # Because we're using recursion, we need to encapsulate an environment
  # with a counter that persists across recursion levels
  # (This is black magic)
  enc_mark_quoted <- function(parsed_data, quoted_lines) {
    ctr <- 0
    mark_quoted <- function(parsed_data, quoted_lines) {
      # Recursively go through elements in parsed_data and set their "quoted"
      # status to the matching values in quoted_lines
      print(paste("Modifying for quoted_lines element", ctr))
      for (i in seq_along(parsed_data)) {
        print(paste("In loop, parsed_data element", i))
        el <- parsed_data[[i]]
        if (is.list(el) || (is.character(el) && length(el) > 1)) {
          # Recurse into sub-list
          print("Element is list or vector, entering recursion")
          parsed_data[[i]] <- mark_quoted(el, quoted_lines)
          print("Exited recursion")
        } else {
          # Set the attribute for vector elements
          print(paste("Element is scalar, marking quotation status for quoted_lines", ctr))
          attr(parsed_data[[i]], "quoted") <- quoted_lines[ctr]
          ctr <<- ctr + 1
        }
      }
      return(parsed_data)
    }
    return(mark_quoted)
  }
  
  # TODO: Figure out how to instantiate the encapsulated function
  # This would require making sure that parsed_data and quoted_lines are
  # passed through to the underlying function every time...
  
  # OLD, REPLACE WHEN ABOVE TODO IS FIGURED OUT
  # Mark "quoted" attributes
  parsed_data <- mark_quoted(parsed_data, quoted_lines)
  return(parsed_data)
}

# Custom handler to preserve original quoting
character_handler <- function(x) {
  if (!is.null(attr(x, "quoted")) && attr(x, "quoted")) {
    return(sprintf('"%s"', x))  # Add double quotes if originally quoted
  }
  return(x)  # Leave unquoted otherwise
}

# Custom YAML writing function implementing above handlers
write_yaml_with_quotes <- function(data, file) {
  writeLines(
    yaml::as.yaml(
      data,
      handlers = list(
        logical = yaml::verbatim_logical
        )
    ),
    con = file
  )
}