-- =====================================================================
-- LC 2027 Study Plan – Supabase setup
-- Run this ONCE: Supabase dashboard → SQL Editor → New query → paste
-- everything in this file → Run. Running it again is safe.
--
-- What it creates
--   1. Table public.study_sync – one row per sync ID, holding all your
--      progress as JSON (topics, ratings, coursework, dates, timer logs).
--   2. Row-level security (RLS) switched ON, plus a policy that blocks
--      ALL direct table access through the public API. Nobody using the
--      public (publishable/anon) key can read, list or change the table.
--   3. Two functions the app calls instead:
--        sync_pull(sync id)        → returns only the row for that ID
--        sync_push(sync id, data)  → saves only the row for that ID
--      Both refuse IDs shorter than 32 characters. The app's sync ID is
--      48 random hex characters, so guessing someone's ID is not feasible.
-- =====================================================================

-- 1. Table ---------------------------------------------------------------
create table if not exists public.study_sync (
  sync_id    text primary key check (char_length(sync_id) between 32 and 128),
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

comment on table public.study_sync is 'LC 2027 study plan progress, one row per sync ID. Only reachable through sync_pull / sync_push.';

-- 2. Row-level security --------------------------------------------------
alter table public.study_sync enable row level security;

-- Deny every direct read/write from the API roles. "restrictive" means
-- no other policy added later can accidentally open the table up.
drop policy if exists "no direct access" on public.study_sync;
create policy "no direct access" on public.study_sync
  as restrictive
  for all
  to anon, authenticated
  using (false)
  with check (false);

-- Defence in depth: remove the default table grants from the API roles.
revoke all on table public.study_sync from anon, authenticated;

-- 3. Functions the app uses ----------------------------------------------
-- security definer = runs with the table owner's rights, so it can reach
-- the table even though the public roles cannot. Each function only ever
-- touches the single row whose sync_id it is given.

create or replace function public.sync_pull(p_sync_id text)
returns table (data jsonb, updated_at timestamptz)
language sql
stable
security definer
set search_path = public
as $$
  select s.data, s.updated_at
  from public.study_sync as s
  where s.sync_id = p_sync_id
    and char_length(p_sync_id) >= 32;
$$;

create or replace function public.sync_push(p_sync_id text, p_data jsonb)
returns timestamptz
language plpgsql
security definer
set search_path = public
as $$
declare
  ts timestamptz := now();
begin
  if p_sync_id is null or char_length(p_sync_id) < 32 or char_length(p_sync_id) > 128 then
    raise exception 'invalid sync id';
  end if;
  if p_data is null or jsonb_typeof(p_data) <> 'object' then
    raise exception 'invalid data';
  end if;
  if pg_column_size(p_data) > 2000000 then        -- about 2 MB; normal use is well under 200 KB
    raise exception 'data too large';
  end if;

  insert into public.study_sync as s (sync_id, data, updated_at)
  values (p_sync_id, p_data, ts)
  on conflict (sync_id) do update
    set data = excluded.data,
        updated_at = ts;

  return ts;
end;
$$;

-- Only the API roles may call the functions (nobody else needs to).
revoke all on function public.sync_pull(text) from public;
revoke all on function public.sync_push(text, jsonb) from public;
grant execute on function public.sync_pull(text) to anon, authenticated;
grant execute on function public.sync_push(text, jsonb) to anon, authenticated;

-- 4. Google Classroom feed (optional) --------------------------------------
-- Written by the Apps Script in classroom-sync.gs (runs in your own Google
-- account), read by the app. Same rules: one row per sync ID, functions only.
create table if not exists public.classroom_feed (
  sync_id    text primary key check (char_length(sync_id) between 32 and 128),
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.classroom_feed enable row level security;
drop policy if exists "no direct access" on public.classroom_feed;
create policy "no direct access" on public.classroom_feed
  as restrictive for all to anon, authenticated using (false) with check (false);
revoke all on table public.classroom_feed from anon, authenticated;

create or replace function public.feed_pull(p_sync_id text)
returns table (data jsonb, updated_at timestamptz)
language sql
security definer
set search_path = public
as $$
  select f.data, f.updated_at from public.classroom_feed f where f.sync_id = p_sync_id;
$$;

create or replace function public.feed_push(p_sync_id text, p_data jsonb)
returns timestamptz
language plpgsql
security definer
set search_path = public
as $$
declare
  ts timestamptz := now();
begin
  if p_sync_id is null or char_length(p_sync_id) < 32 or char_length(p_sync_id) > 128 then
    raise exception 'invalid sync id';
  end if;
  if p_data is null or jsonb_typeof(p_data) <> 'object' then
    raise exception 'invalid data';
  end if;
  if pg_column_size(p_data) > 1000000 then
    raise exception 'data too large';
  end if;
  insert into public.classroom_feed as f (sync_id, data, updated_at)
  values (p_sync_id, p_data, ts)
  on conflict (sync_id) do update set data = excluded.data, updated_at = ts;
  return ts;
end;
$$;

revoke all on function public.feed_pull(text) from public;
revoke all on function public.feed_push(text, jsonb) from public;
grant execute on function public.feed_pull(text) to anon, authenticated;
grant execute on function public.feed_push(text, jsonb) to anon, authenticated;

-- Tell the API layer to pick up the new functions straight away.
notify pgrst, 'reload schema';

-- =====================================================================
-- Optional checks (run separately if you want to see it working):
--   select public.sync_push('0123456789abcdef0123456789abcdef', '{"hello":"world"}');
--   select * from public.sync_pull('0123456789abcdef0123456789abcdef');
--   delete from public.study_sync where sync_id = '0123456789abcdef0123456789abcdef';
-- =====================================================================
