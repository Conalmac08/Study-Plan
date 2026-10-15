# Study Forest

7 Leaving Cert subject trees. Each branch is a topic and each twig is a subtopic. Leaves change colour to show when a topic is due for review.

Live at: https://conalmac08.github.io/Study-Plan/forest/

## One-time setup (about 2 minutes)

The app already points at the same Supabase project as the main study plan. It only needs its own table:

1. Open https://supabase.com/dashboard and go to your study plan project (`rxqcpfwydwzrqocwlxsr`).
2. Open **SQL Editor**, click **New query**, paste all of `schema.sql`, and click **Run**. You should see "Success. No rows returned."
3. Open the site. The pill at the top should say **Synced**.

This creates `forest_sync`, `forest_get` and `forest_save`. It doesn't touch `study_sync` or anything the main app uses.

## Linking your phone and PC

1. On your phone, go to **Settings** and tap **Copy ID**.
2. On your PC, go to **Settings**, paste the ID into **Use an ID from another device**, and click **Use this ID**.

Your forest sync ID is separate from the main study plan's sync ID. Keep it private, because anyone with it can change your progress.

## Leaf cycle

All timers count from when you first study a twig:

1. **Green:** you just studied it.
2. **Orange** at 24 hours. Reviewing adds a green outline.
3. **Red** at 2 weeks. The outline clears, and reviewing adds it back.
4. **Brown** at 4 weeks. Studying it now turns it **gold**.
5. Two months after going gold, it goes back to green and the cycle restarts.

Each gold you earn adds a tier badge (I, II, III, IV…). Higher tiers look fancier.

## Editing topics

Every topic lives in the `CURRICULUM` object near the top of `index.html`. Renaming a twig resets its progress, because progress is saved by name.

## Troubleshooting

- **"Sync error: Could not find the function public.forest_get…"**: `schema.sql` hasn't been run yet. Do step 2 above.
- **Sync stops after a long break**: free Supabase projects pause after about a week with no activity. Log in and click **Restore project**. Your data is kept.
