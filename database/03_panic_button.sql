-- =====================================================================
-- Anchor | Role 3: Panic Button & Redis Caching
-- File 03: motivational messages, personal reminders, panic events, RLS
--
-- Run in the Supabase SQL Editor AFTER the auth file (01, public.profiles)
-- and the Streak Engine file (02, public.recovery_goals).
-- Then run 03_panic_button_seed.sql for the starter messages.
--
-- Follows the team convention in 01_auth_profiles_rls.sql: user_id defaults
-- to auth.uid() and references public.profiles(id).
--
-- Safe to re-run. It also upgrades the earlier version of these tables
-- (user_id pointing at auth.users, goal_id added by a separate file).
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. MOTIVATIONAL MESSAGES (global content, same for every user)
-- Managed by the team via migrations/seed, not by end users.
-- ---------------------------------------------------------------------
create table if not exists public.motivational_messages (
  id          uuid primary key default gen_random_uuid(),
  category    text not null check (category in ('motivation', 'grounding', 'crisis')),
  body        text not null check (char_length(body) between 1 and 500),
  is_active   boolean not null default true,
  created_at  timestamptz not null default now()
);

create index if not exists motivational_messages_active_idx
  on public.motivational_messages (category) where is_active;

-- Lets the seed file be re-run safely (ON CONFLICT DO NOTHING).
create unique index if not exists motivational_messages_body_key
  on public.motivational_messages (body);

-- ---------------------------------------------------------------------
-- 2. PERSONAL REMINDERS (a user's own "reasons I'm doing this")
-- ---------------------------------------------------------------------
create table if not exists public.personal_reminders (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid()
              references public.profiles (id) on delete cascade,
  body        text not null check (char_length(body) between 1 and 500),
  created_at  timestamptz not null default now()
);

create index if not exists personal_reminders_user_idx
  on public.personal_reminders (user_id);

-- ---------------------------------------------------------------------
-- 3. PANIC EVENTS (one row per panic-button press)
-- The primary key includes occurred_at so the Time-Series Analytics sprint
-- can partition this table by month without changing the key.
-- goal_id is optional: a user can press the button without choosing a goal.
-- ---------------------------------------------------------------------
create table if not exists public.panic_events (
  id           uuid not null default gen_random_uuid(),
  user_id      uuid not null default auth.uid()
               references public.profiles (id) on delete cascade,
  goal_id      uuid references public.recovery_goals (goal_id) on delete set null,
  occurred_at  timestamptz not null default now(),
  urge_level   smallint check (urge_level between 0 and 10), -- same 0-10 scale as daily_checkins
  trigger_note text check (char_length(trigger_note) <= 1000),
  message_id   uuid references public.motivational_messages (id) on delete set null,
  outcome      text check (outcome in ('resolved', 'still_struggling', 'contacted_support')),
  primary key (id, occurred_at)
);

-- ---------------------------------------------------------------------
-- 4. UPGRADE tables created by the earlier version of this file.
-- Does nothing harmful on a fresh database.
--
-- If a foreign key below fails, some existing users have no row in
-- public.profiles (they signed up before 01's trigger existed). Role 1
-- backfills them first, for example:
--   insert into public.profiles (id) select id from auth.users
--   on conflict (id) do nothing;
-- ---------------------------------------------------------------------
alter table public.personal_reminders
  alter column user_id set default auth.uid();
alter table public.personal_reminders
  drop constraint if exists personal_reminders_user_id_fkey;
alter table public.personal_reminders
  add constraint personal_reminders_user_id_fkey
  foreign key (user_id) references public.profiles (id) on delete cascade;

alter table public.panic_events
  alter column user_id set default auth.uid();
alter table public.panic_events
  drop constraint if exists panic_events_user_id_fkey;
alter table public.panic_events
  add constraint panic_events_user_id_fkey
  foreign key (user_id) references public.profiles (id) on delete cascade;

alter table public.panic_events
  add column if not exists goal_id uuid
  references public.recovery_goals (goal_id) on delete set null;

create index if not exists panic_events_user_time_idx
  on public.panic_events (user_id, occurred_at desc);

create index if not exists panic_events_goal_idx
  on public.panic_events (goal_id, occurred_at desc)
  where goal_id is not null;

-- ---------------------------------------------------------------------
-- 5. ROW-LEVEL SECURITY
-- ---------------------------------------------------------------------

-- Global messages: any signed-in user (including guest/anonymous sessions)
-- can read active messages. No write policies = only the service role /
-- migrations can change them.
alter table public.motivational_messages enable row level security;

drop policy if exists "read active messages" on public.motivational_messages;
create policy "read active messages"
  on public.motivational_messages
  for select to authenticated
  using (is_active);

-- Personal reminders: full control, own rows only.
alter table public.personal_reminders enable row level security;

drop policy if exists "manage own reminders" on public.personal_reminders;
create policy "manage own reminders"
  on public.personal_reminders
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

-- Panic events: a user can only see and write their own events, and can only
-- link an event to one of THEIR OWN recovery goals. The subquery on
-- recovery_goals is itself filtered by that table's RLS (file 02).
alter table public.panic_events enable row level security;

drop policy if exists "read own panic events" on public.panic_events;
create policy "read own panic events"
  on public.panic_events
  for select to authenticated
  using (user_id = (select auth.uid()));

drop policy if exists "log own panic events" on public.panic_events;
create policy "log own panic events"
  on public.panic_events
  for insert to authenticated
  with check (
    user_id = (select auth.uid())
    and (
      goal_id is null
      or exists (
        select 1
        from public.recovery_goals g
        where g.goal_id = panic_events.goal_id
          and g.user_id = (select auth.uid())
      )
    )
  );

drop policy if exists "update own panic events" on public.panic_events;
create policy "update own panic events"
  on public.panic_events
  for update to authenticated
  using (user_id = (select auth.uid()))
  with check (
    user_id = (select auth.uid())
    and (
      goal_id is null
      or exists (
        select 1
        from public.recovery_goals g
        where g.goal_id = panic_events.goal_id
          and g.user_id = (select auth.uid())
      )
    )
  );

-- Privacy-first: users can delete their own recovery data.
drop policy if exists "delete own panic events" on public.panic_events;
create policy "delete own panic events"
  on public.panic_events
  for delete to authenticated
  using (user_id = (select auth.uid()));
