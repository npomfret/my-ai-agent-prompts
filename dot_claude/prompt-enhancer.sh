#!/bin/bash

# Read the user's prompt from stdin
PROMPT=$(cat)

# Escape double quotes in the prompt for JSON
ESCAPED_PROMPT=$(echo "$PROMPT" | sed 's/"/\\"/g')

# Construct the JSON payload
JSON_PAYLOAD="{\"message\": \"$ESCAPED_PROMPT\"}"

# Execute the curl command and extract the response
curl -X POST http://localhost:3000/chat \
    -H "Content-Type: application/json" \
    -c /tmp/cookies.txt \
    -d "$JSON_PAYLOAD" \
    | jq -r '.response'
