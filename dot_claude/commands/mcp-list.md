---
description: List all available MCP servers and their capabilities
---

# List Available MCP Servers

Show me all the MCP servers configured in this project along with their capabilities and common use cases.

## Instructions

1. Read the `.claude/mcp-inventory.json` file
2. Read the `.mcp.json` file to see which servers are actually configured
3. For each MCP server, display:
   - Name (how to invoke it)
   - Purpose
   - Key capabilities
   - Common trigger keywords
   - Example use cases

## Output Format

Format the output as a clear, readable list that helps users understand when to use each MCP server.

Include:
- Which servers are currently active (in .mcp.json)
- Which servers are available but not configured
- Tips on when to use each server

Make it easy for users to understand the value of each MCP server without having to memorize technical details.