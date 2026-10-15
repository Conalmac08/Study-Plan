-- Study Forest — Supabase setup
-- Uses the SAME Supabase project as the main LC 2027 Study Plan, but its
-- own table and functions, so the two apps can never overwrite each other.
--
-- Run ONCE: Supabase dashboard → SQL Editor → New query → paste this whole
-- file → Run. Running it again is safe. It does not touch study_sync,
-- sync_pull, sync_push or anything else the main app uses.

-- 1. One row per sync ID, holding all forest progress as JSON.
create table if not exists public.forest_sync (
  sync_id    text primary key check (char_length(sync_id) between 32 and 128),
  data       jsonb not null,
  updated_at timestamptz not null default now()
);

comment on table public.forest_sync is 'Study Forest progress, one row per sync ID. Only reachable through forest_get / forest_save.';

-- 2. Lock the table down: RLS on, a restrictive deny-all policy, and no
--    table grants for the public API roles.
alter table public.forest_sync enable row level security;

drop policy if exists "no direct access" on public.forest_sync;
create policy "no direct access" on public.forest_sync
  as restrictive
  for all
  to anon, authenticated
  using (false)
  with check (false);

revoke all on table public.forest_sync from anon, authenticated;

-- 3. The only way in: two functions that need the exact sync ID.
create or replace function public.forest_get(p_sync_id text)
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select data from public.forest_sync where sync_id = p_sync_id;
$$;

create or replace function public.forest_save(p_sync_id text, p_data jsonb)
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
    raise exception 'payload too large';
  end if;
  insert into public.forest_sync (sync_id, data, updated_at)
  values (p_sync_id, p_data, ts)
  on conflict (sync_id) do update
    set data = excluded.data, updated_at = ts;
  return ts;
end;
$$;

-- 4. Only the public key's roles may call these two functions.
revoke all on function public.forest_get(text) from public;
revoke all on function public.forest_save(text, jsonb) from public;
grant execute on function public.forest_get(text) to anon, authenticated;
grant execute on function public.forest_save(text, jsonb) to anon, authenticated;
