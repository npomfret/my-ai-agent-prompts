# Coding Style & Patterns Guide

Unless instructed to do otherwise, follow these principles:

## Core Principles
- **No duplication or hacks** for backward compatibility or uncertain data formats
- **Keep it minimal and elegant**—write the fewest correct lines, avoid superfluous helpers or configs
- **Every line is production‑ready**; tidy, delete, and refactor relentlessly

- Embrace type safety everywhere you can
- Assume we always want the most modern syntax

## Fail fast
- validate early and blow up if data/state is not perfect
- do not trust data coming into the system from external sources
- do trust data once it's in the system - don't _over validate_ at every step
- throw on invalid state with clear error messages
- crash on broken state with clear error messages

## Functions & State
- Inline single‑use private functions; avoid extracting tiny helpers
- Minimise class state
- Minimise mutable state

## Comments & Logging
- No comments unless something is truly weird—code
- Remove stale or unhelpful remarks
- read [logging.md](logging.md)

## Dependencies
- Add external libraries **only when essential**; small bespoke code beats large dependency chains
- Use build it libs and api calls over external libs (e.g. use the NodeJS `request` functions over an http library)

## Architectural Patterns
- **Prefer elegant code** over clever abstractions
- **Avoid silent fallbacks**; let obvious errors surface
- For web dev: do **not** minify or obfuscate, but do use gzip headers and gzip content (including with websockets)

## Workflow Touch‑Points (Style Related)
- Reuse **existing nearby patterns** rather than inventing new structures
- Break problems down into deliverable steps
- Commit in **small, focused chunks**
- Suggest next steps after work is done
- Zoom out and look at the big picture, the source of an error could be upstream of the code that's being edited
- Update task documentation as you go