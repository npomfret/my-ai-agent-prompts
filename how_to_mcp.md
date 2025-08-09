# How to MCP (Model Context Protocol)

MCP is an open standard for connecting AI assistants to external tools and data sources. It replaces fragmented integrations with a single protocol, making Claude Code more powerful and accurate.

## Quick Setup

Add server definitions to your `.mcp.json` file in the root of your project:

```json
{
  "mcpServers": {
      "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp"
    },
    "typescript-mcp": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "@mizchi/lsmcp",
        "-p",
        "typescript"
      ]
    },
    "ts-morph": {
      "command": "npx",
      "args": [
        "-y",
        "@sirosuzume/mcp-tsmorph-refactor"
      ]
    },
    "context-provider": {
      "command": "npx",
      "args": [
        "-y",
        "code-context-provider-mcp"
      ]
    },
    "playwright": {
      "command": "npx",
      "args": ["-y",  "@playwright/mcp@latest"]
    },
  }
}
```

- npx handles auto-installation of packages
- Claude Code manages process lifecycle and communication
- The MCP protocol handles tool discovery and invocation

## MCP Servers Detailed Guide

### 1. context7 - Up-to-date API Documentation
**Repository**: https://github.com/upstash/context7  
**Purpose**: Prevents outdated or hallucinated API documentation by fetching current, version-specific library docs

**Key Features**:
- Dynamically fetches official documentation
- Supports version-specific queries
- Integrates with 100+ popular libraries
- Zero configuration needed

**Usage Examples**:
```
# Basic usage - add "use context7" to any prompt
"use context7: Create a React component with useState hook"

# Version-specific documentation
"use context7: Show me Next.js 14 app router examples"

# API reference lookup
"use context7: How do I use Prisma transactions?"
```

**Best Practices**:
- Always include "use context7" when asking about library APIs
- Specify versions when working with specific library versions
- Use for both learning new APIs and verifying existing code

### 2. typescript-mcp (lsmcp) - Multi-Language LSP Integration
**Repository**: https://github.com/mizchi/lsmcp  
**Purpose**: Provides Language Server Protocol features for semantic code analysis

**Installation Requirements**:
```shell
npm install -g typescript typescript-language-server
```

**Supported Languages**: TypeScript, JavaScript, Rust, Python, Go, F#, Deno

**Available Tools**:
- `get_hover` - Type information and documentation
- `find_references` - Find all usages of a symbol
- `get_definitions` - Jump to symbol definition
- `get_diagnostics` - Get errors and warnings
- `rename_symbol` - Rename across entire codebase
- `get_completion` - Code completion suggestions
- `get_signature_help` - Function parameter hints
- `format_document` - Code formatting
- `get_code_actions` - Quick fixes and refactorings

**Usage Examples**:
```
# Get type information
"What's the type signature of processData function?"

# Find all references
"Find all places where UserService class is used"

# Rename across project
"Rename the calculateTotal function to computeTotal everywhere"

# Get diagnostics
"Show me all TypeScript errors in the src folder"
```

**Best Practices**:
- Use for refactoring instead of manual search/replace
- Leverage diagnostics before committing code
- Combine with ts-morph for complex refactorings

### 3. ts-morph - Advanced TypeScript/JavaScript Refactoring
**Repository**: https://github.com/SiroSuzume/mcp-ts-morph  
**Purpose**: AST-based code transformations and refactoring

**Key Capabilities**:
1. **Symbol Renaming**: Rename functions, variables, classes across entire project
2. **File/Folder Renaming**: Move files with automatic import updates
3. **Reference Finding**: Analyze symbol usage and dependencies
4. **Path Alias Removal**: Convert `@/components` to relative paths
5. **Symbol Movement**: Move code between files with reference updates

**Usage Examples**:
```
# Rename a function across the project
"Use ts-morph to rename getUserData to fetchUserProfile"

# Move multiple files
"Move all utility functions from src/utils to src/helpers"

# Remove path aliases
"Convert all @/ imports to relative paths"

# Move a class to another file
"Move the AuthService class to services/auth/AuthService.ts"
```

**Best Practices**:
- Always specify absolute paths and tsconfig.json location
- Use dry-run mode first for large refactorings
- Verify changes with git diff before committing
- Cannot move default exports - refactor them first

### 4. context-provider - Fast Codebase Analysis
**Repository**: Not specified (npx package: code-context-provider-mcp)  
**Purpose**: Quick project overview and structure analysis

**Key Features**:
- Analyzes entire codebase structure
- Provides symbol counts and complexity metrics
- Supports 50+ programming languages
- Memory-efficient with smart caching

**Usage Examples**:
```
# Get project overview
"Use context-provider to analyze this codebase structure"

# Understand architecture
"Show me the main components and their relationships"

# Find complex areas
"Identify the most complex files in this project"
```

**Best Practices**:
- Use at the start of new projects for quick understanding
- Combine with grep/glob for targeted searches
- Leverage for architectural decisions

### 5. playwright - Browser Automation
**Repository**: https://github.com/microsoft/playwright-mcp  
**Purpose**: Automate browser interactions and testing

**Installation**:
```bash
# For Claude Code
claude mcp add @playwright/mcp@latest

# Alternative servers available:
# executeautomation/mcp-playwright (includes API testing)
```

**Key Features**:
- Visual browser control (not headless by default)
- Accessibility-based element selection
- Cookie persistence across session
- No screenshot analysis needed

**Usage Examples**:
```
# Basic navigation
"Use playwright mcp to open https://example.com"

# Form interaction
"Fill the login form with username 'test' and password, then submit"

# Web scraping
"Extract all product prices from this e-commerce page"

# Authentication flow
"Navigate to login page and wait for me to login manually"
```

**Best Practices**:
- Explicitly mention "playwright mcp" in first prompt
- Use visible browser for authentication flows
- Leverage accessibility selectors over CSS selectors
- Session cookies persist - use for multi-step workflows

### 6. code-index-mcp - Advanced Code Search and Analysis
**Repository**: https://github.com/johnhuang316/code-index-mcp  
**Purpose**: Intelligent code indexing and search

**Installation Requirements**:
```shell
brew install pipx
pipx install uv
```

**Key Features**:
- Advanced regex and fuzzy search
- Auto-detects best search tools (ugrep, ripgrep)
- Smart recursive indexing with caching
- Deep file structure insights

**Available Tools**:
- `search_code_advanced` - Smart code searching
- `find_files` - Locate files with patterns
- `get_file_summary` - Analyze file complexity

## General MCP Best Practices

### 1. Configuration Management
- **Project-scoped servers**: Configure in `.mcp.json` at your project root
  - This is the recommended approach for project-specific MCP servers
  - The `setup-project-links.sh` script automatically creates this file
- **User-scoped servers**: Configure in `~/.claude.json` for global access
- **Direct config editing**: Best for complex configurations
- **Environment variables**: Use for sensitive data

### 2. Performance Optimization
- Use MCP servers instead of agents when possible (faster)
- Batch operations when available
- Enable caching where supported
- Use appropriate logging levels

### 3. Security Considerations
- Only install servers from trusted sources
- Review server permissions before granting
- Use environment variables for API keys
- Enable "human-in-the-loop" for sensitive operations

### 4. Workflow Integration

**Preferred Tool Order**:
1. MCP servers for specific operations (fastest)
2. Built-in tools for file operations
3. Agents for workflow orchestration and quality checks

**Example Workflow**:
```
1. Use context-provider for project overview
2. Use typescript-mcp for finding references
3. Use ts-morph for refactoring
4. Use playwright for testing changes
5. Use agents for final quality checks
```

### 5. Troubleshooting Tips
- Check server logs in ~/.claude/logs/
- Verify server installation with `/mcp` command
- Restart Claude Code after config changes
- Use explicit server names if conflicts arise

## Windows-Specific Notes
On native Windows (not WSL), use cmd wrapper for npx:
```json
{
  "command": "cmd",
  "args": ["/c", "npx", "-y", "package-name"]
}
```