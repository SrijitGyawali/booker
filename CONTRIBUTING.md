# Contributing

Booker is a solo learning project built in the open, but it follows the habits
of a team codebase: small commits with clear messages, checks before every
commit, and decisions written down.

## Setup

```sh
cp .env.example .env    # set POSTGRES_PASSWORD and REDIS_PASSWORD
make up                 # PostgreSQL + Redis, waits until healthy
make hooks              # enable the pre-commit guard
```

## Commit messages

[Conventional Commits](https://www.conventionalcommits.org/): `type(scope): what changed`

| Type | For |
|------|-----|
| `feat` | New behaviour |
| `fix` | A bug fix |
| `test` | Tests only |
| `refactor` | Restructuring without behaviour change |
| `perf` | A **measured** performance improvement |
| `docs` | Docs, notes, ADRs, diagrams |
| `build` | Docker, Makefile, dependencies |
| `ci` | CI/CD workflows |
| `chore` | Tooling and repository maintenance |

Scopes follow the code: `events`, `booking`, `auth`, `authz`, `db`, `http`,
`cache`, `worker`, …

- Subject in the imperative ("add", not "added"), at most 72 characters, no
  trailing period.
- The body explains **why**. The diff already shows what.
- Never `fix`, `fix2`, `final`, `update` or `working`.
- When reproducing a bug, commit the failing test **before** the fix, so the
  history tells the story on its own.

```text
test(booking): reproduce concurrent overselling
fix(booking): prevent overselling with atomic update
perf(events): add composite city/start-time index
```

## Before every commit

- [ ] `git status`: no `.env`, keys or credentials staged (the pre-commit hook double-checks)
- [ ] `make check`: vet, lint and tests pass
- [ ] `make test-race` for anything concurrent
- [ ] `.env.example` updated if a config key was added (empty value)
- [ ] Docs, ADR or notes updated if behaviour or a decision changed

## Where things go

| Change | Goes in |
|--------|---------|
| Application code | `cmd/`, `internal/`, `migrations/` |
| How the system works | `docs/` |
| Why a major choice was made | `docs/adr/` |
| What I learned | `notes/` |
| Measured numbers | `notes/benchmarks/` |
| Throwaway learning code | `experiments/` |
