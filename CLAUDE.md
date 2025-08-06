# About
This project is a "meta" project which I use in other projects to help me with common tasks associated with ClaudeCode CLI  (and Gemini CLI to some extent).

It has some scripts in it that I run from a "real" project which setup some of the common ClaudeCode related things I want such as settings, permissions, mcp servers, subagents and commands.

We have defined a meta-prompt `"/p"` which is used to make _smart_ tool selection for any prompt. It will pick out appropriate mcp servers or other sub-agents that should be invoked / leveraged at prompt-time.