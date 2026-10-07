# docs/

**How booker works**, written for an engineer joining the project: facts about
this system and the reasons behind them. What I learned while building it
lives in [`notes/`](../notes/).

| Document | Covers | Written |
|----------|--------|---------|
| [architecture.md](architecture.md) | Components, request lifecycle, package layout, configuration | Day 6, updated Day 39 |
| [database.md](database.md) | Schema, migrations, transactions, indexes, pagination | Days 8–15 |
| [concurrency.md](concurrency.md) | Booking under contention, worker pools, real-time fan-out | Days 13, 40–41 |
| [authentication.md](authentication.md) | Passwords, tokens, verification flows, OAuth, authorization | Days 20–28 |
| [caching.md](caching.md) | What is cached, invalidation, failure behaviour | Day 31 |
| [background-jobs.md](background-jobs.md) | Queue, retries, idempotency, transactional outbox | Days 33–34, 42 |
| [observability.md](observability.md) | Logs, metrics, traces, health probes, profiling | Days 36–37 |
| [scaling.md](scaling.md) | A one-million-user concert sale | Day 49 |
| [adr/](adr/) | Why each project-wide decision was made | ongoing |
| [diagrams/](diagrams/) | The seven system diagrams | ongoing |

## Writing rules

- Describe the system **as it is**. Update a doc in the same commit as the code
  it describes.
- Every component gets a decision block:

  ```markdown
  **Problem:** what hurt without it
  **Decision:** what booker does
  **Why:** the reasoning
  **Trade-off:** what it costs
  **Failure behaviour:** what happens when it breaks
  **Alternative rejected:** and why
  ```

- Project-wide choices also get an [ADR](adr/).
- Numbers come only from [`notes/benchmarks/`](../notes/benchmarks/).
