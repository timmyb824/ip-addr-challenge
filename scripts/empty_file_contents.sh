#!/usr/bin/env bash

# remove contents of app.json log file before commit - Tim B.
# Function to check if a file is empty
is_file_empty() {
  if [ ! -s "$1" ]; then
    return 0
  else
    return 1
  fi
}

# Path to the file you want to check and remove contents from
file_path="./logs/app.json"

# Check if the file is not empty
if is_file_empty "$file_path"; then
  echo "The file is empty. No action needed."
else
  echo "Emptying the file $file_path..."
  # Empty the file
  cat /dev/null > "$file_path"
  # Add a placeholder to the emptied file
  echo "## LOGS" > "$file_path"
  git add "$file_path"
fi

# Continue with the rest of the pre-commit checks
exit 0
