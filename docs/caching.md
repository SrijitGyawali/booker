# Caching

> **Status:** planned. Written on **Day 31**, and only after measuring that a
> cache is actually needed.

## To cover

- **What is cached**, under which keys and for how long; what is never cached.
- **Read and write paths:** how a request is served, and which writes
  invalidate which keys.
- **Stampede protection:** what happens when a popular key expires under load.
- **Failure behaviour:** how booker behaves when Redis is down.
- **Multiple instances:** why the cache is shared, not in-process.
- **Evidence:** latency with and without the cache, in
  [`notes/benchmarks/`](../notes/benchmarks/).
