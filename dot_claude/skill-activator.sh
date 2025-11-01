#!/bin/bash

# Skill activator hook
# This script is executed before the user's prompt is sent to Claude.
# It reads the user's prompt from stdin, and if it matches any of the
# keywords or intents in skill-rules.json, it injects a skill reminder
# into the prompt.

# Read the user's prompt from stdin
PROMPT=$(cat)

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

# Iterate through the skills in skill-rules.json
jq -c '.skills[]' "$SKILL_RULES_FILE" | while read -r skill; do
    # Extract skill name, keywords, and intents
    SKILL_NAME=$(echo "$skill" | jq -r '.name')
    KEYWORDS=$(echo "$skill" | jq -r '.keywords[]')
    INTENTS=$(echo "$skill" | jq -r '.intents[]')

    # Check for matches in the prompt
    MATCH=0
    for keyword in $KEYWORDS; do
        if [[ "$PROMPT" == *"$keyword"* ]]; then
            MATCH=1
            break
        fi
    done

    if [ $MATCH -eq 0 ]; then
        for intent in $INTENTS; do
            if [[ "$PROMPT" == *"$intent"* ]]; then
                MATCH=1
                break
            fi
        done
    fi

    # If a match is found, inject the skill reminder
    if [ $MATCH -eq 1 ]; then
        SKILL_MD_FILE=".claude/skills/$SKILL_NAME/SKILL.md"
        if [ -f "$SKILL_MD_FILE" ]; then
            SKILL_CONTENT=$(cat "$SKILL_MD_FILE")
            echo "Based on your prompt, you may want to use the '$SKILL_NAME' skill. Here are the instructions for that skill:"
            echo "$SKILL_CONTENT"
            echo "---"
        fi
    fi
done

# Output the original prompt
echo "$PROMPT"