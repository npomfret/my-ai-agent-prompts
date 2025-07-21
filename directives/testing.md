# Testing Guide

## When to Run Tests

- Run individual tests as and when you make changes
- Run the full test suite after your changes are clean, complete and ready to commit
- Never "skip", comment out, or in any way subvert the tests in order to get a working build.

## Guidelines for Writing Tests

- Under‑testing is worse than over‑testing
- Tests must be easy to read and maintain
- Test complexity must be lower than the code they cover
- Focus on behaviour, not implementation details
- Avoid complex mocking setups; prefer builder patterns (see below)
- Remove redundant, outdated, pedantic, or low‑benefit tests
- Never test features that don’t exist yet
- Ignore theoretical edge cases that won’t occur: don't be pedantic
- Avoid high maintenance tests with low benefit
- Delete pointless/outdated tests

## Builders

Mocks are useful, but the builder pattern is simple and very powerful. It can be used to reduce the lines of coded needed in test setup **and** helps to focus the test on what's important.

Avoid this:

```typescript
const foo = {
    name: "bob",
    age: 66,
    location: "the moon",// only this one is imporant
    occupation: "stunt guy"
}

const res = app.doSomething(foo);

assert(res)...
```

Instead, use a builder:
```typescript
const foo = new FooBuilder()
    .withLocation("the moon")
    .build();

const res = app.doSomething(foo);

assert(res)...
```
