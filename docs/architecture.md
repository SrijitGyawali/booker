# Architecture

> **Status:** planned. First version on **Day 6**, updated to match reality on **Day 39**.

How booker is put together, for an engineer joining the project.

## To cover

- **Components:** API, worker, PostgreSQL, Redis, object storage, message
  broker, and what each one is responsible for.
- **Request lifecycle:** middleware → handler → service → repository →
  PostgreSQL, with the [diagram](diagrams/).
- **Package layout:** what lives in `cmd/` and `internal/`, and what each layer
  is allowed (and not allowed) to do.
- **Dependency wiring:** how dependencies are constructed and injected in `main.go`.
- **Configuration:** environment variables, validation at startup, secrets.
- **Decisions:** links to the [ADRs](adr/) that shaped the architecture.
