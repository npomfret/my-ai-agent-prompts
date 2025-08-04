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

# Function to manage AI agents section in .gitignore
update_gitignore_patterns() {
    local patterns=("$@")
    local temp_file=".gitignore.tmp"
    local ai_section_header="# AI agents stuff"
    
    if [ ${#patterns[@]} -eq 0 ]; then
        return
    fi
    
    # Read existing .gitignore if it exists, excluding AI agent patterns
    if [ -f .gitignore ]; then
        # Get existing patterns that aren't AI-related
        awk -v header="$ai_section_header" '
            BEGIN { in_ai_section = 0; }
            $0 == header { in_ai_section = 1; next; }
            in_ai_section && /^[[:space:]]*$/ { in_ai_section = 0; }
            in_ai_section { next; }
            /^CLAUDE\.md$/ { next; }
            /^GEMINI\.md$/ { next; }
            /^directives$/ { next; }
            /^\.mcp\.local\.json$/ { next; }
            /^\.claude\/commands\// { next; }
            /^\.claude\/agents\// { next; }
            { print }
        ' .gitignore > "$temp_file"
        
        # Ensure file ends with newline
        if [ -s "$temp_file" ] && [ -n "$(tail -c 1 "$temp_file")" ]; then
            echo "" >> "$temp_file"
        fi
    else
        touch "$temp_file"
    fi
    
    # Get all existing AI patterns from the current .gitignore
    local existing_patterns=()
    if [ -f .gitignore ]; then
        # Extract existing AI patterns and store them
        while IFS= read -r line; do
            existing_patterns+=("$line")
        done < <(awk -v header="$ai_section_header" '
            BEGIN { in_ai_section = 0; }
            $0 == header { in_ai_section = 1; next; }
            in_ai_section && /^[[:space:]]*$/ { in_ai_section = 0; next; }
            in_ai_section { print; next; }
            /^CLAUDE\.md$/ { print; }
            /^GEMINI\.md$/ { print; }
            /^directives$/ { print; }
            /^\.mcp\.local\.json$/ { print; }
            /^\.claude\/commands\// { print; }
            /^\.claude\/agents\// { print; }
        ' .gitignore)
    fi
    
    # Add new patterns to existing ones
    for pattern in "${patterns[@]}"; do
        local found=0
        for existing in "${existing_patterns[@]}"; do
            if [ "$pattern" = "$existing" ]; then
                found=1
                break
            fi
        done
        if [ $found -eq 0 ]; then
            existing_patterns+=("$pattern")
        fi
    done
    
    # Add AI agents section at the bottom
    echo "$ai_section_header" >> "$temp_file"
    for pattern in "${existing_patterns[@]}"; do
        echo "$pattern" >> "$temp_file"
    done
    
    # Replace original file
    mv "$temp_file" .gitignore
}

# Function to get all symlink patterns for gitignore
get_symlink_gitignore_patterns() {
    local dir="$1"
    local patterns=()
    
    if [ -d "$dir" ]; then
        for link in "$dir"/*.md; do
            if [ -L "$link" ]; then
                patterns+=("$dir/$(basename "$link")")
            fi
        done
    fi
    
    echo "${patterns[@]}"
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