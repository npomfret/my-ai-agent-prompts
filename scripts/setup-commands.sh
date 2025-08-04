#!/bin/bash

# Setup command symlinks for AI agent prompts in a project
# Usage: ./setup-commands.sh [target-project-path]

# Source common functions
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/common.sh"

# Target project directory (default to current directory)
TARGET_DIR="${1:-$(pwd)}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo -e "${BLUE}Setting up command symlinks in: ${TARGET_DIR}${NC}"

# Change to target directory
cd "$TARGET_DIR"

# Create .claude directories
mkdir -p .claude/commands

echo -e "\n${BLUE}Syncing command files...${NC}"

# Clean up broken symlinks first
cleanup_broken_symlinks ".claude/commands"

# Get all command files from source
for cmd_file in "$SCRIPT_BASE_DIR/commands"/*.md; do
    if [ -f "$cmd_file" ]; then
        filename=$(basename "$cmd_file")
        # Use absolute path for the symlink source to ensure it works
        create_symlink "$cmd_file" ".claude/commands/$filename" "commands/$filename"
    fi
done

# Remove symlinks for commands that no longer exist
if [ -d ".claude/commands" ]; then
    for link in .claude/commands/*.md; do
        if [ -L "$link" ] && [ ! -e "$link" ]; then
            rm "$link"
            echo -e "${YELLOW}  Removed broken symlink: $(basename "$link")${NC}"
        fi
    done
fi

# Update .gitignore with command symlink patterns
echo -e "\n${BLUE}Updating .gitignore with command patterns...${NC}"
patterns=()
if [ -d ".claude/commands" ]; then
    for link in .claude/commands/*.md; do
        if [ -L "$link" ]; then
            patterns+=(".claude/commands/$(basename "$link")")
        fi
    done
fi

if [ ${#patterns[@]} -gt 0 ]; then
    update_gitignore_patterns "${patterns[@]}"
    echo -e "${GREEN}  ✓ Added ${#patterns[@]} command patterns to .gitignore${NC}"
fi

# List what was set up
echo -e "\n${BLUE}Linked commands:${NC}"
ls -la .claude/commands/*.md 2>/dev/null | awk '{print "  - " $NF}' | sed 's|.*/||'