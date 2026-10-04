# LC 2027 Study Plan

Con's Leaving Cert 2027 planner. It's a single self-contained `index.html` that works on a phone, keeps working offline, and can sync between devices through Supabase.

**Live site:** <https://conalmac08.github.io/Study-Plan/> (once GitHub Pages is switched on – see `CLAUDE_CODE_SETUP.md`).

## What's in this repo

| File | What it is |
|---|---|
| `index.html` | The whole app – all HTML, CSS and JavaScript inline. Course content is in the `DATA` object near the top. |
| `RESEARCH.md` | Research summary: verified 2027 facts, coursework weightings, key dates, what's still uncertain, and sources. |
| `PLAN_OVERVIEW.md` | Printable week-by-week snapshot of the plan from now to the end of the June 2027 exams. |
| `supabase.sql` | Database setup for sync: a table with row-level security plus two locked-down functions. |
| `SUPABASE_SETUP.md` | Beginner, step-by-step guide to connecting Supabase. |
| `GOOGLE_CLASSROOM_SETUP.md` | Optional: connect Google Classroom so assignments and due dates can be imported as tasks. |
| `CLASSROOM_AUTO_SETUP.md` + `classroom-sync.gs` | Optional: an Apps Script that sends your Classroom posts to the app every hour. Use it if your school blocks Google sign-in. |
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
  - Also lists **your own tasks, events and busy days**. Tasks with hours get study time scheduled before they're due.
- **Coach** – an AI study coach (Claude) that changes your plan for you. See below.
- **⚙ Settings** – work day (Sat/Sun), hours per day, start times, block length, grind, grades, Geography elective/option, Technology and DCG options, sync, export/import, theme.
- **🌙 button** – one-tap dark/light mode, remembered on each device.

## AI coach

The **Coach** tab is a chat you can bounce ideas off. It can also edit your plan. For example:
- "I have a Physics test on Friday on electricity" adds a revision task, and the planner fits it in.
- "I'm away all day Saturday" or "I've 5 hours free on Sunday" changes that day's study hours.
- Paste a Google Classroom post or a teacher's email, and it adds every deadline and test in it.
- "We did projectile motion in class today", "I'm shaky on integration", or "Help me plan my comparative essay".

Every change it makes shows as a green ✓ line in the chat, and you can see or delete it on the **Dates** tab.

**Setup:** it uses your own Anthropic API key. Open **Coach**, follow the three steps on screen, and paste the key.
- The key stays in that browser only. It isn't synced, isn't in backups and isn't in the code.
- It's pay-as-you-go, roughly 1–6 cent a message. Set a monthly spend limit in the Anthropic Console.
- Anthropic accounts are for over-18s, so a parent may need to create the account and key.
- Start a **New chat** for new topics. Long chats cost more per message.
- For SEC coursework it gives feedback and structure, not finished text. Any AI help must be acknowledged in your coursework.

## Google Classroom

Your Classroom posts show in a card on **Today**. There are two ways to connect it: Google sign-in (`GOOGLE_CLASSROOM_SETUP.md`), or, if your school blocks that, a script in your own Google account (`CLASSROOM_AUTO_SETUP.md`). Once set up, **Import from Classroom** lists your assignments with due dates, and you tick which ones to add. If your school blocks third-party sign-in, copy the assignment text and paste it into the Coach instead.

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

The site is public, but your progress isn't. It stays in your browser, plus your own Supabase row if you set up sync. That row can only be reached with your private 48-character sync ID. Don't share the sync ID or your JSON backups. Your Anthropic API key and chat stay in your browser on each device. They're never synced or exported, and messages go straight from your browser to Anthropic. No teacher's materials, past students' work or school-confidential material are included – everything is paraphrased from public sources.
