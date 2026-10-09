-- Panic Button schema (Sprint 1: Panic Button & Redis Caching)
-- Assumes Supabase Auth is set up (auth.users) from Sprint 0.
-- Run order: schema/panic_button.sql -> rls/panic_button_rls.sql -> seed/motivational_messages.sql

-- ---------------------------------------------------------------------------
-- Global content shown when the panic button is pressed (same for every user).
-- Managed by the team via migrations/seed, not by end users.
-- ---------------------------------------------------------------------------
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

-- ---------------------------------------------------------------------------
-- A user's own "reasons I'm doing this" reminders, shown during an urge.
-- ---------------------------------------------------------------------------
create table if not exists public.personal_reminders (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users (id) on delete cascade,
  body        text not null check (char_length(body) between 1 and 500),
  created_at  timestamptz not null default now()
);

create index if not exists personal_reminders_user_idx
  on public.personal_reminders (user_id);

-- ---------------------------------------------------------------------------
-- One row per panic-button press (an "urge-trigger" log entry).
-- Primary key includes occurred_at so the Time-Series Analytics sprint can
-- partition this table by month without changing the key.
-- ---------------------------------------------------------------------------
create table if not exists public.panic_events (
  id           uuid not null default gen_random_uuid(),
  user_id      uuid not null references auth.users (id) on delete cascade,
  occurred_at  timestamptz not null default now(),
  urge_level   smallint check (urge_level between 1 and 10),
  trigger_note text check (char_length(trigger_note) <= 1000),
  message_id   uuid references public.motivational_messages (id) on delete set null,
  outcome      text check (outcome in ('resolved', 'still_struggling', 'contacted_support')),
  primary key (id, occurred_at)
);

create index if not exists panic_events_user_time_idx
  on public.panic_events (user_id, occurred_at desc);
