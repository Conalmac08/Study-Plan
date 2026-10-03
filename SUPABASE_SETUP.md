# Setting up sync with Supabase (beginner walkthrough)

This lets your phone, laptop and any other device share one set of progress. There's no login or password. Your progress is stored under a long random **sync ID** that the app creates the first time it opens. It takes about 10 minutes.

You don't need any of this for the app to work. Without it, progress is saved on each device separately (and you can still move it with **Export / Import JSON**).

---

## What you'll end up with

- A free Supabase project (a hosted database).
- One table, `study_sync`, with one row per sync ID.
- Two small database functions the app calls to read and save **only your row**.
- Your **Project URL** and **publishable key** pasted into the app.

**Is it safe to put the key in a public website?** Yes. The publishable key (older projects call it the *anon* key) is designed to be public. It can only do what the security rules allow, and `supabase.sql` blocks direct access to the table. The app can only read or write a row if it already knows that row's 48-character random sync ID. Your **sync ID is the real secret**: don't post it anywhere.

> ⚠️ Never put the **secret** key (`sb_secret_…`) or the old **service_role** key in the app or in GitHub. Those bypass all security.

---

## Step 1 – Create a Supabase account

1. Go to <https://supabase.com> and click **Start your project**.
2. Sign up. **Continue with GitHub** is easiest, since you already have GitHub.

## Step 2 – Create a project

1. Click **New project**.
2. Fill in:
   - **Name:** `lc-study-plan` (anything is fine)
   - **Database password:** click **Generate**, then save it in a password manager. The app never needs it, but Supabase may ask for it later.
   - **Region:** **West EU (Ireland)** – closest to Cork.
   - **Plan:** Free.
3. Click **Create new project** and wait 1–2 minutes while it sets up.

## Step 3 – Run the setup SQL

1. In the left sidebar click **SQL Editor**.
2. Click **+ New query** (sometimes labelled *New SQL snippet*).
3. Open `supabase.sql` from this repository, copy **everything**, and paste it into the editor.
4. Click **Run** (or press Ctrl/Cmd + Enter).
5. You should see **"Success. No rows returned"**. Running it again later is safe.

What it did: created the `study_sync` table, switched on row-level security with a policy that blocks all direct access, and created the `sync_pull` / `sync_push` functions the app uses.

## Step 4 – Copy your Project URL and publishable key

1. Click **Connect** at the top of the project dashboard, or go to **Project Settings** (gear icon) → **API Keys**. The Project URL is also under **Project Settings → Data API**.
2. Copy:
   - **Project URL**, which looks like `https://abcdefghijklmnop.supabase.co`
   - **Publishable key**, which starts with `sb_publishable_…`. If your project only shows **Legacy API keys**, copy the **`anon` `public`** key instead (a long string starting `eyJ…`).

## Step 5 – Connect the app

There are two ways to do this. Pick one.

**Option A – in the app (quickest)**

1. Open your site (e.g. `https://conalmac08.github.io/Study-Plan/`).
2. Tap the **gear icon** → **Sync between devices**.
3. Paste the **Project URL** and the **key**, then tap **Save & connect**.
4. The dot in the top bar turns **green** and the card says "Synced …".

With this option you paste the URL and key once on each device.

**Option B – in the file, once for every device**

1. Open `index.html` and find `const CONFIG = {` near the top.
2. Fill in:
   ```js
   SUPABASE_URL: "https://abcdefghijklmnop.supabase.co",
   SUPABASE_KEY: "sb_publishable_xxxxxxxxxxxxxxxx",
   ```
3. Commit and push. GitHub Pages redeploys in about a minute, and every device then connects automatically.

## Step 6 – Add your other devices

1. On the **first** device: gear icon → **Sync between devices** → **Copy** your sync ID.
2. Send it to yourself privately (e.g. a note or a message to yourself, not a group chat).
3. On the **second** device: open the site → gear icon → (paste the URL and key if you used Option A) → paste the ID into **Use a sync ID from another device** → **Use this ID**.
4. Both devices now share progress. Anything you did on the second device before this is merged in, and the newest change to each item wins.

## Step 7 – Check it worked

In Supabase, go to **Table Editor** → `study_sync`. You should see one row whose `sync_id` matches your ID, and `updated_at` changes when you use the app. The dashboard can see it because it uses admin access; the public key can't.

---

## How syncing behaves

- Every change is saved to the device straight away, then sent to Supabase about 2.5 seconds later.
- When you open the app, come back to the tab, or get back online, it pulls the latest copy and merges it in.
- **Offline?** Everything still works. The dot shows offline, and changes sync when you're back online.
- **Conflicts:** each topic, milestone, date and timer session is merged separately, and the newest edit wins.
- **Backups:** gear icon → **Export JSON** about once a week, and keep the file somewhere private (it contains your sync ID).

## Troubleshooting

| What you see | Fix |
|---|---|
| Grey dot, "Not connected" | The URL/key aren't set. Do Step 5. |
| Red dot: *Could not find the function public.sync_pull…* | The SQL didn't run or hasn't loaded yet. Re-run `supabase.sql` (Step 3) and wait a minute. |
| Red dot: *Invalid API key* or 401 | Wrong key copied. Use the **publishable** (or legacy **anon**) key, not the secret one, and copy all of it. |
| Red dot: *permission denied for function* | Re-run `supabase.sql` – the last lines grant access to the functions. |
| Red dot: *Failed to fetch* / could not load supabase-js | No internet, or a network blocking `cdn.jsdelivr.net` (some school Wi-Fi does). It will sync later. |
| Sync stopped after a long break | Free projects pause when unused for a while (currently about a week). Open the Supabase dashboard and click **Restore project**. Normal daily use keeps it awake. |
| You think someone has your sync ID | Gear icon → **New ID (keep progress)**, then enter the new ID on your other devices. |

## Free plan limits

The free plan gives a 500 MB database. A full year of this app's data is well under 1 MB, so you'll never get close.
