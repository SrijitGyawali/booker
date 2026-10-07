# ADR-000: Record architecture decisions

- **Status:** Accepted
- **Date:** 2026-10-07
- **Roadmap day:** 0

## Context

Booker is built over eight weeks, one topic a day. The decisions that shape it
(framework or standard library, query layer, how to prevent overselling, token
design, job queue, deployment platform) are made on different days, each with
its own context and its own rejected alternatives.

Without a written record, that reasoning is lost. Six weeks later, *"why didn't
you use GORM?"* can only be answered from memory, and a later change can
quietly undo an earlier decision without anyone noticing the trade-off.

## Decision

Record every significant, project-wide decision as an Architecture Decision
Record in `docs/adr/`, using [`template.md`](template.md).

- One decision per file, numbered in order: `NNN-short-title.md`.
- Written on the day the decision is made, while the context is fresh.
- Never rewritten. If a decision changes, a new ADR supersedes the old one and
  both stay in the repository.
- Component-level choices (a TTL, a pool size) go in the decision block of the
  relevant `docs/*.md` instead.

## Why

- The *why* and the rejected alternatives are captured, not only the outcome.
- Superseded ADRs keep the history of the design visible.
- One page each, so they actually get written and read.

## Trade-offs

- A small writing cost on every major decision.
- Judgment is needed on what counts as "significant".

## Alternatives considered

- **Commit messages only:** hard to find later, and no room for alternatives.
- **The README:** mixes the project pitch with design reasoning and grows too long.
- **An external wiki:** lives outside the repository and drifts away from the code.
