## What

<!-- What changes, in one or two sentences. Which roadmap day does it belong to? -->

## Why

<!-- The problem this solves. Link the ADR or note if there is one. -->

## How I verified it

<!-- Tests added, commands run, measured numbers (link to notes/benchmarks/). -->

## Checklist

- [ ] `make check` passes (vet, lint, tests)
- [ ] `make test-race` passes for concurrent code
- [ ] No secrets staged; `.env.example` updated for new config keys
- [ ] Docs, ADR or notes updated where behaviour or a decision changed
- [ ] Commit messages follow `type(scope): what changed`
