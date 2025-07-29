# Next task

{{if $ARGUMENTS}}
Use the task file provided in the arguments: {{$ARGUMENTS}}
{{else}}
- Make sure there are no local changes, if there are, warn the user and do nothing else
- Pick the easiest task from docs/tasks (or any subdirectory). Prefer bugs/refactoring if any exist, otherwise choose a feature with a clear implementation path
- Prioritise bugs, cleanup and refactoring over new features: let's not build on shakey foundations
{{end}}

Decide weather or not it is a valid and worthwhile suggestion (it may not be), and if the suggestions and ideas in it are accurate, helpful and with enough detail (they may not be)

If you decide that the task is bogus in some way, or already completed, then delete it, report back, **and do nothing else**.

## Stop!

Ask the user if this is a good task to work on.

## Plan

- Build a detailed implementation plan for the task
- Zoom out, look at surrounding code, both upstream and downstream
- Existing code (that works perfectly), may need to be modified in order to accommodate the most effective and elegant solution 
- Be creative and consider multiple approaches
- Be consistent and follow existing patterns 
- If the task can be broken down into smaller steps that can be commited in isolation, update the `.md` file to reflect this
- Small commits are preferred
- Plan the minimum necessary work to complete the task

Write your plan back to the document.

## Stop!

DO NOT START WORK ON THE TASK UNTIL INSTRUCTED TO DO SO
