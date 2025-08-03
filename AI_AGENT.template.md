# AUTONOMOUS DEVELOPMENT WORKFLOW

## WORK AUTONOMOUSLY - VERIFY AT COMMIT

Work independently and efficiently:
1. **Analyze and implement** without constant agent checks
2. **Make decisions** based on best practices
3. **Fix issues** as you encounter them
4. **Use agents** when appropriate

## MANUAL VERIFICATION CHECKPOINT

Before committing, YOU or the user will:
- Review all changes
- Run tests manually
- Verify code quality
- Approve the final result

## START EVERY TASK WITH MCP SERVERS

**IMPORTANT**: Before using any other tools, ALWAYS check if an MCP server can do it faster:
- 🔍 **Starting a new task?** → Use `mcp__context-provider__get_code_context` for project overview
- 📚 **Need library docs?** → Use `mcp__context7__resolve-library-id` then `get-library-docs`
- 🔧 **Finding references?** → Use `mcp__typescript-mcp__find_references`
- ⚠️ **Checking for errors?** → Use `mcp__typescript-mcp__get_diagnostics`
- ♻️ **Refactoring code?** → Use `mcp__ts-morph__` tools for automated changes

## CONSOLIDATED AGENT STRUCTURE (MCP-AWARE)

We use 8 focused agents that are aware of MCP servers:

### 1. workflow-orchestrator
- Efficiency advisor that recommends fastest approach
- Prioritizes MCP servers > built-in tools > agents
- Suggests tools based on actual value, not process

### 2. architect-advisor  
- Analyzes system architecture using MCP servers first
- Uses context-provider for overview, typescript-mcp for references
- Optional for simple tasks in autonomous mode

### 3. code-quality-enforcer
- Leverages typescript-mcp for diagnostics before manual checks
- Suggests ts-morph for automated fixes
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
- Advisory role in autonomous mode
- Uses MCP for quick diagnostics
- Creates commit messages, flags issues for user review

### 8. analyst
- Uses MCP servers for fast initial analysis
- Creates improvement tasks with automation suggestions
- Leverages context-provider and typescript-mcp heavily

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

### MCP SERVER PERMISSIONS
- **MCP servers require ONE-TIME approval per project** for security
- After initial approval, they run automatically without prompting
- This is a security feature, not a bug - MCP servers can access external resources
- Trust MCP servers for fast, accurate operations
- They are essential for efficient autonomous workflow
- To reset approvals: `claude mcp reset-project-choices`

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

## STREAMLINED WORKFLOW WITH MCP-FIRST APPROACH

1. **New Task Arrives** → IMMEDIATELY use `mcp__context-provider__get_code_context` for overview
2. **Understanding Code** → Use `mcp__typescript-mcp__get_hover` for type info, NOT manual inspection
3. **Finding Things** → Use `mcp__typescript-mcp__find_references`, NOT grep or search
4. **Checking Errors** → Use `mcp__typescript-mcp__get_diagnostics`, NOT manual checking
5. **Refactoring** → Use `mcp__ts-morph__` tools, NOT manual find/replace
6. **Documentation** → Use `mcp__context7__`, NOT web search
7. **Pre-Commit** (Optional): Run auditor if you want a final check

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

## MCP SERVER USAGE - SPECIFIC SCENARIOS

### ALWAYS START WITH THESE:

**Every new task/request:**
```
mcp__context-provider__get_code_context
- absolutePath: /path/to/project
- includeSymbols: true (for detailed analysis)
```

**When you see an import or library:**
```
mcp__context7__resolve-library-id → mcp__context7__get-library-docs
```

### REPLACE THESE HABITS:

| Instead of... | USE THIS MCP SERVER |
|--------------|-------------------|
| `grep` or `Glob` for finding code | `mcp__typescript-mcp__find_references` |
| Reading file to check types | `mcp__typescript-mcp__get_hover` |
| Manual error checking | `mcp__typescript-mcp__get_diagnostics` |
| Find/replace across files | `mcp__ts-morph__rename_symbol_by_tsmorph` |
| Moving code manually | `mcp__ts-morph__move_symbol_to_file_by_tsmorph` |
| Renaming files + updating imports | `mcp__ts-morph__rename_filesystem_entry_by_tsmorph` |
| Web search for docs | `mcp__context7__get-library-docs` |

### CONCRETE EXAMPLES:

**"Fix the type error in user.ts"**
```
1. mcp__typescript-mcp__get_diagnostics (root: /project, filePath: src/user.ts)
2. See exact errors with line numbers
3. Fix based on diagnostic info
```

**"Rename getUserData to fetchUserData everywhere"**
```
1. mcp__ts-morph__rename_symbol_by_tsmorph
   - tsconfigPath: /project/tsconfig.json
   - targetFilePath: /project/src/user.ts
   - position: {line: 15, column: 10}
   - symbolName: getUserData
   - newName: fetchUserData
```

**"What does this NextJS app do?"**
```
1. mcp__context-provider__get_code_context
   - absolutePath: /project
   - includeSymbols: true
2. mcp__context7__resolve-library-id (libraryName: "next")
3. mcp__context7__get-library-docs (context7CompatibleLibraryID: "/vercel/next.js")
```

## REMEMBER

- **MCP SERVERS FIRST** - They're faster and more accurate than manual tools
- **Work autonomously** - Make good decisions
- **Be efficient** - Avoid unnecessary process
- **Focus on quality** - Write good code the first time
- **User verifies** - They'll check before committing
- **Use agents wisely** - Only when they add real value

## CHECKLIST FOR EVERY REQUEST

☐ Did I start with `mcp__context-provider__get_code_context`?
☐ Am I using MCP servers instead of grep/find/search?
☐ Am I using typescript-mcp for diagnostics instead of reading files?
☐ Am I using ts-morph for refactoring instead of manual edits?
☐ Am I using context7 for docs instead of web search?

## PROJECT-SPECIFIC INSTRUCTIONS
[Add your project-specific requirements here]