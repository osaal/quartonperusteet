### PRE-RENDER
# Save original file paths
orig_files <-
  fs::dir_ls("src", type = "file", recurse = TRUE)
write.csv(orig_files, "orig_files.csv")

# Move files into top-level
sapply(orig_files, fs::file_move, new_path = ".")
