---
description: Smart prompt - unified advisor selects appropriate MCP servers or agents, then executes
---

# P Command (Smart Prompt)

**User Request**: $ARGUMENTS

## Check if prompt is context-dependent

If $ARGUMENTS contains vague references like "that", "it", "the thing", "what we discussed", "as mentioned", etc.:
- The prompt likely refers to previous conversation context
- Summarize the relevant context from our conversation into a self-contained description
- Create an enriched prompt that combines: "[Context: specific description of what we're discussing] + $ARGUMENTS"
- Use this enriched prompt instead of raw $ARGUMENTS when calling the advisor

Otherwise, if the prompt is self-contained and specific:
- Use $ARGUMENTS directly

## Call the prompt advisor

Use the Task tool to ask the unified prompt advisor:
```
Task(
    description="Analyze prompt",
    prompt="[enriched_prompt or $ARGUMENTS as determined above]",
    subagent_type="prompt-advisor"
)
```

Print the advisor's response so you can see what tools were selected:
    "Prompt advisor output: [advisor's response]"

Based on the advisor's response:

1. **If response starts with "mcp:"**
   - Extract the MCP server names after the colon
   - For each MCP server, trigger it by saying what you're doing then adding the trigger
   - Example: "I'll check the API documentation. use context7"

2. **If response starts with "agents:"**
   - Extract the agent names after the colon
   - For each agent name, use the Task tool to invoke that agent with the original request
   - Example: If advisor returns "agents: auditor, code-quality-enforcer", then invoke:
     Task(description="Review code", prompt="$ARGUMENTS", subagent_type="auditor")
     Task(description="Check quality", prompt="$ARGUMENTS", subagent_type="code-quality-enforcer")

3. **If response is "none"**
   - This might mean no tools match OR the prompt was too vague
   - If the original prompt was context-dependent, handle it directly with full conversation context
   - Otherwise, handle the request directly using built-in tools