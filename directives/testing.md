# Testing Guide

## When to Run Tests

- Run individual tests as and when you make changes
- Run the full test suite after your changes are clean, complete and ready to commit
- Never "skip", comment out, or in any way subvert the tests in order to get a working build
- Wait for tests to finish, address or report any errors

## Guidelines for Writing Tests

- Test complexity must be lower than the code they exercise
- Focus on behaviour, not implementation details
- Avoid complex mocking setups; prefer builder patterns (see below)
- Remove redundant, outdated, pedantic, or low‑benefit tests
- Never test features that don’t exist yet
- Ignore theoretical edge cases that won’t occur (don't be pedantic)
- Avoid high maintenance tests with low benefit
- Delete pointless/outdated tests
- Factor out complex setup i order to make tests easy to read

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

## Testing Asynchronous Operations with Polling

For testing asynchronous operations where the timing is unpredictable (background jobs, database triggers, eventual consistency, etc.), use a polling pattern rather than fixed delays.

### The Pattern

The polling pattern repeatedly calls a data source until a matcher function returns true, or until a timeout is reached:

```typescript
// Generic polling method
async function pollUntil<T>(
  fetcher: () => Promise<T>,      // Function that retrieves data
  matcher: (value: T) => boolean, // Function that tests the condition
  options: {
    timeout?: number;    // Total timeout in ms (default: 10000)
    interval?: number;   // Polling interval in ms (default: 500)
    errorMsg?: string;   // Custom error message
  } = {}
): Promise<T> {
  const { timeout = 10000, interval = 500, errorMsg = 'Condition not met' } = options;
  const startTime = Date.now();
  
  while (Date.now() - startTime < timeout) {
    try {
      const result = await fetcher();
      if (await matcher(result)) {
        return result;
      }
    } catch (error) {
      // Log but continue polling (or fail fast if needed)
    }
    await new Promise(resolve => setTimeout(resolve, interval));
  }
  
  throw new Error(`${errorMsg} after ${timeout}ms`);
}
```

### Usage Example

```typescript
// Wait for async operation to complete
const result = await pollUntil(
  () => api.getResource(id),                    // How to fetch data
  (data) => data.status === 'completed',       // What condition to check
  { timeout: 15000, errorMsg: 'Operation did not complete' }
);

// Test the final state
expect(result.value).toBe(expectedValue);
```

### When to Use Polling

- **Database triggers**: When testing operations that depend on background functions
- **Message queues**: When testing async message processing
- **Search indexing**: When testing search functionality after document updates  
- **Cache updates**: When testing cached data invalidation/refresh
- **External APIs**: When testing webhooks or third-party integrations
- **File processing**: When testing file uploads, conversions, or analysis

### Best Practices

- **Use specific matchers**: Test for the exact condition you need, not just "something changed"
- **Set reasonable timeouts**: Start with 5-10 seconds, adjust based on actual operation timing
- **Provide descriptive error messages**: Include context about what condition was expected
- **Fail fast for errors**: Don't continue polling if the API returns permanent failures
- **Use exponential backoff**: For operations that might be expensive, increase intervals over time

### Example Matcher Functions

```typescript
// Wait for specific status
const hasStatus = (status: string) => (data: any) => data.status === status;

// Wait for property to exist
const hasProperty = (property: string) => (obj: any) => obj[property] !== undefined;

// Wait for minimum count
const hasMinCount = (minCount: number) => (list: any[]) => list.length >= minCount;

// Wait for value change
const valueChanged = (initialValue: any) => (data: any) => data.value !== initialValue;
```
