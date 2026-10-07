# cmd/

Entry points. Each subdirectory builds one binary. Its `main.go` only **wires
things together**: load config, construct dependencies, start serving, shut
down gracefully. Business logic lives in [`internal/`](../internal/).

| Binary | Purpose | Day |
|--------|---------|-----|
| `api` | HTTP API server | 6 (the code from Days 2–5 moves here) |
| `worker` | Background jobs: emails, reminders | 33 |

```sh
go run ./cmd/api                 # run
go build -o bin/api ./cmd/api    # build (bin/ is git-ignored)
```

If a `main.go` grows past ~80 lines, something in it belongs in `internal/`.
