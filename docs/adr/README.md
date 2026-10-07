# Architecture Decision Records

An ADR records **one** significant, project-wide decision: the context, what
was decided, why, what it costs, and which alternatives were rejected. See
[ADR-000](000-record-architecture-decisions.md) for why booker keeps them.

## Adding an ADR

1. Copy [`template.md`](template.md) to `NNN-short-title.md` (the next free number).
2. Write it on the day the decision is made. Status: **Accepted**.
3. Add it to the index below and link it from the relevant `docs/*.md`.
4. Changing a decision? Write a new ADR that supersedes the old one, and mark
   the old one **Superseded by ADR-NNN**. Never rewrite an accepted ADR.

## Index

| ADR | Decision | Status |
|-----|----------|--------|
| [000](000-record-architecture-decisions.md) | Record architecture decisions | Accepted |

## Upcoming decisions

Each question gets an ADR on the day it is decided. The *answer* is written
then, after the trade-offs have been worked through, not now.

| Question | Day |
|----------|-----|
| A web framework, or the standard library's `net/http`? | 2 |
| Which primary database? | 8 |
| Query layer: ORM, sqlc or hand-written SQL? | 11 |
| How to prevent overselling under concurrent bookings? | 13 |
| Which pagination strategy for event listing? | 15 |
| Which token and session strategy? | 23 |
| How to cache event details? | 31 |
| Which background job queue? | 33 |
| How to publish domain events reliably? | 42 |
| Which deployment platform? | 48 |
