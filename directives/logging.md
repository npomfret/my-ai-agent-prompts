# Logging 

In general, don't use the console. Always use a logger (including in-browser). Use of the console is fine if you are debugging, but remember to remove them.

## _Audit_ observations instead of lazily logging:

Avoid:
```
logger.debug('user name changed from steve to bob')
```

Prefer:
```
logger.debug('detected name change', {before: 'steve', after: 'bob'}))
```

## try/catch/log is evil
Avoid `try/catch/log` as it often results in inconsisent state. It is often desireable to have exceptions bubble out.  We **always** want to know if the app is broken.

Avoid `try/catch/log/throw` unless you are adding context as errors often get logged multiple times. Instead, as node doesn't have exception chaining, this is ok:

```
    try {
        // do thing that might go wrong
    } catch (e: any) {
        e.someExtraContext = foo;
        throw e;
    }
```

When exceptions occur due to, perhaps, unexpected data, go _upstream_ and look for the source of the problem instead of using a try/catch block.

## Stacktraces are crucial
Avoid catching an error and throwing a new one as it will lose the original stacktrace.

## Web

In the browser, avoid logging objects (because the output is difficult to copy). Instead, JSON.stringify them (the logger should handle this)

