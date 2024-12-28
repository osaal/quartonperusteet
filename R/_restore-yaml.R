### Remove all chapters except "index.qmd" from _quarto.yml
source("R/_helpers.R")
# Load the _quarto.yml file
quarto_file <- "_quarto.yml"
quarto_data <- parse_yaml_with_quotes(quarto_file)

# Load the chapters.yml file
chapters_file <- "_chapters.yml"
chapters_data <- parse_yaml_with_quotes(chapters_file)

# Replace "chapters" with just "index.qmd"
quarto_data$book$chapters <- list("index.qmd")
# Remove "appendices" entirely
quarto_data$book <- quarto_data$book[names(quarto_data$book) != "appendices"]

# Write the updated data back to _quarto.yml
write_yaml(quarto_data, quarto_file)