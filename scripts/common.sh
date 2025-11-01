#!/bin/bash

# Common functions and variables for AI agent setup scripts

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where the scripts are located (parent of scripts/)
SCRIPT_BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Target project directory (can be overridden by scripts)
TARGET_DIR="${TARGET_DIR:-$(pwd)}"

# Function to create a symlink with proper error handling
create_symlink() {
    local source="$1"
    local target="$2"
    local description="$3"
    
    # Remove existing symlink or file if it exists
    if [ -L "$target" ]; then
        rm "$target"
        echo -e "${YELLOW}  Removed existing symlink: $description${NC}"
    elif [ -e "$target" ]; then
        echo -e "${RED}  Warning: $target exists and is not a symlink. Skipping.${NC}"
        return 1
    fi
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"
    
    # Create the symlink
    ln -sf "$source" "$target"
    echo -e "${GREEN}  ✓ Created symlink: $description${NC}"
}

# Function to clean up broken symlinks
cleanup_broken_symlinks() {
    local dir="$1"
    if [ -d "$dir" ]; then
        find "$dir" -type l ! -exec test -e {} \; -delete 2>/dev/null || true
    fi
}


# Function to calculate relative path between two absolute paths
# Works on macOS without GNU coreutils
calculate_relative_path() {
    local source="$1"
    local target="$2"
    
    # Get the canonical absolute paths
    source="$(cd "$(dirname "$source")" && pwd)/$(basename "$source")"
    target="$(cd "$(dirname "$target")" && pwd)/$(basename "$target")"
    
    # Remove common prefix
    local common_part="$source"
    local result=""
    
    while [ "${target#$common_part}" = "$target" ]; do
        common_part="$(dirname "$common_part")"
        if [ -z "$result" ]; then
            result=".."
        else
            result="../$result"
        fi
    done
    
    if [ "$common_part" = "/" ]; then
        result="$result$target"
    else
        result="$result${target#$common_part/}"
    fi
    
    echo "$result"
}