# Ready-to-paste instructions for Claude Code

Open Claude Code (terminal, desktop app or claude.ai/code) in any folder and paste the whole block below. Claude Code will:
1. Make sure the repo exists and the app is on `main`.
2. Turn on GitHub Pages.
3. Walk you through Supabase, then plug your project URL and key into the app.

---

```text
Please publish my Leaving Cert study-plan web app on GitHub Pages and help me connect Supabase sync.

REPO
- GitHub repo: Conalmac08/Study-Plan (public). If it doesn't exist, create it as a PUBLIC repo with that name under my account.
- The finished app and docs are on the branch `claude/lc-2027-study-plan` of that repo:
  index.html (single self-contained app), sw.js, .nojekyll, supabase.sql, SUPABASE_SETUP.md,
  RESEARCH.md, PLAN_OVERVIEW.md, CLAUDE_CODE_SETUP.md and README.md – all at the repo root.
- If `main` doesn't have them yet: open a pull request from `claude/lc-2027-study-plan` into `main`,
  show me the file list, and merge it when I say yes. (If I hand you an index.html file instead,
  commit it to the root of `main`.)

GITHUB PAGES
- Enable Pages from branch `main`, folder `/` (root).
  - With the gh CLI:  gh api -X POST repos/Conalmac08/Study-Plan/pages -f "source[branch]=main" -f "source[path]=/"
    (if it says Pages already exists, run the same command with -X PUT).
  - If you can't do it from here, give me the exact clicks: repo → Settings → Pages →
    Build and deployment → Source "Deploy from a branch" → Branch "main", folder "/ (root)" → Save.
- Wait for the "pages build and deployment" run to finish, then give me the live URL
  (https://conalmac08.github.io/Study-Plan/ – the repo-name part of the address is case-sensitive). Open it and check the browser console shows no errors.

SUPABASE (I've never used it – go one step at a time and wait for me after each step)
- Follow SUPABASE_SETUP.md from the repo: account → new project (region West EU / Ireland, Free plan)
  → SQL Editor → run supabase.sql → copy the Project URL and the publishable key
  (or the legacy "anon public" key).
- Never ask for my database password, and never use the secret / service_role key anywhere.
- When I paste the Project URL and publishable/anon key, set CONFIG.SUPABASE_URL and
  CONFIG.SUPABASE_KEY near the top of index.html. Change nothing else. Commit as
  "Connect Supabase sync", push to main, and confirm Pages has redeployed.

CHECKS
- On the live site, Settings → "Sync between devices" should show a green dot and "Synced …".
- Supabase → Table Editor → study_sync should show one row.
- Then remind me to put my sync ID on my phone: Settings → Copy on one device, then
  "Use a sync ID from another device" on the other.

RULES
- Keep the app a single index.html: no frameworks, build steps or new dependencies.
- Don't change topic ids in the DATA object (saved progress is keyed by them).
- The only key that may be committed is the publishable/anon key. Commit no other secrets.
```

---

### If you'd rather do it by hand

1. **Merge to main.** On github.com open the repo → **Pull requests** → **New** → base `main` ← compare `claude/lc-2027-study-plan` → **Create** → **Merge**.
2. **Turn on Pages.** **Settings → Pages** → Source **Deploy from a branch** → **main** / **(root)** → **Save**. After about a minute the site is at `https://conalmac08.github.io/Study-Plan/`.
3. **Connect Supabase.** Follow `SUPABASE_SETUP.md`.
4. **Add it to your phone.** Open the site in Safari or Chrome → Share / menu → **Add to Home Screen**.
