# my-ai-agent-prompts

For Claude Code and Gemini Cli.

For common behaviour for multiple agents, create an `AI_AGENT.md` file in the root of my project and symlink it to `CLAUDE.md` and `GEMINI.md`.

```shell
ln -s AI_AGENT.md CLAUDE.md
ln -s AI_AGENT.md GEMINI.md
```

I try to keep the file short, bespoke, but have it reference common _directive_ files as and when it needs:

```AI_AGENT.md

Before making **ANY** changes, you MUST read these files:

- directives/engineering.md
- directives/code-style.md
- directives/logging.md
- directives/testing.md

Summarise what you have learned form them.

... follow with project-specific instructions
```

Note: _getting Claude Code to follow instructions in its `CLAUDE.md` file is not easy, you can't just expect it to honour your instructions, no matter how clear they are._ 

Also use symlinks for these files in order to add them to any project (and gitignore them).

```shell
ln -s ../my-ai-agent-prompts/directives .

mkdir -p .claude/commands
ln -sf ../../../my-ai-agent-prompts/commands/hello.md .claude/commands/
ln -sf ../../../my-ai-agent-prompts/commands/analyse.md .claude/commands/
ln -sf ../../../my-ai-agent-prompts/commands/changes.md .claude/commands/
ln -sf ../../../my-ai-agent-prompts/commands/next-task.md .claude/commands/
ln -sf ../../../my-ai-agent-prompts/commands/fix.md .claude/commands/

# make sure to add these to your .gitignore
```

On starting a new claude shell, always run `/hello` first.

As a general approach, I create a `docs/tasks` directory in the root of every project.  Form here I add subdirectories, or not, as needed, and write all my bug reports, feature planning, refactorings as `.md` files. 

### Update cli tools

```shell
npm install -g @anthropic-ai/claude-code
npm install -g @google/gemini-cli
```