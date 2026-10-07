# notes/

**What I learned**, written for future me before an interview. How booker
works lives in [`docs/`](../docs/); this folder is about understanding.

| | `notes/` | `docs/` |
|-|----------|---------|
| Audience | Me, before an interview | An engineer joining booker |
| Content | Questions, mental models, mistakes | Facts about this system |
| Tone | Learning | Reference |

## Files

| File | Purpose |
|------|---------|
| `dayNN-topic.md` | One note per day, copied from [`_template.md`](_template.md). **1–3 pages max.** |
| [`interview-bank.md`](interview-bank.md) | Every question and my own answer. Grows every day. |
| [`debugging.md`](debugging.md) | Every real bug I caused, how I found it, how I proved the fix. |
| [`benchmarks/`](benchmarks/) | Measured numbers only, with dataset, machine, command and raw output. |

## Daily routine (about 4–5 hours)

1. **Learn** (~1 h): read the topic; short notes in my own words.
2. **Build** (2–3 h): the day's task in booker.
3. **Note** (~30 min): `notes/dayNN-topic.md` from the template.
4. **Explain** (~20 min): add the day's questions to the interview bank and
   answer them **out loud**.
5. **Commit** (~10 min): `type(scope): what changed`, then tick the day in the
   [progress tracker](../ROADMAP.md#progress-tracker).

Plus 45–60 minutes of DSA in Go every day.

## Rules

- A day is done only when I can **explain it out loud without notes**, the note
  is written, and the code is committed.
- Revision sheets, not textbooks: no copied documentation.
- Always write the **why**: problem → decision → trade-off → failure behaviour
  → alternative rejected.
- **Measure, never invent.** Every number comes from `benchmarks/`.
- Before adding any dependency, answer the
  [10 questions](../ROADMAP.md#4-ask-these-10-questions-before-adding-any-technology) first.
