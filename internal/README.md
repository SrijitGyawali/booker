# internal/

All of booker's application code. Go's `internal/` rule means these packages
can only be imported from inside this module, so they can change freely
without breaking anyone else.

## Planned packages

Packages are added on the day they are needed, never ahead of time.

| Package | Responsibility | Day |
|---------|----------------|-----|
| `config` | Load configuration from the environment and validate it at startup | 6 |
| `http` | Router, handlers, middleware, JSON helpers | 2 → 6 |
| `event` | Events: model, service, repository | 6 |
| `booking` | Bookings and seat reservation | 12 |
| `apperr` | Domain errors and their mapping to HTTP responses | 18 |
| `auth` | Passwords, sessions, tokens, verification flows, OAuth | 20 |

How the layers fit together, and what each one is *not* allowed to do, is
documented in [`docs/architecture.md`](../docs/architecture.md) (Day 6).
