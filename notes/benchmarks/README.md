# Benchmarks

**Measured numbers only.** Every number in the README, on a resume or in an
interview answer must trace back to a file here, with the dataset, machine,
exact command and raw output. If it can't be reproduced from the file, it
doesn't count.

| File | Question it answers | Day |
|------|---------------------|-----|
| `booking-concurrency.md` | How many bookings succeed for N seats under concurrent load, before and after the fix? | 13 |
| `indexes.md` | How much does the right index change the event-listing query? | 14 |
| `cache.md` | What does the cache save on `GET /events/{id}`? | 31 |
| `load-test.md` | What is the first bottleneck under load, and what did fixing it change? | 44 |

## Rules

- Copy [`_template.md`](_template.md) for every new benchmark.
- Change **one** thing between *before* and *after*.
- Warm up first, run several times, and report percentiles (p50 / p95 / p99),
  not a single run or an average.
- Record the machine. Laptop numbers on battery are not comparable to CI numbers.
- Paste the raw output.
