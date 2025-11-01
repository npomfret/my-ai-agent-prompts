#!/bin/bash

# Read the user's prompt from stdin
PROMPT=$(cat)

# Escape double quotes in the prompt for JSON
ESCAPED_PROMPT=$(echo "$PROMPT" | sed 's/"/\\"/g')

# Construct the JSON payload
JSON_PAYLOAD="{\"message\": \"$ESCAPED_PROMPT\"}"

# Execute the curl command and extract the response
curl -X POST http://localhost:3000/chat?projectId=1c1e82af2343 \
    -H "Content-Type: application/json" \
    -b cookies.txt -c cookies.txt \
    -d "$JSON_PAYLOAD" \
    | jq -r '.response'
