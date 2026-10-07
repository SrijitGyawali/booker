# migrations/

Versioned SQL schema changes, applied with [goose](https://github.com/pressly/goose)
from Day 10. The schema is code: every change is a reviewed, numbered file,
never a manual edit in `psql`.

## Rules

- Every migration has an **up** and a **down** section, and `down` really undoes `up`.
- **Never edit a migration that has already been applied**, anywhere. Write a new one.
- One logical change per file, named for what it does (`create_events`, `add_events_city_index`).
- Destructive or renaming changes follow **expand → migrate → contract**, so old
  and new code can run side by side during a deploy.
- Prefer database constraints (`NOT NULL`, `UNIQUE`, `CHECK`, foreign keys) over
  application-only checks. They are the last line of defence.

## Commands (added on Day 10)

```sh
make migrate-up
make migrate-down
make seed
```
