### POST-RENDER
# Find .qmd files to move back into original paths
print("Started post-render script")
moved_files <-
  fs::dir_ls(type = "file") |>
  grep("^(?!index\\.qmd$).+\\.qmd$", x = _, perl = TRUE, value = TRUE)
print("Found all moved files")

# Move files into original paths
orig_paths <- read.csv("orig_files.csv")[,1]
print("Read in original file paths")
print(paste0("Original files: ", orig_paths))
print(paste0("Moved files: ", moved_files))
lapply(
  moved_files,
  function(file) {
    fs::file_move(
      file,
      grep(
        paste0("*", file),
        orig_paths,
        value = TRUE
      ))
  })