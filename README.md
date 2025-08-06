# AI Agent Prompt Framework

This project provides some useful tools for enhancing AI assistants like Claude Code CLI and Gemini CLI, transforming them into highly effective software engineering partners. It shifts from simple prompt-and-response to a structured, tool-driven workflow that enforces best practices and automates complex tasks.

At its core, this repository offers a collection of scripts, configurations, and predefined "agents" that you can easily integrate into your own projects. These components work together to create a more disciplined and capable AI development environment.

## Core Concepts

This framework is built on three key concepts:

1.  **MCP (Model Context Protocol):** A standardized way for the AI to connect with external tools and data sources. This project pre-configures several powerful MCP servers for tasks like live code analysis (`typescript-mcp`), documentation lookup (`context7`), and automated refactoring (`ts-morph`). This gives the AI real-time access to your codebase and external knowledge, reducing errors and hallucinations.

2.  **Specialized Subagents:** A team of AI "experts" defined in `.claude/agents/`. Each agent has a specific role and a strict set of instructions, such as:
    *   `architect-advisor`: Analyzes the codebase to determine the *best place* to make changes.
    *   `test-guardian`: Runs tests, enforces quality, and cleans up failing or skipped tests.
    *   `scope-guardian`: Ensures the AI does *exactly* what you asked for, preventing feature creep.
    *   `anti-pattern-detector`: Scans for bad coding practices like fallbacks, hacks, and error suppression.

3.  **The `/p` Meta-Prompt:** The heart of the workflow. Instead of trying to remember the right tools or agents for a task, you simply prefix your request with `/p`. This command analyzes your intent and automatically selects the optimal combination of MCP servers and agents to execute your request efficiently and safely.

By combining these elements, this project transforms your AI assistant from a simple chatbot into a disciplined, context-aware, and tool-equipped engineering assistant.

## Getting Started

You can set up a new or existing project with this framework by running a single script.

From within your project's root directory, run:

```shell
# Execute the setup script from your clone of this repository
cd path/to/my/project
/path/to/my-ai-agent-prompts/scripts/setup-all.sh .
```

This command will:
-   Create a central `AI_AGENT.md` configuration file.
-   Symlink `CLAUDE.md` and `GEMINI.md` to `AI_AGENT.md`.
-   Create a `.claude` directory and symlink all the predefined **commands** and **agents**.
-   Configure shared **MCP servers** in `.mcp.json`.
-   Update your `.gitignore` to exclude temporary files and local configurations.

The setup is idempotent and safe to re-run at any time to sync the latest changes.

## The Workflow

Your development workflow becomes simple and powerful.

### Always Start with `/p`

Prefix every request to your AI assistant with `/p` (`p` for "prompt").

```
/p fix the login bug in issue #123
/p refactor the user service to be more efficient
/p add dark mode to the settings page
/p analyze the bundle size and suggest optimizations
```

The `/p` command automatically analyzes your request, selects the appropriate tools (MCP servers) and experts (subagents), and then executes the task. It removes the cognitive load of remembering tool names and ensures best practices are followed every time.

### Example: Fixing a Bug

1.  **Your Prompt:**
    ```
    /p fix the TypeError in user.service.ts on line 45
    ```

2.  **What Happens Automatically:**
    *   The `/p` command invokes the `architect-advisor` agent to analyze the codebase and determine the root cause of the error, rather than just patching the symptom.
    *   It uses the `typescript-mcp` server to get real-time type information and diagnostics from your code.
    *   Once the fix is implemented, it might use the `test-guardian` to run relevant tests and the `scope-guardian` to ensure no unrelated code was changed.
    *   Finally, it can use the `auditor` agent to review the changes and draft a commit message.

## Available Tools

This framework comes with a pre-configured set of agents and commands.

### Key Subagents

-   **`analyst`**: Performs deep codebase analysis to identify areas for improvement.
-   **`architect-advisor`**: Advises on *where* to make changes for best system design.
-   **`auditor`**: Reviews final changes and creates commit messages.
-   **`scope-guardian`**: Prevents scope creep and over-engineering.
-   **`test-guardian`**: Manages all aspects of testing, from running to cleanup.
-   **`code-quality-enforcer`**: Detects a wide range of style, syntax, and pattern violations.

You can see a full list of agents in the `.claude/agents` directory after setup.

### Key Commands

-   `/analyse`: Perform a comprehensive analysis of the codebase.
-   `/fix`: Find and fix the single most impactful issue in the project.
-   `/changes`: Review the current uncommitted changes and generate a commit message.
-   `/next-task`: Intelligently select the next task to work on from a `docs/tasks` directory.

## Why Use This Framework?

-   **Discipline & Best Practices:** Agents enforce rules that are easy for humans (and AIs) to forget, like "don't commit commented-out code" or "fix tests, don't skip them."
-   **Efficiency:** The `/p` command and MCP servers automate tedious tasks like looking up documentation, finding function references, or running tests.
-   **Reduced Errors:** By connecting directly to your codebase with Language Server Protocol (LSP) and other tools, the AI has real-time, accurate context, leading to fewer mistakes.
-   **Consistency:** The framework ensures that every task, whether it's fixing a bug or adding a feature, follows the same high-quality process.
