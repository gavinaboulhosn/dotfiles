#!/bin/bash

# Function to print usage
print_usage() {
    echo "Usage: $0 [file1] [file2] ..."
    echo "This script will output the content of specified files."
}

# Check if help is requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

# check for directory, then perform cat on all _git_ tracked files in the directory
# usage: ./cat_files.sh --dir ./path/to/dir
if [[ "$1" == "--dir" ]]; then
    git ls-files | rg -v ".(png|jpg|jpeg|gif|svg)" | xargs $0
    exit 0
fi


# # Check if files are provided
# if [ $# -eq 0 ]; then
#     echo "No files specified."
#     print_usage
#     exit 1
# fi

# Loop through all provided files
for file in "$@"; do
    if [ -f "$file" ]; then
        echo "=== Content of $file ==="
        cat "$file"
        echo "=== End of $file ==="
        echo
    else
        echo "Warning: $file does not exist or is not a regular file. Skipping."
    fi
done
