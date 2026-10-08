-- Row-Level Security for the Panic Button tables.
-- Coordinate with the Auth/Security owner: this file should follow the same
-- policy pattern they use for other user-owned tables.

-- Global messages: any signed-in user (including guest/anonymous sessions) can
-- read active messages. No write policies = only the service role / migrations
-- can change them.
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

-- Panic events: a user can only see and write their own events.
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
  with check (user_id = (select auth.uid()));

drop policy if exists "update own panic events" on public.panic_events;
create policy "update own panic events"
  on public.panic_events
  for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

-- Privacy-first: users can delete their own recovery data.
drop policy if exists "delete own panic events" on public.panic_events;
create policy "delete own panic events"
  on public.panic_events
  for delete to authenticated
  using (user_id = (select auth.uid()));
