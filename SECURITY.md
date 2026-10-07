# Security Policy

## Reporting a vulnerability

Please **do not** open a public issue. Report it privately through GitHub's
[private vulnerability reporting](https://github.com/SrijitGyawali/booker/security/advisories/new),
with steps to reproduce and the impact you expect.

## How secrets are handled

- Real secrets (database and Redis passwords, `JWT_SECRET`, OAuth client
  secrets, SMTP and object-storage credentials) live **only** in `.env`
  locally, which is git-ignored, and in the hosting platform's secret store in
  production.
- [`.env.example`](.env.example) lists every configuration key with an
  **empty** value.
- A [pre-commit hook](.githooks/pre-commit) blocks `.env` files, private keys
  and common token formats. Enable it with `make hooks`.
- Local databases listen on `127.0.0.1` only and require a password.
- **If a secret is ever pushed, it is rotated immediately.** Removing the
  commit is not enough: it may already have been cloned, cached or indexed.

## Security review

A full review against the [OWASP API Security Top 10](https://owasp.org/API-Security/)
is planned for Day 38: dependency scanning with `govulncheck`, static analysis
with `gosec`, and a full-history secret scan with `gitleaks`. Its findings and
fixes will be summarised here.
