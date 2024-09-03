#!/bin/bash

# Set the directory containing the diff files
DIFF_DIR="diffs"

# Function to print usage
print_usage() {
    echo "Usage: $0 [output_file]"
    echo "This script will combine all .diff files in the $DIFF_DIR directory."
    echo "If no output file is specified, it will use 'combined.diff' in the current directory."
}

# Check if help is requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

# Set the output file
OUTPUT_FILE=${1:-combined.diff}

# Check if the diffs directory exists
if [ ! -d "$DIFF_DIR" ]; then
    echo "Error: $DIFF_DIR directory not found."
    exit 1
fi

# Combine all .diff files
find "$DIFF_DIR" -name "*.diff" -print0 | xargs -0 cat > "$OUTPUT_FILE"

echo "All diff files have been combined into $OUTPUT_FILE"
