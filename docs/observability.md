# Observability

> **Status:** planned. Started on **Day 36**, completed on **Day 37**.

## To cover

- **Logs:** structured fields on every line, how to follow one request, what is
  never logged (from Day 19).
- **Metrics:** what `/metrics` exports, request rate, errors and latency per
  route, business metrics (Day 36).
- **Health probes:** `/livez` vs `/readyz` and what each one checks (Day 36).
- **Traces:** spans across HTTP → service → SQL → external calls (Day 37).
- **Profiling:** pprof, and why it is never exposed publicly (Day 37).
- **Runbook:** "the API is slow", and where to look first.
