#!/bin/bash

# Setup agent symlinks for AI agent prompts in a project
# Usage: ./setup-agents.sh [target-project-path]

# Source common functions
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/common.sh"

# Target project directory (default to current directory)
TARGET_DIR="${1:-$(pwd)}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo -e "${BLUE}Setting up agent symlinks in: ${TARGET_DIR}${NC}"

# Change to target directory
cd "$TARGET_DIR"

# Create .claude directories
mkdir -p .claude/agents

echo -e "\n${BLUE}Syncing agent files...${NC}"

# Clean up broken symlinks first
cleanup_broken_symlinks ".claude/agents"

# Get all agent files from source
for agent_file in "$SCRIPT_BASE_DIR/dot_claude/agents"/*.md; do
    if [ -f "$agent_file" ]; then
        filename=$(basename "$agent_file")
        # Use absolute path for the symlink source to ensure it works
        create_symlink "$agent_file" ".claude/agents/$filename" "agents/$filename"
    fi
done

# Remove symlinks for agents that no longer exist
if [ -d ".claude/agents" ]; then
    for link in .claude/agents/*.md; do
        if [ -L "$link" ] && [ ! -e "$link" ]; then
            rm "$link"
            echo -e "${YELLOW}  Removed broken symlink: $(basename "$link")${NC}"
        fi
    done
fi

# Update .gitignore with agent symlink patterns
echo -e "\n${BLUE}Updating .gitignore with agent patterns...${NC}"
patterns=()
if [ -d ".claude/agents" ]; then
    for link in .claude/agents/*.md; do
        if [ -L "$link" ]; then
            patterns+=(".claude/agents/$(basename "$link")")
        fi
    done
fi

if [ ${#patterns[@]} -gt 0 ]; then
    update_gitignore_patterns "${patterns[@]}"
    echo -e "${GREEN}  ✓ Added ${#patterns[@]} agent patterns to .gitignore${NC}"
fi

# Also add the inventory symlink to gitignore
update_gitignore_patterns ".claude/agent-inventory.json"

# Symlink agent inventory file
setup_agent_inventory() {
    local source_inventory="$SCRIPT_BASE_DIR/dot_claude/agent-inventory.json"
    local target_inventory=".claude/agent-inventory.json"
    
    create_symlink "$source_inventory" "$target_inventory" "agent-inventory.json"
}

# Setup agent inventory
echo -e "\n${BLUE}Setting up agent inventory...${NC}"
setup_agent_inventory

# Note: agent-inventory.json is now a symlink and is in .gitignore, so we don't add it to git

# List what was set up
echo -e "\n${BLUE}Linked agents:${NC}"
ls -la .claude/agents/*.md 2>/dev/null | awk '{print "  - " $NF}' | sed 's|.*/||'