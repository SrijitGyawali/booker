# Background Jobs and Events

> **Status:** planned. Written on **Day 33**, extended on Days 34 and 42.

## To cover

- **Why work leaves the request path:** the jobs that exist (booking
  confirmation, verification and reset emails, event reminders).
- **Queue and worker:** which queue, how jobs are enqueued, and the worker
  process in `cmd/worker`.
- **Retries:** backoff, maximum attempts, what happens to jobs that keep failing.
- **Idempotency:** why a job that runs twice has no double effect, and how
  `POST` requests are made safe to retry (Day 34).
- **Domain events:** how booking events reach other components without a
  dual-write problem (Day 42).
- **Diagrams:** background-job flow and event flow, in [`diagrams/`](diagrams/).
