# Changes

read @AI_AGENT.md

Analyse the current change list from a fresh perspective, and critique it.

Check for untracked new files:
 - Delete them if they are not need
 - Add them to git if they are needed
 - Or in exception circumstance, make sure they are gitignored

Check the change set for superfluous code or extraneous changes.

Don't be pedantic, if it's mostly ok just say so.  Focus on important things like:

* obvious bugs
* security blunders
* performance or scalability bottlenecks
* dirty hacks

Run any relevant builds and tests.

If it's ok to commit, **produce a nice commit message** and stop.

DO NOT: git **COMMIT**, git **PUSH** or create a PR
