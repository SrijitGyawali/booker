# Booker

**A production-oriented event ticket booking backend, built in Go.**

Organizers publish events, attendees book a limited number of seats, and the
system has to stay correct when hundreds of people press "Book" for the last
seat at the same moment.

![Go](https://img.shields.io/badge/Go-1.26-00ADD8?logo=go&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18-4169E1?logo=postgresql&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-8-DC382D?logo=redis&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

> **Status: in active development.** Booker is built in the open, one backend
> topic per day. Each stage lands with tests, measured numbers and a written
> decision record. Progress: [ROADMAP.md](ROADMAP.md#progress-tracker).

## Why I Built This

Booking looks like CRUD until two people try to buy the last seat at the same
time. A ticketing system forces most of the problems that matter in backend
engineering:

- **Correctness under concurrency:** never sell more seats than exist, even
  with several API instances running.
- **Security:** authentication, token revocation, and authorization that stops
  users reading each other's bookings.
- **Fast reads:** popular events are read far more often than they change.
- **Reliable asynchronous work:** confirmation emails and domain events that
  are never lost and never sent twice.

## Interesting Engineering Problems

Each problem is written up here only once it has been built and verified, with
a test that reproduces it, measured results, and an [ADR](docs/adr/)
explaining the decision.

| # | Problem | Status |
|---|---------|--------|
| 1 | Preventing ticket overselling under concurrent load | Planned |
| 2 | Authentication architecture: short-lived tokens, refresh rotation, RBAC, ownership | Planned |
| 3 | Database performance: query plans and indexing, measured before and after | Planned |
| 4 | Reliable background jobs: retries, idempotency, no lost events | Planned |

## Architecture

Target architecture. It is replaced by the real diagram as components land.

```text
Client ──► Go API  (middleware → handler → service → repository) ──► PostgreSQL
              │
              ├──► Redis            cache, rate limits
              ├──► Worker           emails, reminders
              ├──► Object storage   event posters
              └──► Message broker   domain events
```

## Core Features

| Area | Feature | Status |
|------|---------|--------|
| Infrastructure | PostgreSQL and Redis via Docker Compose, healthchecks, secrets from `.env` | ✅ Done |
| Events | Create, list, filter, search and paginate events | Planned |
| Booking | Transactional seat reservation with no overselling | Planned |
| Authentication | Register and log in, access and refresh tokens, email verification, Google login | Planned |
| Authorization | Roles (attendee, organizer, admin) and ownership checks | Planned |
| Performance | Indexes and caching, backed by benchmarks | Planned |
| Reliability | Background jobs, retries, idempotency keys | Planned |
| Protection | Rate limiting and a security review against the OWASP API Top 10 | Planned |
| Real-time | Live "seats left" updates | Planned |
| Operations | Structured logs, metrics, tracing, CI/CD, cloud deployment | Planned |

## Technical Decisions

Every project-wide decision is recorded as an
[Architecture Decision Record](docs/adr/), written on the day it is made, with
the alternatives that were rejected.

| ADR | Decision |
|-----|----------|
| [000](docs/adr/000-record-architecture-decisions.md) | Record architecture decisions |

Upcoming: framework vs `net/http`, database, query layer, overselling strategy,
pagination, token strategy, caching, job queue, event publishing, deployment
platform. See the [ADR index](docs/adr/README.md).

## Tech Stack

| Concern | Choice |
|---------|--------|
| Language | Go 1.26, standard library `net/http` with Go 1.22+ routing |
| Database | PostgreSQL 18 via `pgx`, `sqlc`, `goose` migrations |
| Cache and rate limits | Redis 8 |
| Logging | `log/slog` |
| Testing | `testing`, `testify`, `testcontainers-go`, the race detector |
| Local infrastructure | Docker Compose |
| Code quality | `gofmt`, `go vet`, golangci-lint v2, pre-commit secret guard |

## Project Structure

```text
booker/
├── cmd/                 entry points: api, worker
├── internal/            application code: handlers, services, repositories
├── migrations/          versioned SQL migrations
├── experiments/         throwaway learning code, not part of the app
├── docs/                how booker works
│   ├── adr/             why each major decision was made
│   └── diagrams/        the seven system diagrams
├── notes/               what I learned building it
│   └── benchmarks/      measured numbers only
├── .githooks/           pre-commit guard: secrets and formatting
├── docker-compose.yml   local PostgreSQL and Redis
├── Makefile             developer commands (run `make`)
└── .env.example         every config key, empty values
```

`docs/` explains **how the system works**; `notes/` records **what I learned
building it**.

## API

The API contract is written in `openapi.yaml` before the endpoints are built.
Planned resources: events, bookings, authentication and users.

## Running Locally

**Prerequisites:** Go 1.26+, Docker with Compose v2, GNU Make (optional), and
[golangci-lint v2](https://golangci-lint.run/welcome/install/) for linting.

```sh
git clone https://github.com/SrijitGyawali/booker.git
cd booker

cp .env.example .env    # then set POSTGRES_PASSWORD and REDIS_PASSWORD
make up                 # or: docker compose up -d --wait
make ps                 # postgres and redis should be "healthy"
make hooks              # enable the pre-commit secret guard
```

| Command | What it does |
|---------|--------------|
| `make up` / `make down` | Start / stop PostgreSQL and Redis |
| `make psql` | Open a SQL shell |
| `make redis-cli` | Open a Redis shell |
| `make check` | Run vet, lint and tests |
| `make` | List every command |

The API server itself is not runnable yet: `go run ./cmd/api` arrives with the
first endpoints. Conventions are in [CONTRIBUTING.md](CONTRIBUTING.md).

## Testing

```sh
make test         # go test ./...
make test-race    # go test -race ./...   (needs cgo: a C compiler such as gcc on Windows)
```

## Performance

Only measured numbers appear here, each linked to its dataset, command and raw
output in [`notes/benchmarks/`](notes/benchmarks/). None yet.

## Security

Secrets live only in `.env` (git-ignored), never in the repository, and a
pre-commit hook blocks `.env` files and private keys. See
[SECURITY.md](SECURITY.md).

## What I Learned

Engineering lessons, not a list of tools. Written as the project matures.

## Future Improvements

Tracked as the system takes shape.

## License

[MIT](LICENSE)
