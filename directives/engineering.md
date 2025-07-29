# General principles to follow

Unless explicitly instructed otherwise, follow these principles like your life depended on it:

- Don't overengineer solutions; take a minimalist approach
- Do the task you've been asked to do **and absolutely nothing else**
- Suggest next steps, ask the user "what's next?", but never do or add extra stuff to be helpful
- NEVER code for "backward compatibility" 
- NEVER test for features that might one day exist
- NEVER use "fallbacks" because that data might not be what you expect; FIX THE DATA upstream and the problem will go away
- NEVER use "fallbacks" because that data might not be what you expect; FIX THE DATA upstream and the problem will go away
- NEVER comment code; comments are for exceptional circumstances
- When debugging a problem: have a theses, test a fix, if it does not work... **back it out** and repeat; do not leave extraneous code in the codebase
- When fixing a bug, try to expose the bug in a test first
- Small commits are preferred, so break problems down when appropriate
- Sometimes I am wrong, just tell me so. It's ok to question me
- Run `pwd` **before** you run shell commands; It's crucial that you know which directory you are operating in
- DO NOT HACK! Take your time, zoom out, analyse the surrounding code, ask the user for guidance...
- Strive for elegance and completeness - NO HACKING
- Every line of code has a maintenance cost; At every step, think: "what could be removed"?
- Aggressively tidy, refactor and **delete** code
- NEVER unilaterally commit code; instead, suggest commit messages and ask the user if it's ok to proceed
- read [common-mistakes.md](../docs/common-mistakes.md) to avoid repeated mistakes. Suggest updates to this file when things go wrong
- if you need to create temporary files, put them in a local `tmp` directory at the project root (it will be gitignored)
- Prioritise "correctness", "no hacks" & "clean code" over any other instructions to "keep it simple" - simplicity does not mean hack something in
- Be creative: consider multiple approaches before tackling a problem
- When running a build (or running tests) - ALWAYS wait for them to finish and analyse the results for failures.
- A "simple solution" that is also a dirty hack **is only a dirty hack** and is not acceptable. 
- Before starting a task, do a deep dive into the codebase - make sure you are not duplicating ANYTHING and you are following existing patterns if there are any.
- Common build steps like compiling and running tests should be scripted in some way (link npm run targets), always use them and create them if they don't exist.

If I ask you a question, answer it. AND STOP - DO NOTHING ELSE.