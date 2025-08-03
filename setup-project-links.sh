#!/bin/bash

# Setup symlinks for AI agent prompts in a project
# Usage: ./setup-project-links.sh [target-project-path]
# If no path provided, uses current directory

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Target project directory (default to current directory)
TARGET_DIR="${1:-$(pwd)}"

# Convert to absolute path
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo -e "${BLUE}Setting up AI agent symlinks in: ${TARGET_DIR}${NC}"

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

# Change to target directory
cd "$TARGET_DIR"

echo -e "\n${BLUE}1. Setting up AI_AGENT.md and related files...${NC}"

# Create AI_AGENT.md if it doesn't exist
if [ ! -f "AI_AGENT.md" ]; then
    # Check if template exists
    if [ -f "$SCRIPT_DIR/AI_AGENT.template.md" ]; then
        cp "$SCRIPT_DIR/AI_AGENT.template.md" "AI_AGENT.md"
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

echo -e "\n${BLUE}2. Setting up .claude directory structure...${NC}"

# Create .claude directories
mkdir -p .claude/commands
mkdir -p .claude/agents

echo -e "\n${BLUE}3. Syncing command files...${NC}"

# Clean up broken symlinks first
cleanup_broken_symlinks ".claude/commands"

# Get all command files from source
for cmd_file in "$SCRIPT_DIR/commands"/*.md; do
    if [ -f "$cmd_file" ]; then
        filename=$(basename "$cmd_file")
        relative_path="../../../my-ai-agent-prompts/commands/$filename"
        create_symlink "$relative_path" ".claude/commands/$filename" "commands/$filename"
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

echo -e "\n${BLUE}4. Syncing agent files...${NC}"

# Clean up broken symlinks first
cleanup_broken_symlinks ".claude/agents"

# Get all agent files from source
for agent_file in "$SCRIPT_DIR/.claude/agents"/*.md; do
    if [ -f "$agent_file" ]; then
        filename=$(basename "$agent_file")
        relative_path="../../../my-ai-agent-prompts/.claude/agents/$filename"
        create_symlink "$relative_path" ".claude/agents/$filename" "agents/$filename"
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

echo -e "\n${BLUE}5. Setting up .claude/settings.json...${NC}"

# Function to merge settings.json
merge_settings_json() {
    local source_settings="$SCRIPT_DIR/.claude/settings.json"
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
        jq -s '.[0] * .[1] | 
            .permissions.allow = (
                (.[0].permissions.allow // []) + (.[1].permissions.allow // []) 
                | unique | sort
            ) |
            .permissions.deny = (
                (.[0].permissions.deny // []) + (.[1].permissions.deny // [])
                | unique | sort
            )' "$source_settings" "$target_settings" > "$temp_file"
        
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

# Merge settings.json files
merge_settings_json

echo -e "\n${BLUE}6. Updating .gitignore...${NC}"

# Function to manage AI agents section in .gitignore
update_gitignore_ai_section() {
    local temp_file=".gitignore.tmp"
    local ai_section_header="# AI agents stuff"
    local patterns_to_add=()
    
    # Collect all patterns we need
    patterns_to_add+=("CLAUDE.md")
    patterns_to_add+=("GEMINI.md")
    patterns_to_add+=("directives")
    
    # Add individual command symlinks
    if [ -d ".claude/commands" ]; then
        for link in .claude/commands/*.md; do
            if [ -L "$link" ]; then
                patterns_to_add+=(".claude/commands/$(basename "$link")")
            fi
        done
    fi
    
    # Add individual agent symlinks
    if [ -d ".claude/agents" ]; then
        for link in .claude/agents/*.md; do
            if [ -L "$link" ]; then
                patterns_to_add+=(".claude/agents/$(basename "$link")")
            fi
        done
    fi
    
    # Create or update .gitignore
    if [ -f .gitignore ]; then
        # Remove existing AI agents section and any stray AI-related entries
        awk -v header="$ai_section_header" '
            BEGIN { in_ai_section = 0; }
            $0 == header { in_ai_section = 1; next; }
            in_ai_section && /^[[:space:]]*$/ { in_ai_section = 0; }
            in_ai_section { next; }
            /^CLAUDE\.md$/ { next; }
            /^GEMINI\.md$/ { next; }
            /^directives$/ { next; }
            /^\.claude\/commands\// { next; }
            /^\.claude\/agents\// { next; }
            { print }
        ' .gitignore > "$temp_file"
        
        # Ensure file ends with newline
        if [ -s "$temp_file" ] && [ -n "$(tail -c 1 "$temp_file")" ]; then
            echo "" >> "$temp_file"
        fi
        
        # Add AI agents section at the bottom
        echo "" >> "$temp_file"
        echo "$ai_section_header" >> "$temp_file"
        for pattern in "${patterns_to_add[@]}"; do
            echo "$pattern" >> "$temp_file"
        done
        
        # Replace original file
        mv "$temp_file" .gitignore
        echo -e "${GREEN}  ✓ Updated .gitignore with AI agents section at bottom${NC}"
    else
        # Create new .gitignore with AI agents section
        echo "$ai_section_header" > .gitignore
        for pattern in "${patterns_to_add[@]}"; do
            echo "$pattern" >> .gitignore
        done
        echo -e "${GREEN}  ✓ Created .gitignore with AI agents section${NC}"
    fi
    
    # Show what was added
    echo -e "${BLUE}  Added ${#patterns_to_add[@]} patterns to .gitignore${NC}"
}

# Update .gitignore with all AI-related patterns
update_gitignore_ai_section

echo -e "\n${GREEN}✅ Setup complete!${NC}"
echo -e "\n${BLUE}Summary:${NC}"
echo "  - AI_AGENT.md is the source file for both CLAUDE.md and GEMINI.md"
echo "  - Command symlinks in: .claude/commands/"
echo "  - Agent symlinks in: .claude/agents/"
echo "  - Settings merged into: .claude/settings.json"
echo "  - All symlinks added to .gitignore"
echo -e "\n${YELLOW}Remember to run '/hello' when starting a new Claude session!${NC}"

# List what was set up
echo -e "\n${BLUE}Linked commands:${NC}"
ls -la .claude/commands/*.md 2>/dev/null | awk '{print "  - " $NF}' | sed 's|.*/||'

echo -e "\n${BLUE}Linked agents:${NC}"
ls -la .claude/agents/*.md 2>/dev/null | awk '{print "  - " $NF}' | sed 's|.*/||'