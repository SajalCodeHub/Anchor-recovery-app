# ANCHOR — Role 2: Streak Engine & Daily Logs

## Overview
This module manages recovery goals, daily check-ins, and streak calculations.

## Database
PostgreSQL 17

## Setup
Prerequisite: The database must contain the `auth.users` table.

Run the SQL files in this order:

1. recovery_goals.sql
2. daily_checkins.sql
3. streak_periods_grace.sql
4. streak_stats.sql
5. streak_summary.sql

## Streak Rules
- Successful check-ins increase the streak.
- One missing day is allowed per streak.
- A relapse breaks the streak.
- A second missing day breaks the streak.
- Grace days do not count as successful days.
- Historical streaks are preserved.

## Materialized View
After check-in data changes, refresh the summary:

REFRESH MATERIALIZED VIEW public.streak_summary;

## Status
Core database structures and SQL views are implemented.
Initial sample-data tests have been completed.

Backend APIs, authentication integration, and additional
edge-case validation remain to be completed.
