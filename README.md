# my-ai-agent-prompts

For Claude Code and Gemini Cli.

I create an `AI_AGENT.md` file in the root of my project and symlink it to `CLAUDE.md` and `GEMINI.md`.

```shell
ln -s AI_AGENT.md CLAUDE.MD
ln -s AI_AGENT.md GEMINI.MD
```

I try to keep the file short, and have it reference other files as and when it needs:

```
Before making **any** code changes, carefully read and analyse the guidance in: 
  - [engineering.md](directives/engineering.md)
  - [code-style.md](directives/code-style.md)
  - [logging.md](directives/logging.md)
  - [testing.md](directives/testing.md)
  
.. now follow with project specific instructions
```

Also use symlinks for these files in order to add them to any project (and gitignore them).

```shell
ln -s ../my-ai-agent-prompts/directives .
ln -sf ../../../my-ai-agent-prompts/commands/analyse.md .claude/commands/
ln -sf ../../../my-ai-agent-prompts/commands/changes.md .claude/commands/
ln -sf ../../../my-ai-agent-prompts/commands/next-task.md .claude/commands/

# make sure to add these to your .gitignore
```

As a general approach, I create a `docs/tasks` directory in the root of every project.  Form here I add subdirectors, or not, as needed, and write all my bug reports, feature planning, refactorings as `.md` files. 