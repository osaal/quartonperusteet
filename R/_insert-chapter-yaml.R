### Ensure that R/_helpers.R is sourced first, as it provides some functions
source("R/_helpers.R")

# Load the _quarto.yml file
quarto_file <- "_quarto.yml"
quarto_data <- parse_yaml_with_quotes(quarto_file)

# Load the chapters.yml file
chapters_file <- "_chapters.yml"
chapters_data <- parse_yaml_with_quotes(chapters_file)

# Ensure "book" exists in _quarto.yml
if (!"book" %in% names(quarto_data)) {
  quarto_data$book <- list()
}

# Retain `index.qmd` if it exists in the current chapters
existing_chapters <- quarto_data$book$chapters
if (!is.null(existing_chapters) && "index.qmd" %in% existing_chapters) {
  index <- list("index.qmd")
} else {
  index <- list()
}

# Merge `index.qmd` with new chapters from chapters.yml
new_chapters <- chapters_data$chapters
quarto_data$book$chapters <- c(index, new_chapters)

# Add appendices if they exist in chapters.yml
if ("appendices" %in% names(chapters_data)) {
  quarto_data$book$appendices <- chapters_data$appendices
}

# Write the updated data back to _quarto.yml
# TODO: Currently, even after all the fixes, this function as well as write_yaml
# actually double-quotes *every* line (except logicals if handled)...
# wtaf.
write_yaml_with_quotes(quarto_data, "test.yml")
