# Day 0: Tools, project skeleton and the documentation system

> **Date:** 2026-10-07
>
> Sections 1 and 3 record what was set up. Everything else is for me to write
> in my own words before ticking Day 0 in the tracker.

## 1. Problem

Before any backend code, booker needs a repeatable local environment (Go,
PostgreSQL, Redis), a home for every kind of artifact (code, docs, ADRs, notes,
benchmarks), and guard rails so a secret never reaches git.

## 2. Mental model

<!-- Draw it: docker-compose.yml → images → containers → named volumes →
     ports on 127.0.0.1. Where does the data live when a container is deleted? -->

## 3. What I built

- Go module `github.com/SrijitGyawali/booker` (Go 1.26)
- `docker-compose.yml`: PostgreSQL 18 and Redis 8 with healthchecks, named
  volumes and ports bound to `127.0.0.1`. Passwords are required from `.env`;
  Compose refuses to start without them.
- `.gitignore` committed **first**, before any secret existed; `.env.example`
  with every key and empty values.
- `.githooks/pre-commit`: blocks `.env` files, private keys, token-shaped
  strings and unformatted Go.
- Cross-shell `Makefile` (`make up`, `make psql`, `make check`, …) and a
  golangci-lint v2 config.
- Documentation system: `docs/` (with `adr/` and `diagrams/`) for how booker
  works, `notes/` (with `benchmarks/`) for what I learn.

Verified:

```sh
docker compose ps        # postgres and redis: "Up (healthy)"
git check-ignore .env    # prints: .env
```

## 4. Important concepts

<!-- One or two lines each, in my own words -->

- `go mod init` / `go get` / `go mod tidy`:
- Image vs container:
- Named volume vs bind mount:
- Port mapping `127.0.0.1:5432:5432`, and why bind to `127.0.0.1`:
- Why `.env` must be in `.gitignore` *before* the first secret exists:
- Why deleting a commit doesn't undo a leaked secret:

## 5. Production concerns

## 6. Trade-offs and decisions

<!-- e.g. Docker Compose vs installing PostgreSQL natively; Makefile vs Taskfile -->

## 7. Interview questions

**Q:** What is the difference between a Docker image and a container?
**My answer:**

**Q:** What does `go mod tidy` do, and when do you run it?
**My answer:**

**Q:** How do you keep secrets out of a git repository? What do you do if one leaks?
**My answer:**

## 8. Explain it at three levels

- **15 s:**
- **60 s:**
- **5 min (outline):**

## 9. Mistake I made today

## 10. One-line revision

