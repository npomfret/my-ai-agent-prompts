# my-ai-agent-prompts

For Claude Code and Gemini Cli (kind of).

## Project Setup

Use the modular setup scripts in the `scripts/` directory to configure a new project with AI agent prompts:

```shell
# Complete setup (from within your target project)
../my-ai-agent-prompts/scripts/setup-all.sh
```

```shell
# Or specify a target directory
./scripts/setup-all.sh /path/to/target/project
```

```shell
# Individual setup scripts (optional)
./scripts/setup-commands.sh [path]  # Only set up command symlinks
./scripts/setup-agents.sh [path]    # Only set up agent symlinks  
./scripts/setup-mcp.sh [path]       # Only set up MCP configuration
```

The `setup-all.sh` script automatically:
- Creates `AI_AGENT.md` if it doesn't exist (from template or basic version)
- Symlinks `CLAUDE.md` and `GEMINI.md` to `AI_AGENT.md` for shared configuration
- Syncs all command files to `.claude/commands/`
- Syncs all agent files to `.claude/agents/`
- Merges `.claude/settings.json` permissions
- Sets up `.mcp.json` with default MCP servers (checked into git)
- Updates `.gitignore` with all symlinked paths and `.mcp.local.json`
- Handles additions/removals - safe to re-run anytime

### MCP Configuration

- `.mcp.json` - Team-shared MCP server configuration (committed to git)
- `.mcp.local.json` - Personal MCP additions like API keys (gitignored)

Claude Code automatically merges both files when loading MCP servers.

This agent-based approach is much more effective than traditional CLAUDE.md instructions because it transforms principles into explicit tool invocations that are harder to ignore.

On starting a new claude shell, always run `/hello` first (this includes mandatory workflow initialization).

As a general approach, I create a `docs/tasks` directory in the root of every project.  Form here I add subdirectories, or not, as needed, and write all my bug reports, feature planning, refactorings as `.md` files. 

### Update cli tools

```shell
npm install -g @anthropic-ai/claude-code
npm install -g @google/gemini-cli
```

## Claude Code Subagents

We now have specialized subagents that enforce our directives automatically. These agents transform oft-ignored principles into enforced gates.

### Available Agents

#### Meta-Orchestration Agent
- **workflow-orchestrator**: MUST BE USED FIRST - tells you exactly which agents to use for your current task

#### Core Task Agents
- **analyst**: Performs comprehensive codebase analysis (replaces `/analyse` command)
- **auditor**: Reviews changes and creates commit messages (replaces `/changes` command)
- **architect-advisor**: Analyzes system architecture and data flows to advise WHERE changes should be made
- **test-cleanup**: Enforces proper test cleanup - tests must be FIXED or DELETED, never skipped

#### Enforcement Agents  
- **test-runner**: Actually runs tests and waits for completion (prevents false "tests passed" claims)
- **no-fallback-detector**: Detects any fallback patterns (enforces the "NEVER use fallbacks" rule)
- **style-enforcer**: Enforces coding style and patterns
- **engineering-guardian**: Comprehensive check of all engineering principles

#### Fine-Grained Detection Agents (Read-Only)
- **comment-detector**: Finds code comments (forbidden except truly exceptional cases)
- **scope-creep-detector**: Catches when changes exceed requested scope
- **hack-detector**: Identifies dirty hacks disguised as "simple solutions"
- **pwd-checker**: Ensures pwd is run before shell commands
- **duplicate-detector**: Finds code duplication and copy-paste patterns
- **error-suppressor-detector**: Catches try/catch/log anti-patterns
- **backwards-compat-detector**: Finds any backward compatibility code
- **test-for-future-detector**: Detects tests for non-existent features
- **build-system-analyzer**: Deep dives into build systems to understand compilation, testing, deployment

### Usage Patterns

#### Manual Invocation
```
Use the analyst subagent to analyze this codebase
Use the test-runner subagent to run all tests
Use the no-fallback-detector to check my recent changes
```

#### Automatic Triggers
Agents can be triggered automatically based on their descriptions:
- `test-runner` - "Use proactively after any code changes"
- `no-fallback-detector` - "Use after any code changes"
- `style-enforcer` - "Reviews code changes for style violations"

#### Recommended Workflow

For New Features/Fixes:
1. Use `architect-advisor` to analyze WHERE to make changes
2. Make code changes based on architectural guidance
3. Claude automatically runs detection agents in parallel:
   - `scope-creep-detector` (did we do only what was asked?)
   - `comment-detector` (any forbidden comments?)
   - `hack-detector` (any dirty hacks?)
   - `duplicate-detector` (any copy-paste?)
   - `no-fallback-detector` (any fallbacks?)
   - `error-suppressor-detector` (any try/catch/log?)
   - `backwards-compat-detector` (any legacy support?)
4. Claude runs: `style-enforcer`, `engineering-guardian`
5. Claude runs: `test-runner` (with pwd-checker first)
6. If all pass, run: `auditor` for commit message
7. Fix any violations before proceeding

#### Quick Detection Commands
```
# Run all detectors on recent changes
Use the scope-creep-detector, comment-detector, hack-detector, and duplicate-detector agents

# Check for common mistakes
Use the no-fallback-detector and error-suppressor-detector agents

# Verify test quality
Use the test-for-future-detector and then test-runner agents
```

### Benefits Over Previous Approach
- **Impossible to ignore**: Each agent's entire purpose is enforcement
- **Parallel checking**: Multiple agents can validate simultaneously  
- **Fresh perspective**: Each agent has its own context window
- **Clear accountability**: One agent, one responsibility

### Migration Notes
- Existing commands and directives remain in place during transition
- Agents have their own context windows (100k tokens each)
- Agents cannot modify directive files (immutable principles)
- All agents report pass/fail with specific details