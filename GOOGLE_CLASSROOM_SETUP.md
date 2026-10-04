# Connecting Google Classroom (optional)

The app can read your Classroom assignments and their due dates and turn the ones you pick into tasks. The planner then schedules time for them before they're due. It is **read-only**: it never hands anything in, posts, or changes anything in Classroom. It runs in your browser with your own Google sign-in, and nothing goes through any other server.

Setup takes about 10 minutes and is free. You'll create a Google "OAuth client ID", which is just a label that tells Google "this website may ask Con to sign in".

> **Important – your school may block this.** Schools that use Google Workspace for Education often block students (especially under-18s) from signing in to apps the school hasn't approved. If you see *"Access blocked"*, *"admin_policy_enforced"* or a **403** error, that's the school's setting, not a mistake on your part. See [If it's blocked](#if-its-blocked) below. The copy-and-paste route always works.

---

## Step 1 – Create a Google Cloud project

1. Go to <https://console.cloud.google.com>. Sign in with a **personal** Google account if you have one (school accounts often can't create projects).
2. Accept the terms if asked.
3. Click the project picker at the top → **New project** → name it `lc-study-plan` → **Create**. Make sure it's selected afterwards.

## Step 2 – Turn on the Classroom API

1. Open <https://console.cloud.google.com/apis/library/classroom.googleapis.com>, or search **Google Classroom API** in the top search bar.
2. Click **Enable**.

## Step 3 – Set up the sign-in screen

Google calls this the **OAuth consent screen**. In newer consoles it's under **Google Auth Platform**.

1. Left menu → **APIs & Services → OAuth consent screen**, or search *Google Auth Platform*. Click **Get started**.
2. Fill in:
   - **App name:** `LC Study Plan`
   - **User support email:** your email
   - **Audience:** **External**
   - **Contact email:** your email
3. Agree to the policy → **Create**.
4. Go to **Audience** → **Test users** → **Add users**. Add the Google account you use for Classroom (your **school** email), then save.

The app stays in **Testing** mode. That's fine: only the test users you add can sign in, and you don't need Google to review it.

## Step 4 – Create the client ID

1. Go to **Clients** (or **APIs & Services → Credentials**) → **Create client** / **Create credentials → OAuth client ID**.
2. **Application type:** **Web application**. **Name:** `LC Study Plan web`.
3. Under **Authorised JavaScript origins**, click **Add URI** and enter exactly:
   ```
   https://conalmac08.github.io
   ```
   - Don't add a slash at the end or the `/Study-Plan` part.
   - Optionally add `http://localhost:8000` too, for testing on your laptop.
4. Leave **Authorised redirect URIs** empty → **Create**.
5. Copy the **Client ID**. It ends in `.apps.googleusercontent.com`. You don't need the client secret, so don't put it anywhere.

## Step 5 – Put it in the app

There are two ways. Pick one.

- **On each device:** open the site → ⚙ **Settings** → **Google Classroom** → paste the client ID → **Save** → **Import now**.
- **Once for every device:** in `index.html`, find `GOOGLE_CLIENT_ID: ""` near the top, paste the ID between the quotes, then commit and push. The client ID isn't a secret, so it's fine in a public repo.

## Step 6 – See your Classroom posts on Today

1. Open **Today**. You'll find a **Google Classroom** card.
2. Tap **Load posts** and pick your school account. You'll probably see **"Google hasn't verified this app"**: that's expected for your own Testing-mode app, so tap **Continue**. Then allow the read-only permissions.
3. The card shows the newest posts from all your classes: assignments, announcements and materials.
   - New posts since you last looked get a **New** tag.
   - Tap **Show post** to read a post, or **Open** to go to it in Classroom.
   - **+ Plan** adds an assignment to your study plan. You say how many hours it needs.
4. **See all** lists everything. **Refresh** checks for new posts.

The card refreshes by itself every 30 minutes while you're signed in. After you close the tab, tap **Refresh** to sign in again (one tap).

## Step 7 – Bulk import (optional)

1. Tap **Import now** in Settings, or **Import from Classroom** on the **Dates** tab or in the **Coach**.
2. A Google window pops up. Pick your school account.
3. You'll probably see **"Google hasn't verified this app"**. That's expected for your own Testing-mode app: tap **Continue**.
4. Tick the permissions (read your classes, coursework, announcements and materials) → **Continue**.
5. You get a list of assignments with due dates. Work you've already handed in is unticked.
6. For each one, check the subject and set **how many hours of work** it needs. Use 0 for a reminder only.
7. Tap **Add selected**.

Run it again whenever you like: things you've already added are marked *already added*. **Send recent announcements to the AI coach** passes the last two weeks of class announcements to the coach, which picks out tests and deadlines that aren't formal assignments.

Google doesn't keep you signed in to the app. Each import asks you to confirm your account, usually with one tap.

---

## If it's blocked

The fallback works with no setup at all:

1. Open the assignment or announcement in the Classroom app.
2. Long-press → **Copy**, or select the text and copy it.
3. In the study plan, open **Coach** → paste it in → **Send**.
4. The coach pulls out the deadlines, tests and events and adds them to your plan. It also tells you what it assumed, e.g. which year a date is in.

You can also ask the school's IT/Google admin to allow the app. In the Google Admin console that's **Security → Access and data control → API controls → App access control → Configure new app → OAuth app name or client ID** → paste your client ID → **Trusted**. Many schools won't do this for one student, and that's fine: the paste route does the same job.

## Privacy

- The app asks only for **read-only** access: your class list, *your own* coursework and submissions, announcements and class materials.
- Assignment titles you choose to add become tasks in your plan. They sync to your own Supabase row if you set up sync, the same as the rest of your progress.
- Nothing from Classroom is stored anywhere else. Google sign-in tokens are kept in memory only and vanish when you close the tab.
- To revoke access at any time, go to <https://myaccount.google.com/permissions> → **LC Study Plan** → **Remove access**.
