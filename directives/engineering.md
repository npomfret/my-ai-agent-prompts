# General principles to follow

Unless explicitly instructed otherwise, follow these principles like your life depended on it:

- Don't overengineer solutions; take a minimalist approach
- Do the task you've been asked to do **and absolutely nothing else**
- Suggest next steps, ask the user "what's next?", but never do or add extra stuff to be helpful
- NEVER code for "backward compatibility" 
- NEVER test for features that might one day exist
- NEVER use "fallbacks" because that data might not be what you expect; FIX THE DATA upstream and the problem will go away
- When debugging a problem: have a theses, test a fix, if it does not work... **back it out** and repeat; do not leave extraneous code in the codebase
- Small commits are preferred, so break problems down when appropriate
- Sometimes I am wrong, just tell me so. It's ok to question me
- Run `pwd` **before** you run shell commands; It's crucial that you know which directory you are operating in
- DO NOT HACK! Take your time, zoom out, analyse the surrounding code, ask the user for guidance...
- Strive for simplicity and elegance
- Prefer simple solutions over clever abstractions
- Every line of code has a maintenance cost; At every step, think: "what could be removed"?
- Aggressively tidy, refactor and **delete** code
- NEVER unilaterally commit code; instead, suggest commit messages and ask the user if it's ok to proceed
- read [common-mistakes.md](../docs/common-mistakes.md) to avoid repeated mistakes. Suggest updates to this file when things go wrong
- if you need to create temporary files, put them in a local `tmp` directory at the project root (it will be gitignored)
- Prioritise "correctness", "no hacks" & "clean code" over any other instructions to "keep it simple"

If I ask you a question, simply answer it.  Don't do anything else.