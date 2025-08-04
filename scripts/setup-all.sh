#!/bin/bash

# Unified setup script for AI agent prompts in a project
# Usage: ./setup-all.sh [target-project-path]

# Source common functions
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/common.sh"

# Target project directory (default to current directory)
TARGET_DIR="${1:-$(pwd)}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo -e "${BLUE}Setting up AI agent symlinks in: ${TARGET_DIR}${NC}"

# Change to target directory
cd "$TARGET_DIR"

# Function to merge settings.json
merge_settings_json() {
    local source_settings="$SCRIPT_BASE_DIR/dot_claude/settings.json"
    local target_settings=".claude/settings.json"
    
    # Check if source settings exists
    if [ ! -f "$source_settings" ]; then
        echo -e "${YELLOW}  No source settings.json found in template${NC}"
        return
    fi
    
    # If target doesn't exist, just copy it
    if [ ! -f "$target_settings" ]; then
        cp "$source_settings" "$target_settings"
        echo -e "${GREEN}  ✓ Created .claude/settings.json from template${NC}"
        return
    fi
    
    # Both files exist, merge them using jq if available
    if command -v jq &> /dev/null; then
        # Create a temporary file for the merged result
        local temp_file=".claude/settings.json.tmp"
        
        # Merge the JSON files, with target taking precedence
        jq -s '
            # Get source and target as variables
            .[0] as $source | .[1] as $target |
            
            # Start with target and merge permissions only
            $target |
            .permissions.allow = (($source.permissions.allow // []) + ($target.permissions.allow // []) | unique | sort) |
            .permissions.deny = (($source.permissions.deny // []) + ($target.permissions.deny // []) | unique | sort)
        ' "$source_settings" "$target_settings" > "$temp_file"
        
        # Replace the target file
        mv "$temp_file" "$target_settings"
        echo -e "${GREEN}  ✓ Merged settings.json (combined permissions from both files)${NC}"
    else
        echo -e "${YELLOW}  Warning: jq not installed. Cannot merge settings.json automatically.${NC}"
        echo -e "${YELLOW}  Please manually merge settings from:${NC}"
        echo -e "${YELLOW}    $source_settings${NC}"
        echo -e "${YELLOW}  Into your project's .claude/settings.json${NC}"
    fi
}

echo -e "\n${BLUE}1. Setting up AI_AGENT.md and related files...${NC}"

# Create AI_AGENT.md if it doesn't exist
if [ ! -f "AI_AGENT.md" ]; then
    # Check if template exists
    if [ -f "$SCRIPT_BASE_DIR/AI_AGENT.template.md" ]; then
        cp "$SCRIPT_BASE_DIR/AI_AGENT.template.md" "AI_AGENT.md"
        echo -e "${GREEN}  ✓ Created AI_AGENT.md from template${NC}"
    else
        # Create a basic AI_AGENT.md
        cat > AI_AGENT.md << 'EOF'
# AI Agent Configuration

This file contains common configuration and directives for AI agents (Claude and Gemini).

## Project Context

[Add your project-specific context here]

## Key Principles

[Add your key principles here]

## Available Agents

See `.claude/agents/` for specialized enforcement agents.

## Commands

See `.claude/commands/` for available commands.
EOF
        echo -e "${GREEN}  ✓ Created basic AI_AGENT.md${NC}"
    fi
else
    echo -e "${BLUE}  AI_AGENT.md already exists${NC}"
fi

# Create symlinks to CLAUDE.md and GEMINI.md
create_symlink "AI_AGENT.md" "CLAUDE.md" "CLAUDE.md -> AI_AGENT.md"
create_symlink "AI_AGENT.md" "GEMINI.md" "GEMINI.md -> AI_AGENT.md"

# Update .gitignore with base patterns
update_gitignore_patterns "CLAUDE.md" "GEMINI.md" "directives"

echo -e "\n${BLUE}2. Setting up .claude directory structure...${NC}"

# Create .claude directories
mkdir -p .claude/commands
mkdir -p .claude/agents

# Run the individual setup scripts
echo -e "\n${BLUE}3. Setting up command symlinks...${NC}"
"$SCRIPT_DIR/setup-commands.sh" "$TARGET_DIR"

echo -e "\n${BLUE}4. Setting up agent symlinks...${NC}"
"$SCRIPT_DIR/setup-agents.sh" "$TARGET_DIR"

echo -e "\n${BLUE}5. Setting up .claude/settings.json...${NC}"
merge_settings_json

echo -e "\n${BLUE}6. Setting up MCP servers...${NC}"
"$SCRIPT_DIR/setup-mcp.sh" "$TARGET_DIR"

# Final summary
echo -e "\n${GREEN}✅ Setup complete!${NC}"
echo -e "\n${BLUE}Summary:${NC}"
echo "  - AI_AGENT.md is the source file for both CLAUDE.md and GEMINI.md"
echo "  - Command symlinks in: .claude/commands/"
echo "  - Agent symlinks in: .claude/agents/"
echo "  - Settings merged into: .claude/settings.json"
echo "  - MCP servers configured in: .mcp.json"
echo "  - All symlinks and .mcp.local.json added to .gitignore"
echo -e "\n${YELLOW}Remember to use '/p' before every request for intelligent tool selection!${NC}"