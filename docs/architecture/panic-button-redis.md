# Panic Button & Redis Caching: Design Note

Sprint 1 (Weeks 3-6). Owner: Panic Button / Redis. Database files:
`database/03_panic_button.sql` (tables, goal link and RLS; run after the auth
file 01 and the Streak Engine file 02) and `database/03_panic_button_seed.sql`
(starter messages). User-owned tables follow the team convention: `user_id`
defaults to `auth.uid()` and references `public.profiles(id)`.

## Goal

When a user presses the panic button, show a supportive message immediately and
record the event. The screen must still work if Redis or the database is slow
or down.

## Request flow

`POST /panic` (signed-in user, guest sessions allowed)

1. Read cached content from Redis (messages, the user's reminders, and the
   current streak of each of the user's active recovery goals).
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
| `anchor:user:{userId}:goal:{goalId}:streak` | JSON `{ goalName, currentStreak, longestStreak, asOf }` | 10 min, or until the goal's local midnight if sooner | user checks in or logs a relapse for that goal |

- Streaks are per recovery goal, matching the Streak Engine's `recovery_goals`
  and `daily_checkins` tables. The JSON fields mirror the `streak_stats` view
  (`goal_name`, `current_streak`, `longest_streak`); `asOf` is its `local_today`.
- The streak key is **written by the Streak Engine owner**. The panic endpoint
  only reads it, and falls back to querying `streak_stats` on a miss.
- `current_streak` depends on "today" in the goal's own time zone (one grace
  day, relapse resets to 0), so a cached value can become wrong at local
  midnight. That is why the TTL ends at the goal's local midnight.
- Keys containing a `userId` hold private recovery data: short TTLs, and never
  log their values.

### Streak cache contract (writer: Streak Engine, reader: Panic Button)

Both modules must use exactly this shape, so neither side guesses:

```json
{
  "goalId": "11111111-0000-0000-0000-00000000000a",
  "goalName": "Quit smoking",
  "currentStreak": 12,
  "longestStreak": 30,
  "asOf": "2026-11-14"
}
```

- Field names are camelCase, exactly as above.
- `currentStreak` and `longestStreak` are whole days, as JSON numbers (not strings).
  They come from `streak_stats.current_streak` and `longest_streak`.
- `asOf` is a calendar date, ISO 8601 `YYYY-MM-DD`, in the goal's own time zone
  (`streak_stats.local_today`). It is a date only, with no time or offset.
- There is no `lastCheckIn` field: `streak_stats` does not expose it. If the panic
  screen needs it later, add it as an ISO `YYYY-MM-DD` date and update this contract.
- The Panic Button must ignore unknown extra fields, so the Streak Engine can add
  fields without breaking it.

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
- A streak cache entry expires at the goal's local midnight, not only after 10 minutes.
- A panic event can only be linked to a goal owned by the same user.
- RLS: a user cannot read or modify another user's `panic_events` or `personal_reminders`.

## Open questions for the team

- Stack and folder layout for `backend/` (this note is stack-neutral).
- Who owns the shared Redis client and env vars (`UPSTASH_REDIS_REST_URL`, `UPSTASH_REDIS_REST_TOKEN`)?
- Confirm the per-goal streak cache entry above with the Streak Engine owner
  (Sahar), including who writes it and when it is invalidated.
- Her grace-day and time-zone rules are still "pending team approval"; the TTL
  logic here follows whatever the team settles on.
- Whether `panic_events` gets partitioned in Sprint 2 (the primary key already allows it).
