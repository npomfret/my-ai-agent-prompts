#!/bin/bash

# Setup MCP.json for AI agent prompts in a project
# Usage: ./setup-mcp.sh [target-project-path]

# Source common functions
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/common.sh"

# Target project directory (default to current directory)
TARGET_DIR="${1:-$(pwd)}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo -e "${BLUE}Setting up .mcp.json in: ${TARGET_DIR}${NC}"

# Change to target directory
cd "$TARGET_DIR"

# Create or update .mcp.json file
setup_mcp_json() {
    local mcp_file=".mcp.json"
    
    if [ ! -f "$mcp_file" ]; then
        # Create new .mcp.json with default MCP servers
        cat > "$mcp_file" << 'EOF'
{
  "mcpServers": {
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp"
    },
    "typescript-mcp": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@mizchi/lsmcp", "-p", "typescript"]
    },
    "ts-morph": {
      "command": "npx",
      "args": ["-y", "@sirosuzume/mcp-tsmorph-refactor"]
    },
    "context-provider": {
      "command": "npx",
      "args": ["-y", "code-context-provider-mcp"]
    }
  }
}
EOF
        echo -e "${GREEN}  ✓ Created .mcp.json with MCP servers${NC}"
        echo -e "${BLUE}  Tip: Create .mcp.local.json for personal MCP servers (gitignored)${NC}"
    else
        echo -e "${BLUE}  .mcp.json already exists${NC}"
        
        # Check if we should merge or update
        if command -v jq &> /dev/null; then
            echo -e "${BLUE}  Checking for missing MCP servers...${NC}"
            
            # Define the default servers
            local default_servers='{
              "context7": {
                "type": "http",
                "url": "https://mcp.context7.com/mcp"
              },
              "typescript-mcp": {
                "type": "stdio",
                "command": "npx",
                "args": ["-y", "@mizchi/lsmcp", "-p", "typescript"]
              },
              "ts-morph": {
                "command": "npx",
                "args": ["-y", "@sirosuzume/mcp-tsmorph-refactor"]
              },
              "context-provider": {
                "command": "npx",
                "args": ["-y", "code-context-provider-mcp"]
              }
            }'
            
            # Create a temporary file for the merged result
            local temp_file=".mcp.json.tmp"
            
            # Merge the JSON files
            jq --argjson defaults "$default_servers" '
                .mcpServers = (.mcpServers // {}) + ($defaults | to_entries | reduce .[] as $item ({}; .[$item.key] = ((.mcpServers[$item.key] // $item.value))))
            ' "$mcp_file" > "$temp_file"
            
            # Check if anything changed
            if ! cmp -s "$mcp_file" "$temp_file"; then
                mv "$temp_file" "$mcp_file"
                echo -e "${GREEN}  ✓ Updated .mcp.json with missing MCP servers${NC}"
            else
                rm "$temp_file"
                echo -e "${BLUE}  All default MCP servers already present${NC}"
            fi
        else
            echo -e "${YELLOW}  Warning: jq not installed. Cannot check for missing servers.${NC}"
        fi
    fi
}

# Setup MCP servers
echo -e "\n${BLUE}Setting up .mcp.json...${NC}"
setup_mcp_json

# Update .gitignore with .mcp.local.json
echo -e "\n${BLUE}Updating .gitignore...${NC}"
update_gitignore_patterns ".mcp.local.json"
echo -e "${GREEN}  ✓ Added .mcp.local.json to .gitignore${NC}"