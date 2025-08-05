---
description: Quick optimizer - invokes the powerful meta-prompt agent for intelligent tool selection
---

# P Command (Quick Optimizer)

**User Request**: $ARGUMENTS

Use the Task tool to launch the meta-prompt agent with this prompt:
"Follow your initialization protocol and handle this request with STRICT scope discipline:

SCOPE RULES - Do exactly what was asked and NOTHING MORE:
- Question? Answer only, don't take action
- Asked for commit message? Write it, don't commit  
- Asked to fix bug? Fix it, don't change any other code
- Asked to analyze? Analyze, don't implement
- When in doubt, do LESS

USER REQUEST: $ARGUMENTS"