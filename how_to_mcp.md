# How to MCP...

Essentially, you just add the definitions to your `~/.claude.json` file (see below).

```json
  ...,
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
    }
  },

```

- npx handles the auto-installation
- Claude Code handles the process management and communication
- The MCP protocol handles the tool discovery and calling

## playwright - browser automation
see: https://github.com/microsoft/playwright-mcp
Example prompt: `Use playwright mcp to open a browser to example.com`

## code-index-mcp - code indexing and analysis
see: https://github.com/johnhuang316/code-index-mcp

Check the docs, it needs some manual installation steps:
```shell
brew install pipx
pipx install uv
```

## lsmcp - multi-language advanced code manipulation and analysis
see: https://github.com/mizchi/lsmcp
Check the docs, it needs some manual installation steps:

```shell
npm install -g typescript typescript-language-server
```

## mcp-tsmorph-refactor - powerful code transformation capabilities 
See: https://github.com/SiroSuzume/mcp-ts-morph
Uses the ts-morph library

## context7 - fast api docs and examples
see: https://github.com/upstash/context7