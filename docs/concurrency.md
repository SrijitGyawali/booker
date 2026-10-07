# Concurrency

> **Status:** planned. Core section written on **Day 13**, extended on Days 40–41.

## To cover

- **Booking under contention:** how booker guarantees it never sells more seats
  than an event has, even with several API instances running (Day 13).
- **Evidence:** the concurrency test, how to run it, and its results in
  [`notes/benchmarks/`](../notes/benchmarks/).
- **Bounded concurrency:** the CSV import worker pool, cancellation and
  goroutine-leak prevention (Day 40).
- **Real-time fan-out:** pushing live seat counts to clients across instances
  (Day 41).
