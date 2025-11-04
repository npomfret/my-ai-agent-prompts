#!/bin/bash

# Setup script for AI agent skills in a project
# Usage: ./setup-skills.sh [target-project-path]

# Source common functions
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/common.sh"

# Target project directory (default to current directory)
TARGET_DIR="${1:-$(pwd)}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

# Source and target directories
SOURCE_SKILLS_DIR="$SCRIPT_BASE_DIR/dot_claude/skills"
TARGET_SKILLS_DIR="$TARGET_DIR/.claude/skills"

# Ensure target directory exists
mkdir -p "$TARGET_SKILLS_DIR"

# Check if source directory exists
if [ ! -d "$SOURCE_SKILLS_DIR" ]; then
    echo -e "${YELLOW}  No skills found in template directory: $SOURCE_SKILLS_DIR${NC}"
    exit 0
fi

# Cleanup old skills
for target_skill_dir in "$TARGET_SKILLS_DIR"/*; do
    if [ -d "$target_skill_dir" ]; then
        skill_name=$(basename "$target_skill_dir")
        source_skill_dir="$SOURCE_SKILLS_DIR/$skill_name"
        if [ ! -d "$source_skill_dir" ]; then
            rm -rf "$target_skill_dir"
            echo -e "${YELLOW}  Removed old skill directory: $skill_name${NC}"
        fi
    fi
done

# Copy each skill
for skill_source_dir in "$SOURCE_SKILLS_DIR"/*; do
    if [ -d "$skill_source_dir" ]; then
        skill_name=$(basename "$skill_source_dir")
        skill_target_dir="$TARGET_SKILLS_DIR/$skill_name"
        mkdir -p "$skill_target_dir"

        # Copy SKILL.md
        if [ -f "$skill_source_dir/SKILL.md" ]; then
            copy_and_comment "$skill_source_dir/SKILL.md" "$skill_target_dir/SKILL.md" "  - $skill_name/SKILL.md"
        fi

        # Copy scripts
        if [ -d "$skill_source_dir/scripts" ]; then
            mkdir -p "$skill_target_dir/scripts"
            for script in "$skill_source_dir/scripts"/*; do
                script_name=$(basename "$script")
                copy_and_comment "$script" "$skill_target_dir/scripts/$script_name" "  - $skill_name/scripts/$script_name"
            done
        fi

        # Copy resources
        if [ -d "$skill_source_dir/resources" ]; then
            mkdir -p "$skill_target_dir/resources"
            for resource in "$skill_source_dir/resources"/*; do
                resource_name=$(basename "$resource")
                copy_and_comment "$resource" "$skill_target_dir/resources/$resource_name" "  - $skill_name/resources/$resource_name"
            done
        fi
    fi
done

echo -e "${GREEN}  ✓ Skills setup complete${NC}"