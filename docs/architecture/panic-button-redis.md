# Panic Button & Redis Caching: Design Note

Sprint 1 (Weeks 3-6). Owner: Panic Button / Redis. Database files live in
`database/schema/panic_button.sql`, `database/rls/panic_button_rls.sql` and
`database/seed/motivational_messages.sql`.

## Goal

When a user presses the panic button, show a supportive message immediately and
record the event. The screen must still work if Redis or the database is slow
or down.

## Request flow

`POST /panic` (signed-in user, guest sessions allowed)

1. Read cached content from Redis (messages, the user's reminders, streak count).
2. On a cache miss, load from Postgres, then write it back to Redis with a TTL.
3. Pick one message per category (motivation, grounding) plus the crisis resources.
4. Respond right away with the content.
5. Log the event to `panic_events` after the response is prepared (a failure to
   log must never block or break the response).
6. Optional follow-up: `PATCH /panic/:id` to record `urge_level`, `trigger_note`
   and `outcome` once the user has a moment.

## Redis keys

| Key | Value | TTL | Invalidated when |
|---|---|---|---|
| `anchor:panic:messages:v1` | JSON array of active messages | 1 hour | message content changes (bump `v1`) |
| `anchor:user:{userId}:reminders` | JSON array of the user's reminders | 1 hour | user adds, edits or deletes a reminder |
| `anchor:user:{userId}:streak` | JSON `{ currentStreak, lastCheckIn }` | 10 min | user checks in or logs a relapse |

- The streak key is **written by the Streak Engine owner**. The panic endpoint
  only reads it. Agree on the exact JSON shape with them before Sprint 1 ends.
- Keys containing a `userId` hold private recovery data: short TTLs, and never
  log their values.

## Fallback behavior

| Failure | Behavior |
|---|---|
| Redis unreachable or errors | Read from Postgres directly |
| Postgres also fails | Return a small built-in set of messages hard-coded in the app, including the 988 and SAMHSA lines |
| Event logging fails | Return the content anyway and retry the insert once in the background |

The panic screen is the one place where "show something helpful" beats
"show an error".

## Latency expectations

A cache hit avoids a database round trip, which is the real win. Upstash is
accessed over HTTPS (REST), so the end-to-end time includes network latency to
the Upstash region; the proposal's "sub-10ms" target is realistic for the Redis
operation itself, not necessarily for the full request. Measure both and report
both in the final write-up. Pick the Upstash region closest to where the app is
deployed.

## Test cases (Vitest)

- Cache hit returns content without calling the database.
- Cache miss loads from the database and populates Redis.
- Redis error falls back to the database; both failing returns built-in messages.
- A failed event insert does not change the response.
- Reminders cache is cleared after a reminder is added or deleted.
- RLS: a user cannot read or modify another user's `panic_events` or `personal_reminders`.

## Open questions for the team

- Stack and folder layout for `backend/` (this note is stack-neutral).
- Who owns the shared Redis client and env vars (`UPSTASH_REDIS_REST_URL`, `UPSTASH_REDIS_REST_TOKEN`)?
- Shape of the streak cache entry (Streak Engine owner).
- Whether `panic_events` gets partitioned in Sprint 2 (the primary key already allows it).
