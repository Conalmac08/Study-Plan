# Classroom → your app, automatically (Apps Script)

Use this if the normal Google sign-in in `GOOGLE_CLASSROOM_SETUP.md` is **blocked by your school**.

A short script runs inside your own school Google account. Once an hour it reads your Classroom posts (read-only): assignments, announcements and materials. It sends them to your app through your Supabase sync. They then show up in the **Google Classroom** card on **Today**, with **New** tags, **Open** links and **+ Plan** buttons. You don't need to sign in to anything or copy posts.

Setup takes about 10 minutes, once.

## Before you start
- **Sync must be connected.** If the dot in the app's top bar isn't green, do `SUPABASE_SETUP.md` first.
- **Run `supabase.sql` again** in Supabase → SQL Editor → New query → paste everything → Run. It adds a small `classroom_feed` table and is safe to re-run. If you're setting up Supabase for the first time, this is already included.

## Steps
1. **Copy your script.** In the app, go to ⚙ **Settings** → **Google Classroom** → **Copy script**. Your project URL, key and sync ID are already filled in.
2. **Create the project.** Go to <https://script.google.com>, signed in with your **school** Google account (the one that has Classroom). Click **New project**, then click *Untitled project* at the top and name it `LC Study Plan sync`.
3. **Paste the script.** In `Code.gs`, select everything, delete it, and paste your script in. Press **Ctrl/Cmd + S** to save.
4. **Turn on Classroom access.** In the left sidebar, next to **Services**, click **+**. Choose **Google Classroom API** and click **Add**. Leave the identifier as `Classroom`.
5. **Run it once.** In the toolbar dropdown, pick the function **`setup`** and click **▶ Run**.
   - Click **Review permissions** and pick your school account.
   - If you see *"Google hasn't verified this app"*, click **Advanced** → **Go to LC Study Plan sync (unsafe)**. It's your own script, so this is expected.
   - Click **Allow**. The script can see your classes, coursework and announcements, and connect to an external service (your Supabase).
6. **Check it worked.** The **Execution log** at the bottom should say something like `Sent 37 Classroom posts from 7 classes.`
7. **See it in the app.** Open the app (or tap **Refresh** on the Classroom card). Your posts appear on **Today**. Settings → Google Classroom now shows **✓ Script working** with the last update time.

From now on it runs every hour on Google's servers, even when your phone and laptop are off.

## Good to know
- **Read-only.** The script never hands in, posts or changes anything in Classroom.
- **Keep the script private.** It contains your sync ID. Don't share the project.
- **Changed your sync ID?** If you used *New ID* in Settings, copy the script again, paste it over the old code, and run `setup` again.
- **Stop it.** In Apps Script, go to **Triggers** (clock icon) and delete the trigger, or delete the project. To remove the permission too, go to <https://myaccount.google.com/permissions>.

## If this is blocked too
Some schools also switch off Apps Script, or stop scripts contacting outside websites.
- If **▶ Run** gives an error mentioning your admin, or the log says it couldn't reach Supabase, your school blocks this as well.
- In that case the only automatic route left is your **personal** Google account. That only works if your school lets Classroom emails be **forwarded** to it, which is often blocked too. Tell me if you want to try that.
- Otherwise, pasting posts into the **Coach** still works.
