# experiments/

Throwaway learning code: small, standalone programs that expose what a library
or the standard library hides. Nothing here is part of booker or imported by
it, and it is excluded from lint (see [`.golangci.yml`](../.golangci.yml)).

| Experiment | What it shows | Day |
|------------|---------------|-----|
| `rawtcp/` | An HTTP response written by hand over a raw TCP socket | 1 |

Each experiment is its own `main` package:

```sh
go run ./experiments/rawtcp
```
