#!/bin/bash

# Script name: cat_changed_files.sh

# Function to print usage
print_usage() {
    echo "Usage: $0 [directory]"
    echo "This script will output the full content of all files with local changes in the Git repository."
    echo "If no directory is provided, it will use the current directory."
}

# Check if help is requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

# Set the directory
DIR=${1:-.}

# Change to the specified directory
cd "$DIR" || exit 1

# Check if we're in a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not a Git repository"
    exit 1
fi

# Get list of changed files (both staged and unstaged)
changed_files=$(git status --porcelain | awk '{print $2}')

# Check if there are any changed files
if [ -z "$changed_files" ]; then
    echo "No changed files found."
    exit 0
fi

# Loop through each changed file
while IFS= read -r file; do
    if [ -f "$file" ]; then
        echo "=== Content of $file ==="
        cat "$file"
        echo "=== End of $file ==="
        echo
    else
        echo "Warning: $file does not exist or is not a regular file. Skipping."
    fi
done <<< "$changed_files"
