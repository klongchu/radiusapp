#!/bin/bash

# Loop through all directories recursively
find . -type d | while read dir; do
  # Check if the directory is empty
  if [ -z "$(ls -A "$dir")" ]; then
    # Add a .gitkeep file to the empty directory
    touch "$dir/.gitkeep"
    echo "Added .gitkeep to $dir"
  fi
done

