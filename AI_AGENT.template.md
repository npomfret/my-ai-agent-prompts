# AUTONOMOUS DEVELOPMENT WORKFLOW

## WORK AUTONOMOUSLY - VERIFY AT COMMIT

Work independently and efficiently:
1. **Analyze and implement** without constant agent checks
2. **Make decisions** based on best practices
3. **Fix issues** as you encounter them
4. **Only use agents** when truly needed or before commits

## MANUAL VERIFICATION CHECKPOINT

Before committing, YOU or the user will:
- Review all changes
- Run tests manually
- Verify code quality
- Approve the final result

## CONSOLIDATED AGENT STRUCTURE

We use 8 focused agents (consolidated from 22):

### 1. workflow-orchestrator
- Meta-agent that coordinates all others
- Tells you EXACTLY which agents to use when

### 2. architect-advisor  
- Analyzes system architecture before ANY implementation
- MANDATORY before writing code

### 3. code-quality-enforcer
- Enforces style, syntax, logging, comments, duplication, immutability
- Combines 6 previous agents into one comprehensive check

### 4. anti-pattern-detector
- Detects fallbacks, hacks, error suppression, backwards compatibility
- Zero tolerance for anti-patterns

### 5. scope-guardian
- Prevents scope creep and over-engineering
- Ensures minimal, focused implementations

### 6. test-guardian
- Runs tests, enforces quality, handles cleanup
- Includes pwd checking for commands

### 7. auditor
- Final review before commits
- Creates commit messages

### 8. analyst
- Comprehensive codebase analysis
- Creates improvement tasks

## AUTONOMOUS BEST PRACTICES:

1. **Write clean code** following existing patterns
2. **Test your changes** when possible
3. **Keep changes focused** on the requested task
4. **Fix issues** you encounter along the way
5. **Document** only when necessary
6. **Refactor** only what's needed for the task

## TRUST AND AUTONOMY

- **Make decisions** based on your judgment
- **Use agents sparingly** - only when truly beneficial
- **Work efficiently** - avoid unnecessary process
- **Focus on results** - deliver working code

## TOOL PREFERENCE ORDER (HYBRID APPROACH)

### ALWAYS use MCP servers when available for:
- **Refactoring**: Use `ts-morph` or `typescript-mcp` instead of agents
- **Type checking**: Use `typescript-mcp` for diagnostics instead of manual checking
- **Code analysis**: Use `context-provider` for initial analysis instead of reading files
- **Finding references**: Use `typescript-mcp` or `ts-morph` instead of grep/search
- **Documentation lookup**: Use `context7` for API docs instead of web search

### ONLY use agents for:
- **Workflow orchestration**: workflow-orchestrator guides the process
- **Architectural decisions**: architect-advisor before implementation
- **Quality enforcement**: Detection agents after code changes
- **Commit validation**: auditor for final review

### NEVER use agents when MCP servers can do it faster!

## STREAMLINED WORKFLOW

1. **New Task**: Understand requirements and implement
2. **Code Analysis**: Use MCP servers for fast analysis
3. **Development**: Write code, test, iterate
4. **Refactoring**: Use ts-morph or typescript-mcp directly
5. **Pre-Commit** (Optional): Run auditor if you want a final check

## QUALITY GUIDELINES

Aim for these standards (self-enforced):
- ✓ Follow existing code patterns
- ✓ Write tests when appropriate
- ✓ Keep changes minimal and focused
- ✓ Use proper error handling
- ✓ Avoid console.log in production code
- ✓ No unnecessary comments
- ✓ Fix or remove broken tests

## SELF-REGULATION

When you notice issues:
1. **Fix them** as part of your work
2. **Test the fix** to ensure it works
3. **Continue** with your task
4. **Note any concerns** for user review

## MCP SERVER USAGE EXAMPLES

### When to use each MCP server:

**ts-morph** - Powerful refactoring:
- Renaming symbols across files: `mcp__ts-morph__rename_symbol_by_tsmorph`
- Moving functions/classes to different files: `mcp__ts-morph__move_symbol_to_file_by_tsmorph`
- Renaming/moving files with import updates: `mcp__ts-morph__rename_filesystem_entry_by_tsmorph`

**typescript-mcp** - Language server features:
- Get type info on hover: `mcp__typescript-mcp__get_hover`
- Find all references: `mcp__typescript-mcp__find_references`
- Get diagnostics/errors: `mcp__typescript-mcp__get_diagnostics`
- Rename symbols: `mcp__typescript-mcp__rename_symbol`

**context-provider** - Fast codebase overview:
- Get project structure and symbols: `mcp__context-provider__get_code_context`
- Understand codebase quickly without multiple file reads

**context7** - Documentation lookup:
- Get library docs: `mcp__context7__get-library-docs`
- Find API examples: `mcp__context7__resolve-library-id`

## PROJECT-SPECIFIC INSTRUCTIONS
[Add your project-specific requirements here]

## REMEMBER

- **Work autonomously** - Make good decisions
- **Be efficient** - Avoid unnecessary process
- **Focus on quality** - Write good code the first time
- **User verifies** - They'll check before committing
- **Use agents wisely** - Only when they add real value