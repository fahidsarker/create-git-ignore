#!/bin/bash

# Define source and working directories
WORKING_DIR="$(pwd)"
cd "$(dirname "$0")"
SOURCE_DIR="$(pwd)"

GITIGNORE_TEMPLATE="$SOURCE_DIR/gitignore-template"
GITIGNORE_FILE="$WORKING_DIR/.gitignore"

# Check if .gitignore file exists
if [ ! -f "$GITIGNORE_FILE" ]; then
  # If .gitignore does not exist, copy the template
  cp "$GITIGNORE_TEMPLATE" "$GITIGNORE_FILE"
  echo ".gitignore created from template."
else
  # If .gitignore exists, check for --merge argument
  if [[ "$*" == *"--merge"* ]]; then
    # Read the existing .gitignore and template files
    existing_lines=$(cat "$GITIGNORE_FILE")
    template_lines=$(cat "$GITIGNORE_TEMPLATE")

    # Initialize a counter for new lines
    new_lines_count=0

    # Loop through each line in the template file
    while IFS= read -r line; do
      # Check if the line does not start with '#' and is not in the existing .gitignore file
      if [[ ! "$line" =~ ^# ]] && ! grep -Fxq "$line" "$GITIGNORE_FILE"; then
        # Append the line to the existing .gitignore file
        echo "$line" >> "$GITIGNORE_FILE"
        ((new_lines_count++))
      fi
    done <<< "$template_lines"

    echo "$new_lines_count new lines inserted into .gitignore."
  else
    # Inform the user that .gitignore already exists
    echo ".gitignore already exists. Use --merge to merge with the template."
  fi
fi