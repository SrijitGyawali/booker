# Debugging Log

Every meaningful bug I caused and fixed while building booker. This is the
answer to *"tell me about a difficult bug"*: real symptoms, real causes, and
how I proved the fix works.

## Entry format

```markdown
## <Short name of the bug> (Day NN)

**Symptom:** what I saw: the error, the wrong output, the numbers
**Cause:** what was actually wrong
**Wrong assumption:** what I believed that turned out to be false
**Why that isn't production-safe:** (if the assumption was a tempting shortcut)
**Fix:** what I changed (commit: <hash>)
**How I verified:** the test, command or measurement that proves it
```

## Bugs this roadmap tends to produce

Ticked once it has happened and been logged below.

- [ ] Concurrent map writes (Day 2)
- [ ] CORS pre-flight failure that `curl` doesn't show (Day 4)
- [ ] Context cancellation not propagated (Day 5)
- [ ] Connection pool exhausted (Day 9)
- [ ] N+1 queries (Day 11)
- [ ] Repository call that escapes the transaction (Day 12)
- [ ] Ticket overselling (Day 13)
- [ ] JWT claim or expiry not validated (Day 22)
- [ ] Stale cache after an update (Day 31)
- [ ] Duplicate background job (Day 33)
- [ ] Goroutine leak (Day 40)

---

<!-- Entries go below, newest first. -->
