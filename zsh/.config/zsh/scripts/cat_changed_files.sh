#!/bin/bash

# Script name: cat_changed_files.sh

# Ignored file types and large files
IGNORED_FILE_TYPES=("*.pbxproj" "package-lock.json" "*.lock" "*.svg" "*.png" "*.jpg" "*.jpeg" "*.gif" "*.ico" "*.woff" "*.woff2" "*.ttf" "*.eot")
MAX_FILE_SIZE_BYTES=$((1024 * 1024))
CONTEXT_LINES=50

print_usage() {
    echo "Usage: $0 [-f] [directory]"
    echo "This script will output the changes of files compared to the remote branch in the Git repository,"
    echo "excluding large files and specific file types."
    echo "Options:"
    echo "  -f    Output full file content instead of diff"
    echo "If no directory is provided, it will use the current directory."
}

FULL_CONTENT=false
DIR="."

while getopts ":fh" opt; do
  case ${opt} in
    f )
      FULL_CONTENT=true
      ;;
    h )
      print_usage
      exit 0
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      print_usage
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

if [ "$1" ]; then
    DIR="$1"
fi

cd "$DIR" || exit 1

if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not a Git repository"
    exit 1
fi

should_ignore_file() {
    local file="$1"
    
    for pattern in "${IGNORED_FILE_TYPES[@]}"; do
        if [[ $file == $pattern ]]; then
            return 0
        fi
    done
    
    if [ -f "$file" ]; then
        local size=$(wc -c < "$file")
        if [ "$size" -gt "$MAX_FILE_SIZE_BYTES" ]; then
            return 0
        fi
    fi
    
    return 1
}

current_branch=$(git rev-parse --abbrev-ref HEAD)

# git diff but with the default diff tool
changed_files=$(git diff --name-only origin/$current_branch --tool=cat)
# changed_files=$(git diff --name-only origin/$current_branch)

if [ -z "$changed_files" ]; then
    echo "No changed files found compared to remote."
    exit 0
fi

while IFS= read -r file; do
    if should_ignore_file "$file"; then
        echo "Ignoring $file (large file or ignored type)"
        continue
    fi
    
    if [ -f "$file" ]; then
        echo "=== Changes in $file ==="
        if [ "$FULL_CONTENT" = true ]; then
            cat "$file"
        else
            git diff -U"$CONTEXT_LINES" --color=always origin/$current_branch -- "$file"
        fi
        echo "=== End of $file ==="
        echo
    else
        echo "Warning: $file does not exist or is not a regular file. Skipping."
    fi
done <<< "$changed_files"
