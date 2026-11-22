-- =====================================================================
-- Anchor | Role 1: Authentication, Privacy & Security
-- File 01: profiles, pseudonyms, signup trigger, RLS
-- Run in Supabase SQL Editor. Supabase Auth owns auth.users (email,
-- password hash, sessions); we never store credentials ourselves.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. PROFILES  (private, 1:1 with auth.users)
-- Every other team table should reference profiles(id) as user_id.
-- Deliberately stores NO email / real name.
-- ---------------------------------------------------------------------
create table public.profiles (
    id                  uuid primary key references auth.users(id) on delete cascade,
    timezone            text        not null default 'UTC',
    settings            jsonb       not null default '{}'::jsonb,
    onboarding_complete boolean     not null default false,
    created_at          timestamptz not null default now(),
    updated_at          timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- 2. PSEUDONYMS  (the public identity used in the anonymous feed)
-- user_id is the ONLY link between a person and their handle, and it is
-- hidden from everyone but the owner by RLS. The feed (Role 5) should
-- reference pseudonyms(id), never profiles(id).
-- ---------------------------------------------------------------------
create table public.pseudonyms (
    id         uuid primary key default gen_random_uuid(),
    user_id    uuid not null unique references public.profiles(id) on delete cascade,
    handle     text not null,
    created_at timestamptz not null default now(),
    constraint handle_format check (handle ~ '^[A-Za-z0-9_]{3,24}$')
);
create unique index pseudonyms_handle_unique on public.pseudonyms (lower(handle));

-- ---------------------------------------------------------------------
-- 3. SIGNUP TRIGGER: auto-create profile + random pseudonym
-- SECURITY DEFINER so it can write despite RLS; search_path locked down.
-- ---------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
    insert into public.profiles (id) values (new.id);
    insert into public.pseudonyms (user_id, handle)
    values (new.id, 'Anchor_' || substr(md5(random()::text || new.id::text), 1, 8));
    return new;
end;
$$;

create trigger on_auth_user_created
    after insert on auth.users
    for each row execute function public.handle_new_user();

-- keep updated_at fresh
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end;
$$;

create trigger profiles_touch
    before update on public.profiles
    for each row execute function public.touch_updated_at();

-- ---------------------------------------------------------------------
-- 4. ROW-LEVEL SECURITY
-- (select auth.uid()) is wrapped in a subselect so Postgres evaluates it
-- once per query instead of once per row (Supabase-recommended).
-- ---------------------------------------------------------------------
alter table public.profiles   enable row level security;
alter table public.pseudonyms enable row level security;

-- profiles: owner can read and update their own row. No client insert
-- (trigger does it) and no client delete (account deletion is separate).
create policy profiles_select_own on public.profiles
    for select to authenticated
    using (id = (select auth.uid()));

create policy profiles_update_own on public.profiles
    for update to authenticated
    using (id = (select auth.uid()))
    with check (id = (select auth.uid()));

-- pseudonyms: owner can read and rename their own handle only.
create policy pseudonyms_select_own on public.pseudonyms
    for select to authenticated
    using (user_id = (select auth.uid()));

create policy pseudonyms_update_own on public.pseudonyms
    for update to authenticated
    using (user_id = (select auth.uid()))
    with check (user_id = (select auth.uid()));

-- Stop clients from changing user_id / id via UPDATE
revoke update on public.pseudonyms from authenticated;
grant  update (handle) on public.pseudonyms to authenticated;

-- ---------------------------------------------------------------------
-- 5. PUBLIC DIRECTORY VIEW (what the feed is allowed to see)
-- Exposes id + handle only. user_id is NOT in the view, so feed queries
-- can show "who posted" without any path back to the person.
-- The view runs with its owner's rights on purpose (so it can read all
-- rows); it is safe because it exposes only these two columns.
-- ---------------------------------------------------------------------
create view public.pseudonym_directory as
    select id, handle from public.pseudonyms;

revoke all on public.pseudonym_directory from anon;
grant select on public.pseudonym_directory to authenticated;

-- =====================================================================
-- 6. TEAM CONVENTION (share this with everyone)
-- Every private table must:
--   user_id uuid not null default auth.uid() references public.profiles(id) on delete cascade
--   alter table <t> enable row level security;
--   create policy <t>_own on <t> for all to authenticated
--       using (user_id = (select auth.uid()))
--       with check (user_id = (select auth.uid()));
--   create index on <t> (user_id);
-- =====================================================================

-- =====================================================================
-- 7. QUICK RLS TEST (run after creating two test users in Auth)
-- Replace the UUIDs with real ids from auth.users.
-- =====================================================================
-- begin;
--   set local role authenticated;
--   select set_config('request.jwt.claims',
--          '{"sub":"<USER_A_UUID>","role":"authenticated"}', true);
--   select * from public.profiles;       -- expect exactly 1 row (User A)
--   select * from public.pseudonyms;     -- expect exactly 1 row (User A)
--   select * from public.pseudonym_directory;  -- expect ALL handles, no user_id
--   update public.profiles set timezone = 'UTC'
--       where id = '<USER_B_UUID>';      -- expect UPDATE 0 (blocked)
-- rollback;
