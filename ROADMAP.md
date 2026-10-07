# Go Backend Engineer Roadmap: one topic per day

You know Go syntax, goroutines, channels and mutexes. This roadmap turns that
into **backend engineering skill**: one topic per day, learned deeply and
**built into a real project**, so that in an interview you can say *"I built
this, here is how it works, here is why I chose it, and here is the proof."*

- **Length:** 57 days (Day 0 + 56 days), about 8 weeks.
- **Pace:** about 4–5 focused hours per day. If you have less time, take two
  days per topic. The order matters more than the speed.
- **Rule:** a day is finished only when you can **explain the topic out loud
  without notes**, the note is written, and the code is **committed**.

> **The main idea:** don't spend 56 days collecting technologies. Spend them
> **collecting engineering stories**: real problems you hit, the decisions you
> made, and the evidence that your fix works. By the end you want 8–10 stories
> you know extremely well (see [The 10 stories](#the-10-engineering-stories-you-are-collecting)).

---

## Contents

1. [The project: booker](#the-one-project-you-build-booker-an-event-ticket-booking-api)
2. [Repository layout: what goes where](#repository-layout-what-goes-where)
3. [Rules for every day](#rules-for-every-day)
4. [Where to go deepest](#where-to-go-deepest)
5. [Phase overview](#phase-overview)
6. [The 56 days](#phase-0-setup)
7. [Templates](#templates): daily note · decision · ADR · debugging · benchmark · interview bank · booker README · diagrams · commits
8. [The 10 engineering stories](#the-10-engineering-stories-you-are-collecting)
9. [Progress tracker](#progress-tracker)

---

## The one project you build: `booker`, an event ticket booking API

Do **not** build 30 small tutorial apps. Build **one** real project that grows
every day. Interviewers remember one strong project with depth much better than
ten to-do apps.

**booker** lets organizers create events and lets users book tickets. It is a
good choice because it naturally needs almost every backend skill:

| Feature | Skill it forces you to learn |
|---------|------------------------------|
| Sign up, log in, roles (attendee / organizer / admin) | Authentication, authorization |
| Create / list / search events | REST design, validation, pagination, indexes, search |
| Book tickets with limited seats | **Transactions, locking, race conditions** (your best interview story) |
| "Your booking is confirmed" email | Background jobs, retries, idempotency |
| Upload an event poster | File uploads, object storage |
| Live "seats left" counter | WebSockets / SSE, concurrency |
| Popular events load fast | Caching with Redis |
| Protection from abuse | Rate limiting, security |
| Runs in the cloud with a real URL | Docker, CI/CD, deployment, observability |

Create a **new GitHub repo** for it (e.g. `booker`). Commit your real work every
day. That gives you an honest, daily contribution streak, and a commit history
that shows how the project grew.

**Tech choices (keep them, don't switch mid-way):**
Go standard library `net/http` (Go 1.22+ routing) · PostgreSQL + `pgx` ·
`sqlc` · `goose` (or `tern`) for migrations · Redis · Docker Compose ·
`log/slog` · `testify` + `testcontainers-go`.

> You already studied a production codebase that uses **Echo + zerolog** (this
> PGG repo). Building booker on the **standard library + slog** means you'll
> understand what frameworks do for you, and you can compare both approaches in
> interviews.

---

## Repository layout: what goes where

```
booker/
├── README.md              ← the story for recruiters (finished project, not a diary)
├── SECURITY.md            ← security review summary (Day 38)
├── openapi.yaml           ← API contract (Day 3)
├── .env.example           ← every config key, EMPTY values (committed)
├── .env                   ← real secrets (NEVER committed; in .gitignore)
├── docker-compose.yml
├── Makefile / Taskfile.yml
│
├── cmd/                   ← entry points (api, worker)
├── internal/              ← the application code
├── migrations/            ← SQL migrations
├── experiments/           ← throwaway learning code (e.g. the Day 1 raw TCP server)
│
├── docs/                  ← HOW BOOKER WORKS (written for other engineers)
│   ├── architecture.md
│   ├── authentication.md
│   ├── database.md
│   ├── concurrency.md
│   ├── caching.md
│   ├── background-jobs.md
│   ├── observability.md
│   ├── scaling.md
│   ├── adr/               ← WHY you chose each major approach (one short file each)
│   │   ├── 001-use-net-http.md
│   │   └── ...
│   └── diagrams/          ← 7 major diagrams (see Template H)
│
└── notes/                 ← WHAT YOU LEARNED (written for future you)
    ├── day01-http.md
    ├── day02-net-http.md
    ├── ...
    ├── interview-bank.md  ← started on Day 0, grows every day
    ├── debugging.md       ← every real bug you caused and fixed
    └── benchmarks/        ← measured numbers only
        ├── indexes.md
        ├── cache.md
        ├── booking-concurrency.md
        └── load-test.md
```

**`notes/` vs `docs/`: the important distinction.**

| | `notes/day22-jwt.md` | `docs/authentication.md` |
|-|----------------------|--------------------------|
| Audience | You, before an interview | Another engineer joining booker |
| Content | "What does `aud` mean? JWT vs session? Why are JWTs hard to revoke?" | "Booker uses a 15-minute access token and rotating refresh tokens stored hashed in Postgres…" |
| Tone | Learning, questions, mistakes | Facts about this system |

**The whole system at a glance:**

| Artifact | Answers | Where |
|----------|---------|-------|
| Code | What did I actually implement? | `cmd/`, `internal/`, `migrations/` |
| Notes | What did I learn? | `notes/dayNN-*.md` |
| Docs | How does booker work? | `docs/*.md` |
| ADRs | Why did I choose this approach? | `docs/adr/` |
| Tests | Proof that it works | `*_test.go` |
| Benchmarks | Proof that it performs | `notes/benchmarks/` |
| Debugging log | Proof that I can find and fix real bugs | `notes/debugging.md` |
| README | The story I show recruiters | `README.md` |
| Interview bank | How I explain everything | `notes/interview-bank.md` |

---

## Rules for every day

### 1. The daily routine

| Block | Time | What you do |
|-------|------|-------------|
| 1. Learn | ~1 h | Read the topic (links in each phase). Short notes in your own words. |
| 2. Build | ~2–3 h | Do the **Build** task in booker. |
| 3. Note | ~30 min | Write `notes/dayNN-topic.md` with [Template A](#a-daily-note-template-13-pages-max). **1–3 pages maximum.** |
| 4. Explain | ~20 min | Add the day's questions to `notes/interview-bank.md` and answer them **out loud**. |
| 5. Commit | ~10 min | Commit using the [message convention](#i-commit-messages). Tick the day in the [tracker](#progress-tracker). |

**Side track every day (45–60 min): DSA in Go.** Most internship interviews
include a coding round. Do 1–2 problems a day in Go (arrays & hashmaps → two
pointers → stacks/queues → binary search → trees → BFS/DFS → heaps → simple
DP). Don't skip this; the backend skills get you through the later rounds, but
the coding round usually comes first.

### 2. Notes are revision sheets, not textbooks

A 28-page note on JWT will never be re-read before an interview. A 2-page note
with a mental model, your mistakes and a one-line summary will. Don't copy
documentation. Write what **you** understood, what **you** built, and what
**you** got wrong.

### 3. Always write the "Why?"

Never write *"Used Redis."* Write the decision ([Template B](#b-decision-template-the-why-block)):

> **Problem:** `GET /events/{id}` was hitting Postgres on every request.
> **Decision:** Redis cache-aside.
> **Why:** event details are read often and updated rarely.
> **Trade-off:** cache invalidation is now needed.
> **Failure behaviour:** if Redis is down, fall back to Postgres.
> **Alternative rejected:** in-process cache, because 3 instances would hold 3 different caches.

This is practising engineering decisions, not memorising tools. Major
project-wide choices also get a short **ADR** ([Template C](#c-adr-template)).

### 4. Ask these 10 questions before adding any technology

1. Why is this needed?
2. What problem existed without it?
3. Could PostgreSQL alone solve it?
4. Could standard Go solve it?
5. What happens if this dependency goes down?
6. How does it behave with **3 backend instances**?
7. What happens under concurrency?
8. What happens if the operation happens **twice**?
9. What happens if the request gets **cancelled**?
10. How would I monitor its failure?

> ❌ *"NATS is on the roadmap, so I added it."*
> ✅ *"The booking transaction must produce an event that another component
> processes asynchronously. Writing to Postgres and publishing to NATS
> separately creates a dual-write failure, so I'm using a transactional outbox."*

Days that add a new dependency have an **Ask first** line. Answer it in that
day's note before writing code.

### 5. Measure, never invent

Never write *"420 ms → 3 ms"* unless you measured 420 ms and 3 ms. Every number
in your README and resume must come from `notes/benchmarks/`
([Template E](#e-benchmark-template)), with the dataset, the command and the
raw output.

### 6. Log every real bug you cause

Every meaningful bug goes into `notes/debugging.md`
([Template D](#d-debugging-entry-template)): symptom, cause, wrong assumption,
fix, verification. When an interviewer says *"tell me about a difficult bug,"*
you won't have to invent one. Days that tend to produce good bugs have a
**Likely bug** hint.

### 7. Never commit secrets

Never commit: `.env`, `DATABASE_URL`, `JWT_SECRET`, OAuth client secrets, SMTP
credentials, AWS/MinIO keys, Redis passwords, private keys. Commit
`.env.example` with **empty** values instead:

```dotenv
DATABASE_URL=
REDIS_URL=
JWT_SECRET=
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
```

Add `.env` to `.gitignore` on **Day 0**, before the first secret exists. If a
secret is ever pushed, **rotate it immediately**. Deleting the commit is not
enough, because it may already have been cloned or cached.

### 8. Commit messages tell your story

Avoid `fix`, `fix2`, `final`, `final-final`, `working`, `update`. Use
`type(scope): what changed`. Someone reading your GitHub history should see
your progression. See [Template I](#i-commit-messages). Each day below
suggests a message.

### 9. The README sells the finished project

booker's `README.md` must **never** read like a diary ("Day 1 I learned
HTTP…"). That belongs in `notes/`. The README explains the finished
engineering project, with the **Interesting Engineering Problems** near the
top. You build it up gradually using [Template G](#g-booker-readme-template-interviewer-first)
and polish it on Day 50.

---

## Where to go deepest

You can't master everything in 8 weeks. Spend extra time on the 🔥🔥🔥 topics.
Shallow knowledge there is obvious in an interview.

| Priority | Topic | Target depth | Days |
|----------|-------|--------------|------|
| 🔥🔥🔥 | HTTP | very deep | 1–5 |
| 🔥🔥🔥 | SQL / PostgreSQL | very deep | 8–15 |
| 🔥🔥🔥 | Transactions | very deep | 12–13 |
| 🔥🔥🔥 | Authentication | very deep | 20–24, 26–27 |
| 🔥🔥🔥 | Authorization | very deep | 25 |
| 🔥🔥🔥 | Go concurrency | very deep | 2, 13, 40, 41 |
| 🔥🔥🔥 | Error handling | deep | 18 |
| 🔥🔥🔥 | Context | deep | 5 |
| 🔥🔥 | Indexing | deep | 14 |
| 🔥🔥 | API design | deep | 3, 15 |
| 🔥🔥 | Redis | solid | 31–32 |
| 🔥🔥 | Testing | solid | 29–30 |
| 🔥🔥 | Docker | solid | 46 |
| 🔥 | Kafka / NATS | understand | 42 |
| 🔥 | gRPC | understand | 43 |
| 🔥 | Kubernetes | conceptual for now | 5, 36, 46–48 (probes, shutdown, containers) |

---

## Phase overview

| Phase | Days | Theme |
|-------|------|-------|
| 0 | 0 | Setup |
| 1 | 1–7 | HTTP & API foundations |
| 2 | 8–16 | Databases & data modeling |
| 3 | 17–19 | Validation, errors & logging |
| 4 | 20–28 | **Authentication & authorization (deep dive)** |
| 5 | 29–30 | Testing |
| 6 | 31–39 | Production essentials (cache, rate limit, jobs, files, observability, security) |
| 7 | 40–45 | Advanced Go backend (concurrency patterns, realtime, events, gRPC, performance) |
| 8 | 46–50 | Ship it (Docker, CI/CD, deploy, system design) |
| 9 | 51–56 | Interview preparation |

Each day has the same parts:
- **Learn**: the concepts to understand deeply
- **Build**: what to add to booker today
- **Production view**: how this is layered in a real production system
- **Interview questions**: what you should be able to answer (they go into `notes/interview-bank.md`)
- **Produce**: the note, doc, ADR, diagram, benchmark or debugging entry for the day, plus a commit message
- **Done when**: your checkpoint

---

## Phase 0: Setup

### Day 0: Tools, project skeleton and the documentation system
- **Learn:** Go modules (`go mod init`, `go get`, `go mod tidy`), Docker basics
  (image, container, volume, port mapping), Docker Compose, `.gitignore`.
- **Build:**
  - Install: Go, Docker Desktop, VS Code + Go extension (gopls), `golangci-lint`,
    an API client (Bruno, Postman or `curl`/`httpie`).
  - Create the `booker` repo: `go mod init github.com/<you>/booker`.
  - `docker-compose.yml` with **Postgres** and **Redis**. Run `docker compose up -d`.
  - Create the [layout](#repository-layout-what-goes-where): `docs/`,
    `docs/adr/`, `docs/diagrams/`, `notes/`, `notes/benchmarks/`.
  - `.gitignore` containing `.env` **before anything else**; `.env.example` with empty values.
  - Empty `notes/interview-bank.md` ([Template F](#f-interview-bank-format)) and
    `notes/debugging.md`.
  - `README.md` with only the headings of [Template G](#g-booker-readme-template-interviewer-first).
- **Produce:** commit `chore: initialize project structure and docs layout`.
- **Done when:** `docker compose ps` shows Postgres and Redis running,
  `git check-ignore .env` prints `.env`, and the repo is pushed.

---

## Phase 1: HTTP & API foundations

**Resources:** [pkg.go.dev/net/http](https://pkg.go.dev/net/http) ·
[Routing enhancements in Go 1.22](https://go.dev/blog/routing-enhancements) ·
[MDN: HTTP overview](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview) ·
Book: *Let's Go* and *Let's Go Further* by Alex Edwards (the best paid resources
for exactly this roadmap).

### Day 1: How the web works, from the bytes up
- **Learn:** what happens when you open a URL (DNS → TCP → TLS → HTTP).
  Request anatomy: method, path, headers, body. Response: status, headers,
  body. Methods and their meaning: `GET`, `POST`, `PUT`, `PATCH`, `DELETE`.
  **Safe** vs **idempotent** methods. Status code families (2xx, 3xx, 4xx, 5xx).
  Keep-alive, HTTP/1.1 vs HTTP/2.
- **Build:**
  1. `experiments/rawtcp/main.go`: a raw TCP server with
     `net.Listen("tcp", ":8080")` that reads the request bytes and writes back
     `HTTP/1.1 200 OK\r\n...` **by hand**. Open it in a browser. Now you've seen
     what `net/http` hides.
  2. The same thing with `net/http` in 10 lines.
- **Production view:** in production a request usually passes through a CDN →
  load balancer (TLS ends here) → your Go server. Your server often speaks plain
  HTTP behind the load balancer.
- **Interview questions:**
  1. What happens when you type a URL in the browser and press Enter? *(prepare all 3 levels: 15 s / 60 s / 5 min)*
  2. `PUT` vs `PATCH`? Which methods are idempotent, and why does it matter?
  3. `401` vs `403`? `400` vs `422`? When do you return `409`?
- **Produce:** `notes/day01-http.md`; first entries in the interview bank's
  `# HTTP` section; commit `feat(experiments): add raw TCP HTTP server`.
- **Done when:** you can draw the full journey of a request on paper.

### Day 2: HTTP server and CRUD APIs (GET, POST, PUT, PATCH, DELETE)
- **Learn:** the `http.Handler` interface, `http.HandlerFunc`, `ServeMux` with
  Go 1.22 patterns, path values, query params, reading JSON safely, writing
  JSON with the right `Content-Type` and status code.
  ```go
  mux := http.NewServeMux()
  mux.HandleFunc("GET /events", h.list)
  mux.HandleFunc("GET /events/{id}", h.get)      // id := r.PathValue("id")
  mux.HandleFunc("POST /events", h.create)
  mux.HandleFunc("PATCH /events/{id}", h.update)
  mux.HandleFunc("DELETE /events/{id}", h.delete)
  ```
- **Build:** full CRUD for `events`, stored **in memory** in a
  `map[string]Event` protected by a `sync.RWMutex` (your concurrency knowledge
  in real use). Helpers: `writeJSON(w, status, v)` and `readJSON(w, r, &dst)`
  that uses `http.MaxBytesReader` (limit body size) and
  `decoder.DisallowUnknownFields()`.
- **Production view:** handlers stay thin: decode → call logic → encode.
  JSON helpers live in one place so every endpoint behaves the same.
- **Interview questions:**
  1. What is the `http.Handler` interface? How does `ServeMux` choose a handler?
  2. Why do you need a mutex around the map? What happens without it?
  3. Why limit the request body size?
- **Likely bug:** remove the mutex, hit the API concurrently, and watch for
  `fatal error: concurrent map writes`. Log it in `notes/debugging.md`.
- **Produce:** `notes/day02-net-http.md`; **ADR-001: Use `net/http` instead of a
  web framework**; commit `feat(events): add in-memory CRUD endpoints`.
- **Done when:** all 5 endpoints work from your API client with correct status
  codes (`201` for create, `204` for delete, `404` for missing id).

### Day 3: REST API design
- **Learn:** resources as plural nouns (`/events`, `/events/{id}/bookings`),
  status codes per operation, **one consistent error format**, pagination,
  filtering and sorting conventions (`?page=&limit=&sort=-starts_at`),
  versioning (`/v1`), when **not** to use REST. OpenAPI basics.
- **Build:** write `openapi.yaml` for booker's **whole planned API** (events,
  bookings, auth, users) **before** writing more code. Define your error format:
  ```json
  { "error": { "code": "EVENT_NOT_FOUND", "message": "Event not found", "fields": [] } }
  ```
- **Production view:** the API contract is shared by backend, frontend and
  mobile teams. Breaking it breaks clients, so APIs are versioned and changed
  carefully. Read: [`apps/backend/static/README.md`](apps/backend/static/README.md)
  and [`apps/backend/docs/24-monorepo.md`](apps/backend/docs/24-monorepo.md).
- **Interview questions:**
  1. Design the REST endpoints for a library system (books, members, loans).
  2. How do you version an API? What is a breaking change?
  3. Why should error responses have a stable machine-readable `code`?
- **Produce:** `notes/day03-rest.md`; commit `docs(api): add OpenAPI spec for planned API`.
- **Done when:** `openapi.yaml` opens without errors in [editor.swagger.io](https://editor.swagger.io).

### Day 4: Middleware
- **Learn:** the pattern `func(next http.Handler) http.Handler`; chaining; the
  "onion" order; capturing the response status with a `responseWriter` wrapper.
- **Build:** middleware for **request ID** (`X-Request-ID`), **logging** (method,
  path, status, duration), **panic recovery** (→ 500), and **CORS**. Write a
  small `chain(h, m1, m2, m3)` helper.
- **Production view:** cross-cutting concerns (logging, auth, tracing, rate
  limits) live in middleware so no handler re-implements them. Order matters.
  Read: [`apps/backend/docs/05-middleware-order.md`](apps/backend/docs/05-middleware-order.md).
- **Interview questions:**
  1. What is middleware? Give 4 examples from production.
  2. Why must recovery be close to the handler, and request ID run early?
  3. How do you get the status code inside a logging middleware?
- **Likely bug:** a CORS error in the browser that `curl` doesn't show (pre-flight `OPTIONS`).
- **Produce:** `notes/day04-middleware.md`; commit
  `feat(http): add request ID, logging, recovery and CORS middleware`.
- **Done when:** every request logs one line with request ID, status and duration.

### Day 5: Context, timeouts and graceful shutdown
- **Learn:** `context.Context`: cancellation, deadlines, request-scoped values
  (and why to use values sparingly). Server timeouts (`ReadTimeout`,
  `WriteTimeout`, `IdleTimeout`, `ReadHeaderTimeout`). Client timeouts.
  Signals (`SIGINT`, `SIGTERM`) and `server.Shutdown(ctx)`.
- **Build:** configure `http.Server` with timeouts; graceful shutdown on
  SIGINT **and** SIGTERM; a test endpoint `GET /slow` that respects
  `r.Context().Done()` and stops when the client disconnects.
- **Production view:** every deploy stops old instances. Without graceful
  shutdown, users get errors on every deploy. Read:
  [`apps/backend/docs/19-graceful-shutdown.md`](apps/backend/docs/19-graceful-shutdown.md).
- **Interview questions:**
  1. What is `context.Context` for? Why is it the first parameter? *(3 levels)*
  2. What happens to in-flight requests when a Kubernetes pod is stopped?
  3. Why does Go's default `http.Client` with no timeout cause outages?
- **Likely bug:** context cancellation not propagated, so work continues after
  the client has gone.
- **Produce:** `notes/day05-context.md`; commit `feat(server): add timeouts and graceful shutdown`.
- **Done when:** Ctrl+C during a `/slow` request lets it finish, then exits cleanly.

### Day 6: Project structure, layers, dependency injection and config
- **Learn:** `cmd/` + `internal/` layout; **handler → service → repository**
  layers; constructor-based dependency injection; "accept interfaces, return
  structs"; config from environment variables, validated at startup.
- **Build:** refactor booker into
  ```
  cmd/api/main.go
  internal/config  internal/http (handlers, middleware, router)
  internal/event   (service.go, repository.go, model.go)
  ```
  Load config from env (`PORT`, `DATABASE_URL`, …), **fail fast** if a value is
  missing, and keep `.env.example` in sync. Behaviour should be identical to
  before; only the structure changes.
- **Production view:** layers let you test business logic without HTTP, and
  swap storage without touching handlers. Read:
  [`apps/backend/docs/01-mental-model.md`](apps/backend/docs/01-mental-model.md),
  [`06-dependency-injection.md`](apps/backend/docs/06-dependency-injection.md),
  [`07-configuration.md`](apps/backend/docs/07-configuration.md).
- **Interview questions:**
  1. Explain your project's layers and what each one is **not** allowed to do.
  2. What is dependency injection? How do you do it in Go without a framework?
  3. Why config from env vars (12-factor)? How do you handle secrets?
- **Produce:** `notes/day06-layers.md`; first version of `docs/architecture.md`;
  **diagram: request lifecycle** (`docs/diagrams/`); commit
  `refactor: split into handler, service and repository layers`.
- **Done when:** `main.go` is under ~80 lines and only wires things together.

### Day 7: Review
- Re-answer every interview question from Days 1–6 **without notes**. Write
  the 15 s / 60 s / 5 min versions for *HTTP* and *context*.
- README: fill **Running Locally** and a first **Architecture** sketch. No
  diary entries.
- Redraw the request-lifecycle diagram from memory and compare.
- **Done when:** someone else could run booker from your README in 5 minutes.

---

## Phase 2: Databases & data modeling

**Resources:** [PostgreSQL docs: Tutorial + Concurrency Control chapters](https://www.postgresql.org/docs/current/) ·
[Use The Index, Luke](https://use-the-index-luke.com) · [pgx](https://github.com/jackc/pgx) ·
[sqlc](https://sqlc.dev) · [goose](https://github.com/pressly/goose) ·
Book: *Designing Data-Intensive Applications* (Kleppmann), chapters 2, 3, 7.

### Day 8: Data modeling and SQL for backend engineers
- **Learn:** tables, primary keys (UUID vs bigint), foreign keys, `NOT NULL`,
  `UNIQUE`, `CHECK`, one-to-many and many-to-many, normalization (up to 3NF) and
  when to denormalize, `JOIN`s, aggregates, `timestamptz`.
- **Build:** design booker's schema on paper first, then as SQL: `users`,
  `events` (organizer_id, title, city, starts_at, capacity, seats_left),
  `bookings` (user_id, event_id, quantity, status). Draw an ER diagram (e.g.
  dbdiagram.io).
- **Production view:** constraints in the database are your **last line of
  defence**. Application checks can have bugs; constraints can't be skipped.
- **Interview questions:**
  1. Design tables for Instagram posts, likes and followers.
  2. UUID vs auto-increment IDs: trade-offs?
  3. What is normalization, and when would you denormalize?
- **Produce:** `notes/day08-data-modeling.md`; `docs/database.md` with the ER
  diagram; **ADR-002: Use PostgreSQL**; commit `feat(db): add initial schema`.
- **Done when:** the schema runs in `psql` and the diagram is committed.

### Day 9: Go ↔ Postgres with pgx
- **Learn:** `database/sql` vs `pgx`; **connection pools** (`pgxpool`): why
  they exist, max connections, idle connections; passing `ctx` to every query;
  scanning rows; `NULL` handling; why string-building SQL causes SQL injection.
- **Build:** replace the in-memory map with a Postgres repository using
  `pgxpool`. Keep the service and handlers unchanged (proof your layers work!).
- **Production view:** the pool is created once at startup and shared.
  Postgres has a connection limit, so pool size × number of app instances must
  fit under it. Read: [`apps/backend/docs/12-database-pooling.md`](apps/backend/docs/12-database-pooling.md).
- **Interview questions:**
  1. What is a connection pool? What happens when it is exhausted?
  2. How does a parameterised query prevent SQL injection?
  3. Why pass `context.Context` into database calls?
- **Likely bug:** pool exhaustion. Set `MaxConns=2`, fire 50 concurrent requests
  at an endpoint that forgets to close `rows`, and watch requests hang.
- **Produce:** `notes/day09-pgx.md`; commit `feat(events): store events in PostgreSQL via pgx`.
- **Done when:** events survive a server restart.

### Day 10: Migrations and seed data
- **Learn:** why schema changes must be versioned code; up/down migrations;
  never editing an applied migration; **expand → migrate → contract** for
  zero-downtime changes.
- **Build:** move your schema into `goose` (or `tern`) migrations. Add a
  `Makefile` or `Taskfile` with `migrate-up`, `migrate-down`, `seed`. Write a
  seed script that inserts realistic data.
- **Production view:** migrations run in CI/CD or at startup, before new code
  serves traffic. Read: [`apps/backend/docs/13-migrations-workflow.md`](apps/backend/docs/13-migrations-workflow.md).
- **Interview questions:**
  1. How would you rename a column with zero downtime?
  2. What goes wrong if two app instances run migrations at the same time?
- **Produce:** `notes/day10-migrations.md`; commit `feat(db): add goose migrations and seed script`.
- **Done when:** `migrate-down` then `migrate-up` rebuilds the DB cleanly.

### Day 11: sqlc vs ORM vs raw SQL
- **Learn:** raw SQL (control, verbose), ORMs like GORM (fast to start, hidden
  queries, N+1 risk), **sqlc** (you write SQL, it generates type-safe Go).
- **Build:** move the events repository to `sqlc`. Compare the code size and
  type safety with Day 9.
- **Production view:** many Go teams prefer sqlc or raw SQL because queries are
  visible, reviewable and tunable.
- **Interview questions:**
  1. ORM vs raw SQL: what would you choose for a new service, and why?
  2. What is the N+1 query problem? How do you detect and fix it?
- **Produce:** `notes/day11-sqlc.md`; **ADR-003: Use pgx + sqlc instead of GORM**
  (this is the example in [Template C](#c-adr-template)); commit
  `refactor(events): generate queries with sqlc`.
- **Done when:** the repository uses only sqlc-generated functions.

### Day 12: Transactions and isolation levels
- **Learn:** ACID. Isolation levels in Postgres: **Read Committed** (default),
  **Repeatable Read** (snapshot), **Serializable** (may fail with `40001`, so
  you must retry). Anomalies: dirty read, non-repeatable read, phantom read,
  **lost update**. Using `pgx.BeginFunc` or `tx.Commit`/`tx.Rollback`.
- **Build:** `POST /events/{id}/bookings` that, **in one transaction**, inserts
  a booking and decreases `seats_left`. Pass the transaction into repository
  methods (a small `DBTX` interface that both pool and tx satisfy).
- **Production view:** the **service** decides where a transaction starts and
  ends (it knows the use case); repositories just run queries inside it.
- **Interview questions:**
  1. Explain ACID with a bank-transfer example. *(3 levels)*
  2. What anomalies does each isolation level allow?
  3. Where should transaction boundaries live in a layered app?
- **Likely bug:** a repository call that uses the pool instead of the `tx`, so
  it isn't rolled back.
- **Produce:** `notes/day12-transactions.md`; **diagram: booking transaction**;
  commit `feat(booking): add transactional seat reservation`.
- **Done when:** if inserting the booking fails, `seats_left` is **not** changed.

### Day 13: Concurrency in the database: no double booking ⭐ (story #1)
- **Learn:** race conditions across **multiple app instances** (a Go mutex
  can't help when you run 3 servers). Solutions:
  1. **Atomic conditional update:**
     ```sql
     UPDATE events SET seats_left = seats_left - $2
     WHERE id = $1 AND seats_left >= $2
     RETURNING seats_left;   -- 0 rows → sold out → 409
     ```
  2. **Pessimistic locking:** `SELECT ... FOR UPDATE`.
  3. **Optimistic locking:** a `version` column and `WHERE version = $n`.
  4. Unique constraints, e.g. one booking per user per event.
- **Build:**
  1. Write a test that starts **200 goroutines** booking an event with **10 seats**.
  2. Commit the **naive** version (read → check → write) and watch it **oversell**.
     Record exactly how many bookings succeeded.
  3. Fix it with the atomic update. Optionally also try `FOR UPDATE` and
     compare.
- **Production view:** correctness under concurrency belongs to the
  **database**, not to in-process locks.
- **Interview questions:**
  1. How do you prevent overselling the last ticket when 1,000 users click at once?
  2. Optimistic vs pessimistic locking: when to use which?
  3. Why doesn't `sync.Mutex` solve this in production?
- **Produce:**
  - `notes/debugging.md` → entry "Ticket overselling" (this is the example in [Template D](#d-debugging-entry-template))
  - `notes/benchmarks/booking-concurrency.md` → attempts, successes, oversold count, before/after
  - `docs/concurrency.md` → how booker prevents overselling today
  - **ADR-004: Prevent overselling with an atomic conditional update**
  - README → **Interesting Engineering Problems #1**
  - commits `test(booking): reproduce concurrent overselling` then
    `fix(booking): prevent overselling with atomic update`
- **Done when:** your test passes 20 times in a row with `-race`, and you can
  tell the story in 60 seconds.

### Day 14: Indexes, EXPLAIN and query performance
- **Learn:** B-tree indexes, composite index column order, covering indexes,
  partial indexes, the cost of indexes on writes, `EXPLAIN ANALYZE` (seq scan vs
  index scan), slow-query logging.
- **Build:** seed **1 million** events. Measure `GET /events?city=X` before and
  after adding the right index.
- **Production view:** most "the API is slow" problems are a missing index or
  an N+1 query, not Go code.
- **Interview questions:**
  1. How does a B-tree index speed up a query? Why not index every column? *(3 levels)*
  2. Index on `(city, starts_at)`: does it help `WHERE starts_at > now()` alone?
  3. How do you find which query is slow in production?
- **Produce:** `notes/benchmarks/indexes.md` with dataset, query, both
  `EXPLAIN ANALYZE` outputs and timings ([Template E](#e-benchmark-template));
  README → **Interesting Engineering Problems #3 (draft)**; commit
  `perf(events): add composite city/start-time index`.
- **Done when:** you have a **measured** before/after number. Never use an example number.

### Day 15: Pagination, filtering, sorting and search
- **Learn:** offset pagination (simple, slow on deep pages, unstable with
  inserts) vs **cursor / keyset pagination**:
  ```sql
  WHERE (starts_at, id) > ($1, $2) ORDER BY starts_at, id LIMIT 20
  ```
  Safe dynamic filters and sorting (whitelist sort fields!). Postgres full-text
  search (`tsvector` + GIN index) or `pg_trgm` for fuzzy `ILIKE`.
- **Build:** `GET /events?city=&from=&to=&q=&sort=&cursor=&limit=` with a
  response that includes `next_cursor`.
- **Production view:** never let clients request unlimited rows. Cap `limit`.
- **Interview questions:**
  1. Offset vs cursor pagination: trade-offs?
  2. How do you let users sort by any column without SQL injection?
- **Produce:** `notes/day15-pagination.md`; **ADR-005: Use cursor pagination for
  event listing**; commit `feat(events): add cursor pagination, filters and search`.
- **Done when:** paging through all 1M events never returns a duplicate or skips one.

### Day 16: Review
- Re-answer Days 8–15 out loud. Write 3-level explanations for *index* and
  *transaction*.
- README: polish **Interesting Engineering Problems #1** (overselling) with
  numbers from `notes/benchmarks/booking-concurrency.md`.
- **Done when:** you can explain your booking transaction line by line and
  redraw the booking-transaction diagram from memory.

---

## Phase 3: Validation, errors & logging

### Day 17: Validation (and how it differs from verification)
- **Learn:**
  - **Validation** = *is the input well-formed?* (required, length, format,
    ranges, enums, cross-field rules like `ends_at > starts_at`).
  - **Verification** = *is it true?* (does this email belong to this person?
    Is this OTP correct?). That is covered on **Day 24**.
  - Normalization before validation (trim spaces, lowercase emails).
  - Validate at the edge (handler) for shape and in the service for business rules.
  - `go-playground/validator`, custom validators, returning **per-field errors**.
- **Build:** request DTOs with `validate` tags and a `Validate()` method;
  return `422`/`400` with `fields: [{field, message}]`.
- **Production view:** never trust the client, even your own frontend.
  Read: [`apps/backend/internal/validation/README.md`](apps/backend/internal/validation/README.md).
- **Interview questions:**
  1. Validation vs verification? Give two examples of each.
  2. Where should validation happen in a layered system?
- **Produce:** `notes/day17-validation.md`; commit
  `feat(validation): return field-level validation errors`.
- **Done when:** sending garbage to every endpoint returns a helpful field-level error, never a 500.

### Day 18: Error handling architecture
- **Learn:** errors are values; wrapping with `%w`; `errors.Is` / `errors.As`;
  sentinel errors (`ErrNotFound`) vs typed errors; **domain errors** in the
  service, mapped to HTTP status **once** at the edge; never leaking SQL or
  stack traces to clients; mapping Postgres error codes (unique violation
  `23505` → `409`).
- **Build:** an `apperr` package and a single `writeError(w, r, err)` that
  maps domain errors → status + code, logs unexpected ones with the request ID,
  and returns a generic 500 message for unknown errors.
- **Production view:** one central place decides how errors look. Read:
  [`apps/backend/docs/09-error-handling.md`](apps/backend/docs/09-error-handling.md)
  and [`apps/backend/internal/sqlerr/README.md`](apps/backend/internal/sqlerr/README.md).
- **Interview questions:**
  1. `errors.Is` vs `errors.As`? Why wrap with `%w`?
  2. Why not return `err.Error()` to the client?
  3. "Handle an error once": what does that mean?
- **Produce:** `notes/day18-errors.md`; commit
  `feat(errors): centralize domain error to HTTP mapping`.
- **Done when:** a duplicate booking returns `409 {"code":"ALREADY_BOOKED"}` and the log has the real cause.

### Day 19: Structured logging with slog
- **Learn:** structured vs text logs; `log/slog` (standard library);
  levels; JSON handler in production, text handler locally; adding
  `request_id` and `user_id` to every log line via context; what **never**
  to log (passwords, tokens, personal data).
- **Build:** replace all `fmt.Println`/`log.Printf` with `slog`; a
  request-scoped logger stored in context by middleware.
- **Production view:** logs are searched by fields (`request_id=...`) in tools
  like Grafana Loki, Datadog or New Relic. Read:
  [`apps/backend/docs/10-logging.md`](apps/backend/docs/10-logging.md).
- **Interview questions:**
  1. Why structured logs? How would you debug one failed request among millions?
  2. What should you never log?
- **Produce:** `notes/day19-logging.md`; commit
  `feat(logging): switch to slog with request-scoped logger`.
- **Done when:** you can find every log line of one request by its ID.

---

## Phase 4: Authentication & authorization (deep dive)

**Resources:** [OWASP Cheat Sheets](https://cheatsheetseries.owasp.org/)
(Authentication, Password Storage, Session Management, JSON Web Token (the
concepts apply to every language), Forgot Password) ·
[PortSwigger Web Security Academy: Authentication, OAuth, JWT labs](https://portswigger.net/web-security) ·
[oauth.com (OAuth 2.0 Simplified)](https://www.oauth.com) · [jwt.io introduction](https://jwt.io/introduction).

> This phase gets 9 days on purpose. Auth is the area where shallow knowledge
> is most obvious in an interview.

**The big picture you are building this phase:**

```
            ┌────────────── AUTHENTICATION (who are you?) ───────────────┐
 register → hash password → store user → send verification email
 login    → check password → issue access token (short) + refresh token (long, stored hashed)
 request  → middleware verifies access token → puts user_id + role in context
 refresh  → rotate refresh token → new access token
 logout   → revoke refresh token
            └─────────────────────────────────────────────────────────────┘
            ┌────────────── AUTHORIZATION (what can you do?) ─────────────┐
 middleware: is the user logged in? does the role allow this route?
 service:    does this user OWN this resource? (business rule)
 SQL:        WHERE id = $1 AND organizer_id = $2  (defence in depth)
            └─────────────────────────────────────────────────────────────┘
```

**Secrets from now on:** `JWT_SECRET`, OAuth client secrets and SMTP
credentials go **only** into `.env` (empty keys in `.env.example`). Run
`git status` before every commit this phase.

### Day 20: Auth fundamentals and password storage
- **Learn:** authentication vs authorization; hashing vs encryption; why
  **bcrypt / argon2id** (slow, salted) and never SHA-256 or MD5 for passwords;
  salt vs pepper; bcrypt's 72-byte limit; constant-time comparison
  (`crypto/subtle`); **user enumeration** ("invalid email or password", the
  same response time for both cases).
- **Build:** `users` table (email `UNIQUE`, `password_hash`, `role`,
  `email_verified_at`); `POST /auth/register` and `POST /auth/login` using
  `golang.org/x/crypto/bcrypt` (or `argon2`).
- **Production view:** the auth module is its own package (`internal/auth`)
  with its own service and repository. Other modules only see "current user".
- **Interview questions:**
  1. How do you store passwords? Why is a fast hash bad here?
  2. What is a salt? What attack does it stop?
  3. Why should "wrong email" and "wrong password" give the same message?
- **Produce:** `notes/day20-passwords.md`; start `docs/authentication.md`;
  commit `feat(auth): add password-based registration and login`.
- **Done when:** passwords in the DB look like `$2a$...` and login works.

### Day 21: Sessions and cookies
- **Learn:** stateful sessions: random session ID → stored server-side
  (Postgres/Redis) → sent in a cookie. Cookie flags: `HttpOnly`, `Secure`,
  `SameSite=Lax/Strict`, `Path`, `Max-Age`. **CSRF** and how SameSite + CSRF
  tokens stop it. Session expiry and rotation after login (session fixation).
- **Build:** session-based login as an alternative mode: `sessions` table,
  `crypto/rand` IDs, `RequireSession` middleware, `POST /auth/logout` deletes
  the session.
- **Production view:** sessions are easy to revoke (delete the row) but need a
  shared store across instances. That's why Redis is common here.
- **Interview questions:**
  1. Explain how cookie-based sessions work end to end.
  2. What is CSRF? How do `SameSite` cookies help?
  3. What does `HttpOnly` protect against?
- **Produce:** `notes/day21-sessions.md`; commit
  `feat(auth): add cookie sessions with CSRF protection`.
- **Done when:** logout really logs you out (old cookie gets `401`).

### Day 22: JWT deep dive
- **Learn:** JWT structure (header.payload.signature, base64url, **not
  encrypted**); claims: `sub`, `exp`, `iat`, `iss`, `aud`; **HS256** (shared
  secret) vs **RS256/EdDSA** (private key signs, public key verifies; good for
  many services); attacks: `alg: none`, algorithm confusion, missing `exp`
  check; why JWTs are hard to revoke.
- **Build:** issue a **15-minute access token** on login with
  `github.com/golang-jwt/jwt/v5`. `RequireAuth` middleware parses it with
  `jwt.WithValidMethods(...)`, checks `exp`/`iss`/`aud`, and puts
  `user_id` + `role` in context.
- **Production view:** the API gateway or each service verifies tokens
  locally (no DB call per request). That is JWT's main advantage.
- **Interview questions:**
  1. Session vs JWT: trade-offs? When would you choose each? *(3 levels)*
  2. Is a JWT encrypted? What must never go inside it?
  3. How do you revoke a JWT before it expires?
- **Likely bug:** trusting claims without validating `iss`/`aud` or the
  algorithm.
- **Produce:** `notes/day22-jwt.md`. This is the worked example in
  [Template A](#a-daily-note-template-13-pages-max). Commit
  `feat(auth): issue and verify JWT access tokens`.
- **Done when:** a token with a changed payload or an expired `exp` is rejected.

### Day 23: Refresh tokens, rotation and logout
- **Learn:** short access token + long refresh token; **refresh token
  rotation** (each use returns a new one; the old one is invalid); **reuse
  detection** (an old token used again → probably stolen → revoke the whole
  family); store refresh tokens **hashed** in the DB; where to keep tokens in
  the browser (httpOnly cookie vs memory vs localStorage, and the XSS trade-off).
- **Build:** `refresh_tokens` table (hash, user_id, family_id, expires_at,
  revoked_at); `POST /auth/refresh`, `POST /auth/logout`,
  `POST /auth/logout-all`.
- **Production view:** this is how "log out of all devices" works in real apps.
- **Interview questions:**
  1. Why have two tokens instead of one long-lived token?
  2. Explain refresh token rotation and reuse detection.
  3. Where should a web app store tokens? Why?
- **Produce:** `notes/day23-refresh-tokens.md`; **ADR-006: JWT access tokens +
  rotating refresh tokens** (and why not sessions only); **diagram:
  authentication flow**; commit `feat(auth): rotate refresh tokens with reuse detection`.
- **Done when:** re-using an old refresh token revokes all sessions of that user.

### Day 24: Verification flows: email verification, password reset, OTP
- **Learn:** secure random tokens (`crypto/rand`, never `math/rand`); store
  only a **hash** of the token; expiry (e.g. 30 min); **one-time use**;
  don't reveal whether an email exists ("If the account exists, we sent an
  email"); invalidate sessions after a password reset; 6-digit OTP codes with
  attempt limits.
- **Build:** `POST /auth/verify-email/request`, `GET /auth/verify-email?token=`,
  `POST /auth/password/forgot`, `POST /auth/password/reset`. Send emails to
  **Mailpit** (a local email catcher in Docker Compose). Block booking until
  the email is verified.
- **Production view:** emails are sent by a background job (Day 33), not
  inside the request.
- **Interview questions:**
  1. Design a secure "forgot password" flow.
  2. Why store a hash of the reset token instead of the token?
  3. How do you stop someone brute-forcing a 6-digit OTP?
- **Produce:** `notes/day24-verification.md`; commit
  `feat(auth): add email verification and password reset`.
- **Done when:** a reset link works once, then fails; expired links fail.

### Day 25: Authorization: RBAC and ownership
- **Learn:** **RBAC** (roles → permissions), **ownership / resource-based**
  checks, ABAC in one sentence; where each check lives (role → middleware,
  ownership → service + SQL); return `404` instead of `403` to hide resources
  that exist; the principle of least privilege.
- **Build:** roles `attendee`, `organizer`, `admin`. Only organizers create
  events; organizers edit/delete **only their own** events; admins can do
  everything; attendees see only **their own** bookings.
  `RequireRole("organizer")` middleware + ownership checks in the service.
- **Production view:** the most common real-world security bug is **broken
  object-level authorization (BOLA)**: `GET /bookings/123` returns someone
  else's booking. Test for it.
- **Interview questions:**
  1. Authentication vs authorization, with examples from your project. *(3 levels)*
  2. Where do you check "is this user the owner?" Why not only in middleware?
  3. What is BOLA / IDOR?
- **Produce:** `notes/day25-authorization.md`; commits
  `feat(authz): add RBAC and ownership checks` and
  `test(authz): verify users cannot access others' bookings`.
- **Done when:** a test proves user A cannot read, edit or delete user B's data.

### Day 26: OAuth 2.0 and OpenID Connect ("Login with Google")
- **Learn:** OAuth 2.0 roles (resource owner, client, authorization server,
  resource server); **authorization code flow + PKCE**; the `state` parameter
  (CSRF); OAuth = *authorization*, **OpenID Connect** = *authentication* on
  top (ID token); access token vs ID token; when to use a hosted provider
  (Auth0, Clerk, Cognito). Read:
  [`apps/backend/docs/16-authentication-clerk.md`](apps/backend/docs/16-authentication-clerk.md).
- **Build:** "Login with Google" using `golang.org/x/oauth2` (with PKCE) and
  `github.com/coreos/go-oidc/v3` to verify the ID token. Link the Google
  account to an existing user by verified email. `GOOGLE_CLIENT_SECRET` lives
  only in `.env`.
- **Production view:** many companies outsource login to a provider and only
  verify tokens in the backend, exactly like the PGG boilerplate does with Clerk.
- **Interview questions:**
  1. Walk through the authorization code flow step by step.
  2. What is PKCE and what attack does it stop?
  3. OAuth vs OpenID Connect?
- **Produce:** `notes/day26-oauth-oidc.md`; commit
  `feat(auth): add Google login with OIDC and PKCE`.
- **Done when:** you can log in with Google and get booker's own tokens back.

### Day 27: Auth hardening: rate limits, lockout, MFA, API keys
- **Learn:** brute-force and credential-stuffing defence (rate limit per IP
  **and** per account, progressive delays); MFA with **TOTP** (authenticator
  apps); API keys for machine clients (show once, store hashed, use a prefix
  like `bk_live_` so they can be identified); audit logs.
- **Build:** login rate limit; optional TOTP 2FA with `github.com/pquerna/otp`;
  an `api_keys` table and `X-API-Key` auth for a partner endpoint
  `GET /partner/events`; an `audit_log` table for logins, password changes and
  role changes.
- **Interview questions:**
  1. How do you protect a login endpoint from brute force?
  2. How should API keys be generated and stored?
- **Produce:** `notes/day27-auth-hardening.md`; commit
  `feat(auth): rate limit login and add API keys`.
- **Done when:** the 6th wrong password in a minute gets `429`.

### Day 28: Review: the full auth architecture
- Finish `docs/authentication.md` (how booker's auth works, with the auth-flow diagram).
- README → **Interesting Engineering Problems #2: Authentication Architecture**
  (access tokens → refresh rotation → RBAC → ownership).
- 3-level explanations for *JWT* and *RBAC* in the interview bank.
- Practise out loud: *"Explain authentication and authorization in your
  project, from login to an authorized request."* Under 3 minutes.
- **Done when:** you can whiteboard login → token → middleware → ownership
  check without notes.

---

## Phase 5: Testing

**Resources:** [Learn Go with Tests](https://quii.gitbook.io/learn-go-with-tests) ·
[testcontainers-go](https://golang.testcontainers.org) ·
Read: [`apps/backend/docs/20-testing-strategy.md`](apps/backend/docs/20-testing-strategy.md).

### Day 29: Unit tests and HTTP handler tests
- **Learn:** table-driven tests; subtests (`t.Run`); `testify`'s `require` vs
  `assert`; testing handlers with `httptest.NewRecorder` +
  `httptest.NewRequest`; fakes via small interfaces; what **not** to mock.
- **Build:** unit tests for validation, error mapping, token creation/parsing,
  and the booking service (with a fake repository).
- **Interview questions:**
  1. Unit vs integration vs end-to-end tests? What's the testing pyramid?
  2. How do you test a handler without starting a server?
- **Produce:** `notes/day29-unit-tests.md`; commit `test: add unit and handler tests`.
- **Done when:** `go test ./...` passes and covers every auth edge case.

### Day 30: Integration tests with real Postgres and the race detector
- **Learn:** Testcontainers (a real Postgres per test run); running
  migrations in tests; isolating tests (transactions or truncation); `-race`;
  `-cover`; `testing.Short()` for slow tests.
- **Build:** integration tests for repositories and the **full booking flow**,
  including the Day 13 concurrency test, against a real container.
- **Interview questions:**
  1. Why test against a real database instead of mocks?
  2. What does `go test -race` detect?
- **Produce:** `notes/day30-integration-tests.md`; README → **Testing** section;
  commit `test: add Testcontainers integration tests`.
- **Done when:** `go test -race ./...` passes with Docker running.

---

## Phase 6: Production essentials

### Day 31: Caching with Redis
- **Ask first:** Is Postgres actually the bottleneck (measure!)? Could an index
  fix it instead? What happens with 3 instances? What if Redis is down?
- **Learn:** cache-aside pattern; TTLs; **invalidation** (the hard part);
  cache stampede and how to stop it (`golang.org/x/sync/singleflight`, jitter);
  what to cache and what not to (never cache per-user private data under a
  shared key).
- **Build:** cache `GET /events/{id}` and popular listings in Redis
  (`github.com/redis/go-redis/v9`); invalidate on update. Measure latency with
  and without the cache. Stop Redis and confirm the API still works.
- **Production view:** cache is an optimisation. The app must still work
  (slower) if Redis is down.
- **Interview questions:**
  1. Cache-aside vs write-through? *(3 levels for "Redis/caching")*
  2. How do you keep the cache consistent with the database?
  3. What is a cache stampede?
- **Likely bug:** stale cache after an update because one write path forgot to
  invalidate.
- **Produce:** `notes/day31-caching.md` with the full decision block
  ([Template B](#b-decision-template-the-why-block): this exact case is its example);
  `docs/caching.md`; **ADR-007: Use Redis cache-aside for event details**;
  `notes/benchmarks/cache.md`; commit `feat(cache): add Redis cache-aside for event details`.
- **Done when:** you have **measured** numbers with and without the cache.

### Day 32: Rate limiting
- **Learn:** algorithms: fixed window, sliding window, **token bucket**, leaky
  bucket; in-memory (`golang.org/x/time/rate`) vs **distributed** (Redis);
  per-IP vs per-user vs per-API-key limits; `429` + `Retry-After`; trusting
  `X-Forwarded-For` only from your own proxy.
- **Build:** a Redis-based limiter middleware (e.g. 100 req/min per user,
  stricter on `/auth/*`).
- **Production view:** with 3 instances, an in-memory limit is effectively 3×
  looser. Read: [`apps/backend/internal/middleware/README.md`](apps/backend/internal/middleware/README.md).
- **Interview questions:**
  1. Explain the token bucket algorithm. *(3 levels)*
  2. Design a rate limiter for a distributed system (a classic interview question).
- **Produce:** `notes/day32-rate-limiting.md`; commit `feat(ratelimit): add Redis-backed rate limiter`.
- **Done when:** a load test shows `429`s exactly at your limit.

### Day 33: Background jobs and sending email
- **Ask first:** Why not `go sendEmail()`? Could Postgres alone be the queue?
  What if the job runs twice? What if the worker is down for an hour?
- **Learn:** why slow or unreliable work leaves the request path; queues;
  retries with backoff; dead-letter queues; **idempotent job handlers**;
  scheduled jobs. Options: **River** (Postgres-based, lets you enqueue
  **in the same transaction** as the booking) or **Asynq** (Redis-based, used
  in the PGG boilerplate). Email templates with `html/template`.
- **Build:** a booking confirmation email job and the verification/reset
  emails from Day 24, sent through the queue to Mailpit. A scheduled job:
  "reminder 24 h before the event".
- **Production view:** workers often run as a **separate process**
  (`cmd/worker`) so they scale independently. Read:
  [`apps/backend/docs/14-background-jobs.md`](apps/backend/docs/14-background-jobs.md).
- **Interview questions:**
  1. Why not just `go sendEmail()` inside the handler? *(3 levels for "queues")*
  2. What does "idempotent job" mean, and why does it matter?
  3. The DB commit succeeded but the enqueue failed. What now? (Outbox pattern, Day 42.)
- **Likely bug:** a duplicate email because a job was retried after it had
  already sent.
- **Produce:** `notes/day33-background-jobs.md`; `docs/background-jobs.md`;
  **ADR-008: Use River (or Asynq) for background jobs**; **diagram:
  background-job flow**; commit `feat(worker): enqueue booking confirmation emails`.
- **Done when:** stopping the worker, booking, then starting the worker still delivers the email.

### Day 34: Idempotency, retries and resilience
- **Learn:** network calls fail; **timeouts on every outgoing call**; retries
  with **exponential backoff + jitter**; only retry idempotent operations;
  **Idempotency-Key** header for `POST` (store key → response); circuit
  breakers (concept); simulating a payment provider.
- **Build:** a fake "payment service" that randomly fails or is slow. Booking
  calls it with a timeout and retries. `POST /bookings` accepts
  `Idempotency-Key`: the same key returns the same response and never books twice.
- **Interview questions:**
  1. The client times out and retries a payment. How do you avoid charging twice?
  2. Why add jitter to retries?
- **Produce:** `notes/day34-idempotency.md`; README → start **Interesting
  Engineering Problems #4: Reliable Background Jobs** (queue → retry →
  idempotency); commit `feat(booking): support Idempotency-Key header`.
- **Done when:** sending the same booking request 5 times with one key creates exactly 1 booking.

### Day 35: File uploads and object storage
- **Ask first:** Why not store files on the API server's disk? What happens
  with 3 instances? Who pays the bandwidth for a 50 MB upload?
- **Learn:** `multipart/form-data`; size limits; checking the **real** content
  type (`http.DetectContentType`), not the filename; never storing uploads on
  the app server's disk; S3-compatible storage; **presigned URLs** (the client
  uploads directly to storage).
- **Build:** **MinIO** in Docker Compose; event poster upload with a presigned
  URL flow: `POST /events/{id}/poster-upload-url` → client PUTs to MinIO →
  `POST /events/{id}/poster/confirm`. MinIO keys only in `.env`.
- **Interview questions:**
  1. How would you handle 2 GB video uploads?
  2. What are the security risks of file uploads?
- **Produce:** `notes/day35-uploads.md`; commit `feat(events): upload posters via presigned URLs`.
- **Done when:** a poster uploads and its URL is returned in `GET /events/{id}`.

### Day 36: Observability I: metrics and health checks
- **Learn:** logs vs metrics vs traces; **RED** metrics (Rate, Errors,
  Duration) for services; Prometheus counters, gauges, histograms; **liveness
  vs readiness** probes.
- **Build:** `/metrics` with `prometheus/client_golang` (request count,
  latency histogram per route, bookings created, jobs failed); `/livez` and
  `/readyz` (checks DB + Redis). Optional: Prometheus + Grafana in Compose and
  one dashboard.
- **Production view:** alerts fire on metrics (error rate, latency), and you
  then use logs and traces to find the cause. Read:
  [`apps/backend/docs/11-tracing-new-relic.md`](apps/backend/docs/11-tracing-new-relic.md),
  [`18-health-checks.md`](apps/backend/docs/18-health-checks.md).
- **Interview questions:**
  1. Liveness vs readiness? What goes wrong if they are the same endpoint?
  2. Why use a histogram for latency instead of an average?
- **Produce:** `notes/day36-metrics.md`; start `docs/observability.md`; commit
  `feat(observability): add Prometheus metrics and health probes`.
- **Done when:** you can see request rate and p95 latency per route.

### Day 37: Observability II: tracing and profiling
- **Learn:** distributed tracing (trace, span, context propagation);
  **OpenTelemetry** in Go (`otelhttp`, manual spans, DB spans); **pprof** (CPU,
  heap, goroutine profiles); never expose pprof publicly.
- **Build:** OpenTelemetry traces exported to **Jaeger** in Compose. A span for
  the booking transaction and the payment call. pprof on a separate internal
  port. Find one slow thing with a trace or a profile and fix it.
- **Interview questions:**
  1. A request is slow only sometimes. How do you find out why?
  2. How do you find a goroutine leak or a memory leak in Go?
- **Likely bug:** whatever the trace reveals. Log it in `notes/debugging.md`
  as "diagnosed latency with tracing" (story #9).
- **Produce:** `notes/day37-tracing.md`; finish `docs/observability.md`; commit
  `feat(observability): add OpenTelemetry tracing`.
- **Done when:** you can show a trace with HTTP → service → SQL → payment spans.

### Day 38: Security review of your own API
- **Learn:** [OWASP API Security Top 10](https://owasp.org/API-Security/);
  SQL injection, BOLA, mass assignment, excessive data exposure, SSRF;
  security headers; CORS done correctly; TLS; secrets management; dependency
  scanning (`govulncheck`), static analysis (`gosec`, via `golangci-lint`).
- **Build:** go through the OWASP list **against booker** and write
  `SECURITY.md` with what you checked and fixed. Run `govulncheck ./...`.
  Make sure no response leaks `password_hash` or internal IDs it shouldn't.
  Search your **entire git history** for secrets (e.g. with `gitleaks`).
- **Production view:** read [`apps/backend/docs/17-security.md`](apps/backend/docs/17-security.md).
- **Interview questions:**
  1. Name 5 API security risks and how your project handles them.
  2. What is mass assignment? How do DTOs prevent it?
- **Produce:** `SECURITY.md`; README → **Security** section (short summary + link);
  commit `docs: add security review`.
- **Done when:** `SECURITY.md` is committed, `govulncheck` is clean, and no secret exists in git history.

### Day 39: Review
- Re-answer Days 29–38. Final **diagram: architecture** (API, worker, Postgres,
  Redis, MinIO, Jaeger, Prometheus) in `docs/diagrams/` and the README.
- Update `docs/architecture.md` to match reality.
- **Done when:** `docker compose up` starts the whole system with one command.

---

## Phase 7: Advanced Go backend

### Day 40: Concurrency patterns in real backends
- **Learn:** worker pools; fan-out / fan-in; `golang.org/x/sync/errgroup`
  (with `SetLimit` for bounded concurrency); semaphores (buffered channels);
  cancellation with context; **goroutine leaks** and how to avoid them;
  `sync.Once`, `sync.Pool`, `atomic`; when to use channels vs mutexes.
- **Build:** `POST /events/import` that takes a CSV of 10,000 events, validates
  and inserts them with a bounded worker pool, stops everything on the first
  fatal error, and reports per-row errors.
- **Interview questions:**
  1. Channels vs mutex: when do you use which? *(3 levels for "goroutines" and "channels")*
  2. How do you limit concurrency to 10 at a time?
  3. What causes a goroutine leak? How do you detect it?
- **Likely bug:** a goroutine leak (workers blocked on a channel nobody reads
  after cancellation). Prove it with the pprof goroutine count, then fix it.
- **Produce:** `notes/day40-concurrency-patterns.md`; commit
  `feat(events): add bounded concurrent CSV import`.
- **Done when:** the import is fast, bounded, cancellable and leak-free.

### Day 41: Real-time: WebSockets and Server-Sent Events
- **Learn:** polling vs long polling vs **SSE** vs **WebSockets**; the **hub
  pattern** (one goroutine owns the clients map; register/unregister/broadcast
  channels); backpressure and slow clients; scaling across instances with
  Redis pub/sub.
- **Build:** live "seats left" updates for an event page, via SSE (simpler)
  or WebSockets (`github.com/coder/websocket` or `gorilla/websocket`),
  broadcasting through Redis pub/sub so it works with multiple instances.
- **Interview questions:**
  1. SSE vs WebSockets: when to use which?
  2. How do you send real-time updates when you run 5 server instances?
- **Produce:** `notes/day41-realtime.md`; commit `feat(realtime): stream seat updates over SSE`.
- **Done when:** two browser tabs see the seat count drop live when a booking happens.

### Day 42: Event-driven architecture and the outbox pattern
- **Ask first:** answer all [10 questions](#4-ask-these-10-questions-before-adding-any-technology)
  for NATS in your note **before** installing it. Your answer should arrive at
  the *dual-write problem* by itself.
- **Learn:** message brokers (Kafka, RabbitMQ, **NATS**); pub/sub vs queues;
  at-least-once delivery and idempotent consumers; ordering; the **dual-write
  problem** and the **transactional outbox** pattern.
- **Build:** write a `BookingCreated` row to an `outbox` table **in the same
  transaction** as the booking; a relay publishes outbox rows to NATS; a
  separate consumer (e.g. "analytics") processes them idempotently.
- **Interview questions:**
  1. What is the dual-write problem? How does the outbox pattern solve it?
  2. At-least-once vs exactly-once delivery?
- **Produce:** `notes/day42-outbox.md`; **ADR-009: Use a transactional outbox
  for domain events**; **diagram: event/outbox flow**; README → finish
  **Interesting Engineering Problems #4** (queue → retry → idempotency → outbox);
  commit `feat(events): publish booking events via transactional outbox`.
- **Done when:** killing the relay mid-way and restarting it loses no events and creates no duplicates in the consumer.

### Day 43: gRPC and Protocol Buffers
- **Ask first:** does booker *need* a second service, or is this for learning?
  Say so honestly in the ADR or note. "To learn gRPC" is a fine reason in a
  learning project, as long as you know it.
- **Learn:** when gRPC beats REST (internal service-to-service, streaming,
  strict contracts); `.proto` files; code generation (`protoc` or `buf`);
  unary vs streaming RPCs; deadlines; interceptors (gRPC's middleware).
- **Build:** split notifications into a tiny **notification service** with a
  gRPC API; booker calls it with a deadline.
- **Interview questions:**
  1. REST vs gRPC: trade-offs?
  2. What are protobufs and why are they smaller/faster than JSON?
- **Produce:** `notes/day43-grpc.md`; commit `feat(notify): add gRPC notification service`.
- **Done when:** booker calls the notification service over gRPC and handles it being down.

### Day 44: Performance: benchmarks, profiling and load testing
- **Learn:** `testing.B` benchmarks and `-benchmem`; reading CPU and memory
  profiles; reducing allocations; escape analysis (`-gcflags=-m`) at a basic
  level; load testing with **k6** (or `vegeta`); p50/p95/p99.
- **Build:** load-test `GET /events` and `POST /bookings` at increasing
  load; find the first bottleneck (pool size? missing index? JSON?), fix it,
  and re-test.
- **Interview questions:**
  1. Your API's p99 latency doubled after a release. What do you do, step by step?
  2. What is p99 latency and why does it matter more than the average?
- **Produce:** `notes/benchmarks/load-test.md` (before/after table);
  README → **Performance** section (measured numbers only); commit
  `perf: <what you actually fixed>`.
- **Done when:** you have a before/after table with the exact k6 command and hardware.

### Day 45: Review
- Re-answer Days 40–44. Every advanced feature in the README gets one sentence
  of **why** it exists (link to its ADR).
- Re-read `notes/debugging.md` and make sure each entry has a clear
  "how I verified" line.

---

## Phase 8: Ship it

### Day 46: Docker and Docker Compose for production
- **Learn:** multi-stage builds; small images (`distroless` / `alpine`);
  `CGO_ENABLED=0`; running as **non-root**; `.dockerignore` (include `.env`!);
  layer caching (copy `go.mod` first); health checks in Compose.
- **Build:** a production `Dockerfile` for `api` and `worker` (under ~30 MB);
  `docker-compose.yml` running the whole system.
- **Interview questions:**
  1. Why multi-stage builds? Why non-root? *(3 levels for "Docker")*
  2. Container vs virtual machine?
- **Produce:** `notes/day46-docker.md`; commit `build: add multi-stage Dockerfiles`.
- **Done when:** `docker compose up --build` starts everything from scratch,
  and `docker history` shows no secrets baked into the image.

### Day 47: CI/CD with GitHub Actions
- **Learn:** continuous integration vs delivery vs deployment; a pipeline that
  runs lint → test (`-race`) → vulnerability scan → build → push image;
  caching Go modules; **secrets in CI** (GitHub Actions secrets, never in the YAML).
- **Build:** `.github/workflows/ci.yml` running `golangci-lint`,
  `go test -race ./...` (with Testcontainers), `govulncheck`, and a Docker
  build on every push and pull request. Add the CI badge to the README.
- **Interview questions:**
  1. What does your CI pipeline do, and why in that order?
- **Produce:** `notes/day47-ci.md`; commit `ci: add lint, test and vulnerability scan workflow`.
- **Done when:** a pull request with a failing test is blocked by CI.

### Day 48: Deploy to the cloud
- **Learn:** managed Postgres/Redis vs self-hosted; environment variables and
  secrets in a platform; running migrations on deploy; HTTPS; custom domain;
  zero-downtime deploys; logs in the cloud.
- **Build:** deploy booker to a platform such as **Fly.io, Render or Railway**
  (or a small VPS with Docker + Caddy for automatic HTTPS). Secrets are set in
  the platform's dashboard/CLI, not in files. Put the **live URL** and the API
  docs link at the top of the README.
- **Production view:** checklist: [`apps/backend/docs/26-production-checklist.md`](apps/backend/docs/26-production-checklist.md).
- **Interview questions:**
  1. Walk me through what happens when you push code until it is live.
- **Produce:** `notes/day48-deploy.md`; **ADR-010: Deployment platform**;
  **diagram: deployment architecture**; commit `ci: deploy to <platform>`.
- **Done when:** a stranger can call your live API from the README.

### Day 49: System design fundamentals
- **Learn:** vertical vs horizontal scaling; stateless services; load
  balancers; DB read replicas, sharding (concept), connection limits; caching
  layers and CDNs; queues for async work; CAP theorem in plain words;
  back-of-the-envelope estimates.
  Resources: *System Design Interview* (Alex Xu), ByteByteGo,
  *Designing Data-Intensive Applications*.
- **Build:** `docs/scaling.md`: "How booker would handle a concert sale with
  1 million users in 10 minutes" (queue-based waiting room, cache, read
  replicas, the seat-locking strategy from Day 13).
- **Interview questions:**
  1. How would you scale your project to 100× the traffic?
  2. What is a stateless service, and why does it make scaling easy?
- **Produce:** `docs/scaling.md`; commit `docs: add scaling plan`.
- **Done when:** you can explain your scaling plan in 5 minutes with a diagram.

### Day 50: Polish the README and repository
- Rewrite `README.md` using [Template G](#g-booker-readme-template-interviewer-first),
  with **Interesting Engineering Problems** near the top.
- Check every number in the README links to a file in `notes/benchmarks/`.
- Check all 7 diagrams exist and match the code.
- Clean up: delete dead code, fix lint warnings, make sure tests are green.
- **Done when:** a recruiter who reads only the first screen of the README
  understands what you built and the hardest problem you solved.

---

## Phase 9: Interview preparation

### Day 51: Go language deep-dive questions
Be able to answer clearly, with small code examples:
- Goroutines vs OS threads; the **GMP scheduler** (in simple words).
- Buffered vs unbuffered channels; closing channels; `select`; nil channels.
- `sync.Mutex` vs `RWMutex` vs channels; `sync.WaitGroup`; `sync.Once`.
- Slices: `len` vs `cap`, how `append` grows, shared backing arrays (a classic bug).
- Maps aren't safe for concurrent writes (`fatal error: concurrent map writes`).
- Interfaces: implicit implementation; the **nil interface vs typed nil** gotcha.
- `defer` order and argument evaluation; `panic` / `recover`.
- Value vs pointer receivers; when to use each.
- Go 1.22 loop-variable change; generics basics; `context` usage rules.
- Garbage collector basics; escape analysis (stack vs heap).
- **Produce:** a `# Go` section in the interview bank with all of the above.
- **Done when:** you can explain 10 of these with a code snippet from memory.

### Day 52: Polish the interview bank
You have been filling `notes/interview-bank.md` since Day 0. Today you
**tighten** it, not start it:
- Every question has an answer **in your own words**, never copied definitions.
- The 12 core topics have all **three levels** (15 s / 60 s / 5 min): HTTP,
  index, transaction, JWT, RBAC, context, goroutines, channels, Redis, rate
  limiting, queues, Docker.
- Each answer that can point to booker does: *"In booker, I…"*.
- **Done when:** a friend can pick any question at random and you answer it well.

### Day 53: System design practice
Practise on paper, out loud, 45 minutes each:
1. **URL shortener** (ID generation, redirects, caching, analytics).
2. **Rate limiter** (you built one, so explain the distributed version).
3. **Ticket booking system** (you built this! Explain it at scale.)
Use the structure: requirements → API → data model → high-level design →
deep dives (bottlenecks) → trade-offs.

### Day 54: Speed build: a URL shortener in one day
Without looking at booker, build a small URL shortener API: create short link,
redirect, click count, expiry, rate limit, Postgres, Docker, tests. This proves
the skills are **yours**, and gives you a second, smaller project for the resume.

### Day 55: Resume, GitHub profile and project storytelling
- **Resume bullets.** Fill the `<...>` only with **your measured numbers**:
  - *Built **booker**, an event booking REST API in Go (net/http, PostgreSQL,
    Redis), with JWT auth plus refresh-token rotation, RBAC, and Google OAuth.*
  - *Prevented ticket overselling under concurrent load with atomic conditional
    updates in PostgreSQL; reproduced and verified with a 200-goroutine race test.*
  - *Reduced event-listing latency from `<before>` to `<after>` (measured on
    `<dataset>`) with composite indexes and Redis cache-aside.*
  - *Shipped with Docker and GitHub Actions CI (lint, race-tested integration
    tests via Testcontainers); deployed at `<your-url>`.*
- **STAR stories** (Situation, Task, Action, Result) for at least your top 3
  stories. Example for story #1 (use **your** real results):
  > **S:** In my booking API, concurrent users could book the same last seats.
  > **T:** I had to guarantee we never sell more tickets than capacity, even
  > with multiple server instances.
  > **A:** I wrote a test with 200 goroutines and reproduced overselling with
  > the naive read-check-write code. I replaced it with an atomic
  > `UPDATE ... WHERE seats_left >= $n` inside the booking transaction, and
  > compared it with `SELECT ... FOR UPDATE`.
  > **R:** Before the fix, `<N>` bookings succeeded for 10 seats; after it,
  > exactly 10, every run, under `-race`. I also learned why in-process mutexes
  > don't work across instances.
- Pin booker (and the URL shortener) on your GitHub profile; write a profile README.

### Day 56: Mock interviews
- Record yourself answering: "Tell me about your project" in **2 minutes**, then
  in **10 minutes** with a diagram.
- Answer *"Tell me about a difficult bug"* using an entry from `notes/debugging.md`.
- Do one mock interview with a friend (or a peer-practice site): one DSA problem
  + project deep-dive + 5 backend questions.
- Review the recordings, fix weak answers, repeat.
- **Done when:** you can explain any part of booker confidently when asked "why?"
  three times in a row.

---

## Templates

### A. Daily note template (1–3 pages max)

File: `notes/dayNN-topic.md`. Worked example for **Day 22 (JWT)**:

````markdown
# Day 22: JWT

## 1. Problem
What problem does this solve?
JWT lets the server verify authenticated requests without looking up a
session in the database on every request.

## 2. Mental model
header.payload.signature

Client
  ↓ Bearer token
Auth middleware
  ↓ verify signature
  ↓ validate exp / iss / aud
  ↓ extract user ID → context
Handler

## 3. What I built
- Login issues an access token (15-minute expiry)
- RequireAuth middleware puts user_id into context
- Expired / tampered tokens are rejected

Code: internal/auth/token.go, internal/http/middleware/auth.go

## 4. Important concepts
- exp: expiration time
- iss: who issued the token
- aud: who the token is for
- JWT is NOT encrypted: anyone can decode the payload

## 5. Production concerns
Short expiry · no sensitive data in payload · restrict signing algorithm ·
key rotation · refresh-token revocation

## 6. Trade-offs
JWT:     + stateless verification, + good for many services
         − hard to revoke immediately, − token management complexity
Session: + easy revocation, + simple for browsers
         − needs shared session storage

## 7. Interview questions
Q: JWT vs sessions?        My answer: ...
Q: Can a JWT be revoked?   My answer: ...

## 8. Explain it at three levels
- 15 s: ...
- 60 s: ...
- 5 min: (bullet outline) ...

## 9. Mistake I made today
I first trusted claims without validating issuer/audience.
Why that is dangerous: ...  (→ also logged in notes/debugging.md)

## 10. One-line revision
JWT = signed credentials the backend verifies locally; short-lived access
tokens + revocable refresh tokens solve most session-management problems.
````

### B. Decision template (the "Why?" block)

Use it in daily notes and in `docs/*.md` for every component.

```markdown
**Problem:** GET /events/{id} was hitting Postgres on every request.
**Decision:** Redis cache-aside.
**Why:** event details are read frequently and updated rarely.
**Trade-off:** cache invalidation becomes necessary.
**Failure behaviour:** if Redis is unavailable, fall back to PostgreSQL.
**Alternative rejected:** in-process cache, because multiple instances would
hold different, inconsistent caches.
```

### C. ADR template

ADR = **Architecture Decision Record**: one short file per major, project-wide
choice in `docs/adr/`. When an interviewer asks *"why didn't you use GORM?"*,
you already have the answer.

```markdown
# ADR-003: Use pgx + sqlc instead of GORM

## Context
Booker needs explicit control over queries, transactions and locking.

## Decision
Use PostgreSQL through pgx, with sqlc-generated query code.

## Why
- SQL stays visible and reviewable
- Type-safe generated Go
- Easier query optimisation
- Explicit transactions

## Trade-offs
- More SQL written by hand
- Slightly slower initial development

## Alternatives considered
GORM · database/sql · raw pgx without codegen
```

**The ADRs you will write:**

| ADR | Decision | Day |
|-----|----------|-----|
| 001 | Use `net/http` instead of a web framework | 2 |
| 002 | Use PostgreSQL | 8 |
| 003 | Use pgx + sqlc instead of GORM | 11 |
| 004 | Prevent overselling with an atomic conditional update | 13 |
| 005 | Use cursor pagination for event listing | 15 |
| 006 | JWT access tokens + rotating refresh tokens | 23 |
| 007 | Use Redis cache-aside for event details | 31 |
| 008 | Use River (or Asynq) for background jobs | 33 |
| 009 | Use a transactional outbox for domain events | 42 |
| 010 | Deployment platform | 48 |

### D. Debugging entry template

File: `notes/debugging.md`. One entry per meaningful bug:

```markdown
## Ticket overselling

**Symptom:** 11 bookings succeeded when only 10 seats existed.
**Cause:** read-check-write race between concurrent requests.
**Wrong assumption:** a sync.Mutex would protect it.
**Why that isn't production-safe:** multiple API instances don't share a mutex.
**Fix:** atomic conditional UPDATE in PostgreSQL.
**How I verified:** 200 concurrent booking attempts, 20 runs, -race.
```

Bugs you will very likely meet (log each one when it happens): concurrent map
writes · CORS error · context cancellation not propagated · connection pool
exhausted · transaction rollback bug · ticket overselling · N+1 queries · JWT
claim/expiry bug · stale cache · duplicate background job · goroutine leak.

### E. Benchmark template

Files in `notes/benchmarks/`. **Only real, measured numbers.**

````markdown
# Index on events(city, starts_at)

**Dataset:** 1,000,000 events (seed script: `make seed N=1000000`)
**Machine:** <CPU, RAM, Docker or native>
**Query:** SELECT ... FROM events WHERE city = 'Kathmandu' ORDER BY starts_at LIMIT 20;
**Tool / command:** EXPLAIN (ANALYZE, BUFFERS) ...  and  k6 run load.js

## Before
p50: <measured>   p95: <measured>
Plan: Seq Scan on events ...

## After
Index: CREATE INDEX idx_events_city_starts_at ON events (city, starts_at);
p50: <measured>   p95: <measured>
Plan: Index Scan using idx_events_city_starts_at ...

## Raw output
```
<paste EXPLAIN / k6 output here>
```
````

### F. Interview bank format

File: `notes/interview-bank.md`. Create it on **Day 0** and add to it **every
day**. Answer in your own words; never memorise definitions word for word.

```markdown
# HTTP
### What happens when you enter a URL?
(60–90 second answer)
### PUT vs PATCH?
(30 second answer)

# PostgreSQL
### What is an index?
### Why not index every column?
### What is a transaction?
### What is an isolation level?

# Go
### Channel vs mutex?
### Goroutine vs OS thread?

# Authentication
### Authentication vs authorization?
### JWT vs sessions?
### Why refresh tokens?
```

**The three explanation levels.** For each core topic, prepare:

| Level | Length | Example (index) |
|-------|--------|-----------------|
| 15 seconds | 1 sentence | "An index is an extra data structure that lets the database find rows without scanning the whole table." |
| 60 seconds | a short paragraph | B-tree lookup, why it's fast, the write-cost trade-off |
| 5 minutes | a whiteboard talk | B-tree → composite index order → query planner → `EXPLAIN` → write cost → **your booker experiment with real numbers** |

Do this for: HTTP · index · transaction · JWT · RBAC · context · goroutines ·
channels · Redis · rate limiting · queues · Docker.

### G. booker README template (interviewer-first)

The README explains the **finished engineering project**. No diary entries.
The **Interesting Engineering Problems** section goes near the top, because a
recruiter won't read 15,000 lines of Go, but they *will* read three
paragraphs about a real problem you solved.

```markdown
# Booker

Production-oriented event booking backend built in Go.

[Live API](<url>) · [API Docs](<url>/docs) · ![CI](<badge-url>)

## Why I Built This
One short paragraph: concurrent ticket booking, authentication/authorization,
scalable reads, asynchronous processing.

## Interesting Engineering Problems

### 1. Preventing Ticket Overselling
The original read-check-update implementation oversold tickets under
concurrent requests. I reproduced it with 200 concurrent goroutines against a
10-seat event (<N> bookings succeeded), then replaced it with an atomic
PostgreSQL conditional update inside a transaction. Now exactly 10 succeed,
every run. → docs/concurrency.md · ADR-004

### 2. Authentication Architecture
Access tokens → refresh-token rotation with reuse detection → RBAC →
ownership checks. → docs/authentication.md · ADR-006

### 3. Database Performance
Query → EXPLAIN ANALYZE → composite index → measured improvement
(<before> → <after>). → notes/benchmarks/indexes.md

### 4. Reliable Background Jobs
Queue → retries → idempotent handlers → transactional outbox.
→ docs/background-jobs.md · ADR-009

## Architecture
(diagram: docs/diagrams/architecture)
Client → Go API (middleware → handler → service → repository) → PostgreSQL
                                            ↘ Redis · Worker · Object storage · NATS

## Core Features
Authentication · Authorization · Booking · Concurrency control · Caching ·
Background jobs · Rate limiting · Real-time updates · Observability

## Technical Decisions
Why net/http? Why pgx + sqlc? Why PostgreSQL? Why Redis? Why NATS?
(one line each, linking to docs/adr/)

## Project Structure
cmd/ · internal/ · migrations/ · docs/ · notes/

## API
Main endpoints + link to OpenAPI / Swagger UI

## Running Locally
git clone … · cp .env.example .env · docker compose up -d · make migrate-up · go run ./cmd/api

## Testing
go test ./... · go test -race ./...

## Performance
Measured numbers only (link to notes/benchmarks/).

## Security
Short summary + link to SECURITY.md

## What I Learned
5–7 meaningful points (engineering lessons, not a list of tools)

## Future Improvements
```

### H. The 7 diagrams

Only the major ones, in `docs/diagrams/`. Draw each one, then practise
**redrawing it from memory**.

| Diagram | Day |
|---------|-----|
| Request lifecycle (middleware → handler → service → repository → Postgres) | 6 |
| Booking transaction | 12 |
| Authentication flow | 23 |
| Background-job flow | 33 |
| Event / outbox flow | 42 |
| Architecture (all components) | 39 |
| Deployment architecture | 48 |

Example (request lifecycle):

```
HTTP Request
     │
     ▼
┌────────────┐
│ Middleware │
└─────┬──────┘
      ▼
┌────────────┐
│  Handler   │
└─────┬──────┘
      │ DTO
      ▼
┌────────────┐
│  Service   │
└─────┬──────┘
      ▼
┌────────────┐
│ Repository │
└─────┬──────┘
      ▼
 PostgreSQL
```

### I. Commit messages

Format: `type(scope): what changed`. Types: `feat`, `fix`, `test`, `refactor`,
`perf`, `docs`, `build`, `ci`, `chore`.

```
feat(auth): add password-based registration
feat(auth): implement JWT access tokens
feat(auth): rotate refresh tokens
feat(booking): add transactional seat reservation
test(booking): reproduce concurrent overselling
fix(booking): prevent overselling with atomic update
perf(events): add composite city/start-time index
feat(cache): add Redis cache-aside for event details
feat(worker): enqueue booking confirmation emails
```

Committing the failing test **before** the fix (Day 13) makes your history
tell the story on its own.

---

## The 10 engineering stories you are collecting

These are what you will talk about in interviews. Each needs **evidence**.

| # | Story | Day(s) | Evidence |
|---|-------|--------|----------|
| 1 | "I caused a race condition (overselling) and fixed it." | 13 | concurrency test · `debugging.md` · `benchmarks/booking-concurrency.md` · ADR-004 |
| 2 | "I optimised a slow query." | 14 | `benchmarks/indexes.md` (EXPLAIN before/after) |
| 3 | "I designed authentication." | 20–24 | `docs/authentication.md` · auth-flow diagram |
| 4 | "I handled token revocation." | 23 | reuse-detection test · ADR-006 |
| 5 | "I designed authorization correctly." | 25 | BOLA test (user A can't access B's data) |
| 6 | "I handled request cancellation." | 5, 40 | `/slow` endpoint · import cancellation |
| 7 | "I made a job idempotent." | 33–34 | Idempotency-Key test · duplicate-email bug entry |
| 8 | "I solved a dual-write problem." | 42 | outbox relay test · ADR-009 |
| 9 | "I diagnosed latency using tracing." | 37, 44 | trace screenshot · `benchmarks/load-test.md` |
| 10 | "I containerized and deployed the system." | 46–48 | Dockerfile · CI badge · live URL · ADR-010 |

When you can tell each story at the 60-second and 5-minute levels, with the
evidence ready to show, you are interview-ready.

---

## Progress tracker

Tick a box (`[ ]` → `[x]`) when a day is **done** (code + note + commit), then commit.

**Phase 0–1: Foundations**
- [ ] Day 0: Tools, skeleton, docs system, `.gitignore`
- [ ] Day 1: How the web works
- [ ] Day 2: HTTP server and CRUD APIs (ADR-001)
- [ ] Day 3: REST API design
- [ ] Day 4: Middleware
- [ ] Day 5: Context, timeouts, graceful shutdown
- [ ] Day 6: Project structure, layers, DI, config (diagram: request lifecycle)
- [ ] Day 7: Review

**Phase 2: Databases**
- [ ] Day 8: Data modeling and SQL (ADR-002)
- [ ] Day 9: Go ↔ Postgres with pgx
- [ ] Day 10: Migrations and seed data
- [ ] Day 11: sqlc vs ORM vs raw SQL (ADR-003)
- [ ] Day 12: Transactions and isolation levels (diagram: booking transaction)
- [ ] Day 13: No double booking ⭐ (ADR-004, story #1)
- [ ] Day 14: Indexes and EXPLAIN (benchmark)
- [ ] Day 15: Pagination, filtering, search (ADR-005)
- [ ] Day 16: Review

**Phase 3: Validation, errors, logging**
- [ ] Day 17: Validation vs verification
- [ ] Day 18: Error handling architecture
- [ ] Day 19: Structured logging with slog

**Phase 4: Auth deep dive**
- [ ] Day 20: Password storage, register/login
- [ ] Day 21: Sessions and cookies, CSRF
- [ ] Day 22: JWT deep dive
- [ ] Day 23: Refresh tokens, rotation, logout (ADR-006, diagram: auth flow)
- [ ] Day 24: Email verification, password reset, OTP
- [ ] Day 25: RBAC and ownership
- [ ] Day 26: OAuth 2.0 / OpenID Connect
- [ ] Day 27: Auth hardening, MFA, API keys
- [ ] Day 28: Review: auth architecture

**Phase 5: Testing**
- [ ] Day 29: Unit and handler tests
- [ ] Day 30: Integration tests, race detector

**Phase 6: Production essentials**
- [ ] Day 31: Caching with Redis (ADR-007, benchmark)
- [ ] Day 32: Rate limiting
- [ ] Day 33: Background jobs and email (ADR-008, diagram: job flow)
- [ ] Day 34: Idempotency, retries, resilience
- [ ] Day 35: File uploads and object storage
- [ ] Day 36: Metrics and health checks
- [ ] Day 37: Tracing and profiling
- [ ] Day 38: Security review (`SECURITY.md`)
- [ ] Day 39: Review (diagram: architecture)

**Phase 7: Advanced**
- [ ] Day 40: Concurrency patterns
- [ ] Day 41: WebSockets / SSE
- [ ] Day 42: Event-driven + outbox (ADR-009, diagram: outbox flow)
- [ ] Day 43: gRPC and protobuf
- [ ] Day 44: Performance and load testing (benchmark)
- [ ] Day 45: Review

**Phase 8: Ship it**
- [ ] Day 46: Docker
- [ ] Day 47: CI/CD
- [ ] Day 48: Deploy (ADR-010, diagram: deployment)
- [ ] Day 49: System design fundamentals (`docs/scaling.md`)
- [ ] Day 50: Polish README and repository

**Phase 9: Interview prep**
- [ ] Day 51: Go deep-dive questions
- [ ] Day 52: Polish the interview bank
- [ ] Day 53: System design practice
- [ ] Day 54: Speed build: URL shortener
- [ ] Day 55: Resume and storytelling
- [ ] Day 56: Mock interviews
