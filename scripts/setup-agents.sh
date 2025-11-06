#!/bin/bash

# Setup agent files for AI agent prompts in a project
# Usage: ./setup-agents.sh [target-project-path]

# Source common functions
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/common.sh"

# Target project directory (default to current directory)
TARGET_DIR="${1:-$(pwd)}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo -e "${BLUE}Setting up agent files in: ${TARGET_DIR}${NC}"

# Change to target directory
cd "$TARGET_DIR"

# Create .claude directories
mkdir -p .claude/agents

echo -e "\n${BLUE}Syncing agent files...${NC}"

# Clean up old copies first
cleanup_old_copies "$SCRIPT_BASE_DIR/dot_claude/agents" ".claude/agents"

shopt -s nullglob
# Get all agent files from source
for agent_file in "$SCRIPT_BASE_DIR/dot_claude/agents"/*.md; do
    if [ -f "$agent_file" ]; then
        filename=$(basename "$agent_file")
        copy_and_comment "$agent_file" ".claude/agents/$filename" "agents/$filename"
    fi
done
shopt -u nullglob

# List what was set up
echo -e "\n${BLUE}Copied agents:${NC}"
ls -1 .claude/agents/*.md 2>/dev/null | awk '{print "  - " $NF}' | sed 's|.*/||'
