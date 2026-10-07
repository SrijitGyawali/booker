# <What was measured>

> **Date:** YYYY-MM-DD · **Day:** NN · **Commit:** `<hash>`

**Question:** what is this measurement meant to answer?
**Dataset:** e.g. 1,000,000 events (`make seed N=1000000`)
**Machine:** CPU, RAM, OS; Docker or native; anything else running
**Query / endpoint:**
**Tool and command:** the exact command, so anyone can re-run it

## Before

| Metric | Value |
|--------|-------|
| p50 | |
| p95 | |
| p99 | |

Plan / observations:

## Change

The one thing that changed between the two runs.

## After

| Metric | Value |
|--------|-------|
| p50 | |
| p95 | |
| p99 | |

Plan / observations:

## Conclusion

One or two sentences. Claim only what the numbers show.

## Raw output

```text
paste EXPLAIN ANALYZE / k6 / go test -bench output here
```
