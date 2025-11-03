#!/bin/bash

# Store the cookies in some local dir thats not under version control
TMP_DIR="tmp"
COOKIE_FILE="${TMP_DIR}/cookies.txt"
LOG_FILE="/Users/nickpomfret/projects/splitifyd-2/.claude/prompt-enhancer.log"

# Read the JSON input from stdin
JSON_INPUT=$(cat)

# Log the raw JSON input and timestamp
echo "$(date '+%Y-%m-%d %H:%M:%S') - Received input: $JSON_INPUT" >> "$LOG_FILE"

# Extract the prompt from the JSON input
PROMPT=$(echo "$JSON_INPUT" | jq -r '.prompt')

# Only invoke http call if prompt starts or ends with underscore
if [[ "$PROMPT" == _* || "$PROMPT" == *_ ]]; then
    # Escape double quotes in the prompt for JSON
    ESCAPED_PROMPT=$(echo "$PROMPT" | sed 's/"/\"/g')

    # Construct the JSON payload
    JSON_PAYLOAD="{\"message\": \"$ESCAPED_PROMPT\"}"

    # Execute the curl command and extract the response
    curl -s -X POST http://localhost:3000/enhance?projectId=9fe1344eb798 \
        -H "Content-Type: application/json" \
        -b "$COOKIE_FILE" -c "$COOKIE_FILE" \
        -d "$JSON_PAYLOAD" \
        | jq -r '.response'
else
    # If no underscore prefix/suffix, just return the original prompt
    echo "$PROMPT"
fi