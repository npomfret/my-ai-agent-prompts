#!/bin/bash

# Skill activator hook
# This script is executed before the user's prompt is sent to Claude.
# It reads the user's prompt from stdin, and if it matches any of the
# keywords or intents in skill-rules.json, it injects a skill reminder
# into the prompt.

# Read the user's prompt from stdin
PROMPT=$(cat)
LOWER_PROMPT=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Warning: jq is not installed. Skill activation will be skipped." >&2
    echo "$PROMPT"
    exit 0
fi

# Path to the skill-rules.json file
SKILL_RULES_FILE=".claude/skill-rules.json"

# Check if the skill-rules.json file exists
if [ ! -f "$SKILL_RULES_FILE" ]; then
    echo "$PROMPT"
    exit 0
fi

# Keep track of activated skills to avoid duplicates
ACTIVATED_SKILLS=""

# Function to check for a match and activate a skill
activate_skill() {
    local skill_json=""
    local skill_name
    skill_name=$(echo "$skill_json" | jq -r '.name')

    # Check if skill has already been activated
    if [[ "$ACTIVATED_SKILLS" == *"$skill_name"* ]]; then
        return
    fi

    local match=0

    # Check for keyword matches (case-insensitive)
    while IFS= read -r keyword; do
        if [[ -n "$keyword" && "$LOWER_PROMPT" == *"$keyword"* ]]; then
            match=1
            break
        fi
    done < <(echo "$skill_json" | jq -r '.keywords[]')

    # Check for intent matches if no keyword match (case-insensitive)
    if [ $match -eq 0 ]; then
        while IFS= read -r intent; do
            if [[ -n "$intent" && "$LOWER_PROMPT" == *"$intent"* ]]; then
                match=1
                break
            fi
        done < <(echo "$skill_json" | jq -r '.intents[]')
    fi

    # If a match is found, inject the skill reminder
    if [ $match -eq 1 ]; then
        local skill_md_file=".claude/skills/$skill_name/SKILL.md"
        if [ -f "$skill_md_file" ]; then
            local skill_content
            skill_content=$(cat "$skill_md_file")
            echo "Based on your prompt, you may want to use the '$skill_name' skill. Here are the instructions for that skill:"
            echo "$skill_content"
            echo "---"
            ACTIVATED_SKILLS="$ACTIVATED_SKILLS $skill_name"
        fi
    fi
}

export -f activate_skill
export ACTIVATED_SKILLS
export LOWER_PROMPT

# Iterate through the skills in skill-rules.json
jq -c '.skills[]' "$SKILL_RULES_FILE" | while read -r skill; do
    activate_skill "$skill"
done

# Output the original prompt
echo "$PROMPT"