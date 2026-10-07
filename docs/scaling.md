# Scaling

> **Status:** planned. Written on **Day 49**.

The question this document answers: **how would booker handle a concert sale
with one million users in ten minutes?**

## To cover

- **Back-of-the-envelope numbers:** requests per second, read/write ratio, data size.
- **Stateless API:** horizontal scaling behind a load balancer.
- **Reads:** caching layers, CDN, read replicas.
- **Writes:** the seat-reservation strategy from [concurrency.md](concurrency.md)
  under extreme contention.
- **Admission control:** waiting room, queueing, rate limits.
- **Limits and failure modes:** connection limits, what breaks first, what
  degrades gracefully.
