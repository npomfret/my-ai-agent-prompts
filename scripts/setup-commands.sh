#!/bin/bash

# Setup command files for AI agent prompts in a project
# Usage: ./setup-commands.sh [target-project-path]

# Source common functions
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/common.sh"

# Target project directory (default to current directory)
TARGET_DIR="${1:-$(pwd)}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo -e "${BLUE}Setting up command files in: ${TARGET_DIR}${NC}"

# Change to target directory
cd "$TARGET_DIR"

# Create .claude directories
mkdir -p .claude/commands

echo -e "\n${BLUE}Syncing command files...${NC}"

# Clean up old copies first
cleanup_old_copies "$SCRIPT_BASE_DIR/dot_claude/commands" ".claude/commands"

shopt -s nullglob
# Get all command files from source
for cmd_file in "$SCRIPT_BASE_DIR/dot_claude/commands"/*.md; do
    if [ -f "$cmd_file" ]; then
        filename=$(basename "$cmd_file")
        copy_and_comment "$cmd_file" ".claude/commands/$filename" "commands/$filename"
    fi
done
shopt -u nullglob

# List what was set up
echo -e "\n${BLUE}Copied commands:${NC}"
ls -1 .claude/commands/*.md 2>/dev/null | awk '{print "  - " $NF}' | sed 's|.*/||'
