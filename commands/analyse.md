# Code Analysis & Improvement Guide

Analyze the entire project (use `git ls-files` to filter out noise) and identify all areas for improvement. Be creative and VERY thorough. Consider multiple approaches to solve each problem you encounter.

## What to Look For

### 0. Delete
In general, less is more.  What can we reduce in size or ideally remove and delete from the code without breaking anything. It's often ok to alter behaviour slightly if it means a large win in terms of code complexity.

### 1. Code Quality Issues
- **Complexity**: Unnecessary abstractions, over-engineering, **verbose** constructs
- **Duplication**: Repeated logic, similar functions, copy-pasted code
- **Dead Code**: Unused imports/variables/functions, unreachable code, commented-out blocks
- **Poor Naming**: Vague names (data, temp, thing), inconsistent conventions, misleading function names
- **Bad Patterns**: God objects/functions, tight coupling, circular dependencies, try/catch/log anti-patterns

### 2. Bugs & Vulnerabilities
- **Security**: Hardcoded secrets, SQL injection, XSS vulnerabilities, insecure randomness
- **Logic Errors**: Missing validation, incorrect assumptions, edge cases
- **Resource Leaks**: Unclosed file handles, database connections, event listeners, memory leaks
- **Error Handling**: Silent failures, missing error cases, generic catch-all blocks

### 3. Performance & Efficiency
- **Algorithms**: Inefficient implementations, N+1 queries, unnecessary loops
- **Memory**: Object creation in loops, missing memoization, unreleased references
- **Async**: Synchronous operations that should be async, blocking calls

Don't complicate the code in the name of performance if the performance gain is _minimal_.

### 4. Maintainability
- **Documentation**: Missing/outdated comments, unclear business logic, missing type annotations
- **Configuration**: Hardcoded values, environment-specific code mixed with logic
- **Testing**: Console.logs in production, complex test setups, missing tests
- **Build/Deploy**: Complex builds, outdated tooling, poor documentation

### 5. Usability & Features
- **UX Problems**: Confusing interfaces, missing obvious features
- **Tech Choices**: Questionable libraries, non-standard solutions to common problems

## Output Format

Create individual files in `docs/tasks` directory - one file per issue.

### File Naming
Use descriptive names: `login-validation-bug.md`, `duplicate-user-service.md`, `performance-image-loading.md`

### Required Content for Each File

```markdown
# [Clear Problem Title]

## Problem
- **Location**: Exact file paths (e.g., `src/auth/login.ts:45-67`)
- **Description**: What's wrong and why it matters
- **Current vs Expected**: How it behaves now vs how it should behave

## Solution
- Detailed implementation approach
- Code samples where helpful
- Links to documentation/examples if relevant

## Impact
- **Type**: Pure refactoring OR Behavior change (describe what changes)
- **Risk**: Low/Medium/High
- **Complexity**: Simple/Moderate/Complex  
- **Benefit**: Quick win/Medium impact/High value

## Implementation Notes
[Any additional context to help the implementor]
```

## Prioritization

Focus on finding:
1. **High Priority**: Security issues, obvious bugs, data loss risks
2. **Quick Wins**: Quick (but elegant and complete) fixes with good impact
3. **Big Impact**: Major performance issues, large duplications, architectural problems

## Key Principles

- **Be Specific**: Always include exact file paths and line numbers
- **Be Actionable**: Provide enough detail for any developer to implement
- **Modern Patterns**: Use async/await, destructuring, optional chaining
- **Let Errors Bubble**: Don't catch and hide errors by default