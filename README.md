# LC 2027 Study Plan

Con's Leaving Cert 2027 planner. It's a single self-contained `index.html` that works on a phone, keeps working offline, and can sync between devices through Supabase.

**Live site:** <https://conalmac08.github.io/study-plan/> (once GitHub Pages is switched on – see `CLAUDE_CODE_SETUP.md`).

## What's in this repo

| File | What it is |
|---|---|
| `index.html` | The whole app – all HTML, CSS and JavaScript inline. Course content is in the `DATA` object near the top. |
| `RESEARCH.md` | Research summary: verified 2027 facts, coursework weightings, key dates, what's still uncertain, and sources. |
| `PLAN_OVERVIEW.md` | Printable week-by-week snapshot of the plan from now to the end of the June 2027 exams. |
| `supabase.sql` | Database setup for sync: a table with row-level security plus two locked-down functions. |
| `SUPABASE_SETUP.md` | Beginner, step-by-step guide to connecting Supabase. |
| `CLAUDE_CODE_SETUP.md` | Ready-to-paste instructions for Claude Code: publish on GitHub Pages and connect Supabase. |
| `sw.js` | Optional. Lets the site open with no internet after the first visit. The app works without it. |
| `.nojekyll` | Tells GitHub Pages to serve the files as they are. |

## The app at a glance

- **Today** – your blocks for tonight with times, what's due soon, countdowns, reviews due, and this week's timed hours.
  - ▶ starts the timer for a block, and the block ticks off when the timer finishes.
  - Rate each topic 1–3 afterwards and it comes back on a spaced-repetition schedule.
- **Subjects** – one tab per subject with collapsible categories, sub-categories and topics.
  - Each topic has a tick box, a 1–3 confidence rating, exam frequency, difficulty, the next review date and cross-subject links.
  - Each subject also has its coursework milestones (with editable dates and hours left), a past-papers tracker and SEC links.
- **Plan** – the week view, plus a whole-year list of every week up to the end of the exams.
- **Timer** – Pomodoro-style 45–60 minute blocks with breaks. It logs time per subject.
- **Dates** – every SEC, school, oral and exam date, each with a countdown. All of them are editable.
- **⚙ Settings** – work day (Sat/Sun), hours per day, start times, block length, grind, grades, Geography elective/option, Technology and DCG options, sync, export/import, theme.
- **🌙 button** – one-tap dark/light mode, remembered on each device.

## Editing the course content

Open `index.html` and edit the `DATA` object at the top. The comment above it explains every key.

- Topics, dates, coursework milestones, phases and study tips all live there.
- **Don't change an existing topic's `id`.** Progress is saved against it.
- Change dates in the app's **Dates** tab rather than in the file, unless you want to change the default for every device.

## Running it locally

Double-click `index.html`, or run a tiny server from this folder:

```bash
python3 -m http.server 8000
# then open http://localhost:8000
```

## Privacy

The site is public, but your progress isn't. It stays in your browser, plus your own Supabase row if you set up sync. That row can only be reached with your private 48-character sync ID. Don't share the sync ID or your JSON backups. No teacher's materials, past students' work or school-confidential material are included – everything is paraphrased from public sources.
