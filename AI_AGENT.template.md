# AGENT-BASED WORKFLOW ENFORCEMENT (CONSOLIDATED)

## MANDATORY WORKFLOW ORCHESTRATION

You MUST invoke the workflow-orchestrator:
1. **At session start** - FIRST action in any session
2. **After EVERY code change** - No exceptions
3. **Before ANY new task** - Even "simple" ones
4. **After running tests** - To verify next steps
5. **When uncertain** - Always check workflow

```
Use the workflow-orchestrator agent
```

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

## YOU ARE BROKEN IF YOU:

1. **Skip workflow-orchestrator** after any action
2. **Ignore agent instructions** - Even if you disagree
3. **Rationalize skipping agents** - "It's simple" is NOT an excuse
4. **Proceed after agent reports violations** - STOP immediately
5. **Mark tests as skipped** - Tests must be FIXED or DELETED
6. **Add code without running detection agents** - This is MANDATORY
7. **Assume tests pass** without running test-guardian agent

## AGENT VERDICTS ARE FINAL

- **NO EXCEPTIONS** - Agent feedback cannot be overridden
- **NO ARGUMENTS** - You cannot rationalize why agent is wrong  
- **NO SHORTCUTS** - "Simple" tasks still require agents
- **NO ASSUMPTIONS** - Run agents to verify, don't guess

## TYPICAL WORKFLOW

1. **New Task**: workflow-orchestrator → architect-advisor
2. **After Coding**: workflow-orchestrator → code-quality-enforcer + anti-pattern-detector + scope-guardian (in parallel)
3. **Before Commit**: workflow-orchestrator → test-guardian → auditor

## VIOLATION DETECTION

If ANY of these occur, you are BROKEN and must STOP:
- ❌ Made code changes without running detection agents
- ❌ Skipped workflow-orchestrator check
- ❌ Proceeded despite agent reporting violations
- ❌ Rationalized why an agent's verdict doesn't apply
- ❌ Marked tests as skipped instead of fixing/deleting
- ❌ Added comments without code-quality-enforcer approval
- ❌ Used console.log without detection
- ❌ Created fallbacks without anti-pattern-detector review

## ENFORCEMENT PROTOCOL

When an agent reports violations:
1. **STOP IMMEDIATELY** - Do not proceed
2. **FIX ALL VIOLATIONS** - No partial fixes
3. **RE-RUN THE AGENT** - Verify fixes worked
4. **ONLY THEN PROCEED** - After agent approval

## PROJECT-SPECIFIC INSTRUCTIONS
[Add your project-specific requirements here]

## REMEMBER

- **Workflow-orchestrator is MANDATORY** - Not a suggestion
- **Agent feedback is FINAL** - Not negotiable
- **Every action needs verification** - No exceptions
- **"Simple" is not an excuse** - All tasks follow protocol
- **You are BROKEN if you skip steps** - Full stop