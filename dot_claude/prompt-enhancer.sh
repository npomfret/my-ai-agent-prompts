#!/bin/bash

# Store the cookies in some local dir thats not under version control
TMP_DIR="tmp"
COOKIE_FILE="${TMP_DIR}/cookies.txt"

# Read the user's prompt from stdin
PROMPT=$(cat)

# Only invoke http call if prompt starts or ends with underscore
if [[ "$PROMPT" == _* || "$PROMPT" == *_ ]]; then
    # Escape double quotes in the prompt for JSON
    ESCAPED_PROMPT=$(echo "$PROMPT" | sed 's/"/\\"/g')

    # Construct the JSON payload
    JSON_PAYLOAD="{\"message\": \"$ESCAPED_PROMPT\"}"

    # Execute the curl command and extract the response
    curl -s -X POST http://localhost:3000/enhance?projectId=1c1e82af2343 \
        -H "Content-Type: application/json" \
        -b "$COOKIE_FILE" -c "$COOKIE_FILE" \
        -d "$JSON_PAYLOAD" \
        | jq -r '.response'
else
    # If no underscore prefix/suffix, just return the original prompt
    echo "$PROMPT"
fi
