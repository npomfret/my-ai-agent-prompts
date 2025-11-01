#!/bin/bash

# Post-response checker hook
# This script is executed after Claude responds.
# It checks the edited files for risky patterns based on the
# filePathTriggers and contentTriggers in skill-rules.json.

# Get the list of edited files from the command-line arguments
EDITED_FILES=($@)

# Check if there are any edited files
if [ ${#EDITED_FILES[@]} -eq 0 ]; then
    exit 0
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Warning: jq is not installed. Post-response checks will be skipped." >&2
    exit 0
fi

# Path to the skill-rules.json file
SKILL_RULES_FILE=".claude/skill-rules.json"

# Check if the skill-rules.json file exists
if [ ! -f "$SKILL_RULES_FILE" ]; then
    exit 0
fi

# Iterate through the skills in skill-rules.json
jq -c '.skills[]' "$SKILL_RULES_FILE" | while read -r skill; do
    # Extract skill name and triggers
    SKILL_NAME=$(echo "$skill" | jq -r '.name')
    FILE_PATH_TRIGGERS=$(echo "$skill" | jq -r '.filePathTriggers[]')
    CONTENT_TRIGGERS=$(echo "$skill" | jq -r '.contentTriggers[]')

    # Iterate through the edited files
    for file in "${EDITED_FILES[@]}"; do
        # Check for file path triggers
        for trigger in $FILE_PATH_TRIGGERS; do
            if [[ "$file" == $trigger ]]; then
                echo "Reminder for skill '$SKILL_NAME': You have edited a file ($file) that may require attention to its structure or dependencies."
            fi
        done

        # Check for content triggers
        for trigger in $CONTENT_TRIGGERS; do
            if grep -q "$trigger" "$file"; then
                echo "Reminder for skill '$SKILL_NAME': The file ($file) contains content ('$trigger') that may require a self-check for correctness or security."
            fi
        done
    done
done