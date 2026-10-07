# Diagrams

Seven diagrams describe the whole system. Each is drawn when its feature is
built, then **redrawn from memory** as interview practice and compared with
the original.

| Diagram | Shows | Day |
|---------|-------|-----|
| Request lifecycle | Middleware → handler → service → repository → PostgreSQL | 6 |
| Booking transaction | Seat reservation inside one transaction, success and sold-out paths | 12 |
| Authentication flow | Login → access and refresh tokens → rotation → logout | 23 |
| Background-job flow | Enqueue → worker → retries → dead letter | 33 |
| Architecture | Every component and how they connect | 39 |
| Event / outbox flow | Transaction → outbox → relay → broker → consumer | 42 |
| Deployment | What runs where in production | 48 |

## Format

- **Mermaid inside Markdown** by default: one file per diagram, named after the
  table above in kebab-case (`request-lifecycle.md`). GitHub renders it, it
  diffs cleanly in pull requests, and it lives next to the code it describes.
- **Excalidraw or draw.io** only when free-form layout matters. Commit the
  source file *and* an exported `.svg`, so the diagram renders on GitHub and
  stays editable.
