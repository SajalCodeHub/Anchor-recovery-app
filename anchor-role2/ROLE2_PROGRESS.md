# ANCHOR — Role 2: Development Progress and Design Decisions

**Module:** Streak Engine & Core Daily Logs  
**Course:** SE641 / CSCI695 — Fall 2026  
**Database:** PostgreSQL 17  
**Development Environment:** pgAdmin 4, VS Code  
**Local Database:** `anchor_streak_dev`  
**Status:** Initial database implementation completed; integration and further validation pending.

## 1. My Responsibilities

I am responsible for Role 2, which focuses on tracking recovery goals, daily check-ins, and user streaks.

The main responsibilities are:

- Designing the recovery goals and daily check-in tables.
- Recording daily success and relapse statuses.
- Calculating current and longest streaks.
- Handling missed check-in days and streak resets.
- Supporting time-zone-aware date calculations.
- Preparing database components for integration with the other team members' modules.

## 2. Work Completed

### Recovery Goals Table

Created `public.recovery_goals` with the following fields:

- `goal_id` — unique UUID for each recovery goal.
- `user_id` — references the user account.
- `goal_name` — recovery goal name.
- `start_date` — starting date of the goal.
- `time_zone` — time zone used for date calculations.
- `is_active` — indicates whether the goal is active.
- `created_at` — timestamp of creation.

Implemented a primary key, foreign key to `auth.users(id)`, a validation rule preventing blank goal names, and an index on `user_id`.

### Daily Check-ins Table

Created `public.daily_checkins` with:

- `goal_id`
- `checkin_date`
- `status`
- `urge_level`
- `created_at`
- `updated_at`

Implemented a composite primary key on `(goal_id, checkin_date)`, preventing more than one record for the same goal and date.

The `status` field allows `success` or `relapse`, while `urge_level` accepts values from 0 to 10 or NULL.

### Streak Calculations

Implemented three SQL components:

**`streak_periods_grace.sql`**

A recursive SQL view that identifies historical streak periods, separates streaks after relapse, and allows one missing check-in day within a streak.

**`streak_stats.sql`**

A SQL view that provides each goal's current streak, longest streak, and local date based on the configured time zone.

**`streak_summary.sql`**

A materialized view that stores longest-streak summaries using the historical streak calculation.

The materialized view needs to be refreshed when its underlying data changes.

## 3. Design Decisions — Pending Team Approval

The following rules were selected during the initial implementation. They are **proposed implementation decisions**, not yet confirmed as final team requirements.

### Decision 1: One Grace Day per Streak

The current design allows one missing check-in day during a streak.

- A missing day may be used as the one-day grace allowance.
- The missing day does not increase the streak length.
- A second missing day within the same streak breaks the streak.
- A recorded relapse breaks the streak.
- A new streak receives a new grace allowance.

**Reason:** This allows a user to miss one check-in without immediately losing all progress, while keeping the streak calculation consistent.

**Team discussion needed:** Confirm whether the project should allow one grace day, whether grace should reset for each streak, and whether this matches the intended recovery tracking experience.

### Decision 2: Time-Zone-Aware Daily Tracking

Each recovery goal stores its own time zone. The streak statistics view uses that value to determine the local current date.

**Reason:** Users in different locations may have different calendar dates at the same moment. A check-in should be evaluated according to the appropriate local date.

**Team discussion needed:** Confirm whether time zones should be stored per goal or per user, and decide which module will validate and maintain the configured time zone.

### Additional Behavior: Relapse and Historical Progress

The current calculation treats relapse as a streak-breaking event while retaining earlier streak periods for historical reporting.

**Team discussion needed:** Confirm how relapse should affect the user interface, progress history, and analytics.

## 4. Tests Completed

Testing was performed locally using PostgreSQL and pgAdmin.

### Database Validation

The database constraints were checked for invalid status and urge-level values. These tests produced the expected database validation errors.

### Historical Streak Test

Created sample check-ins for two recovery goals.

**Reduce Social Media**

| Date | Status |
|---|---|
| October 20, 2026 | success |
| October 21, 2026 | relapse |
| October 22, 2026 | success |
| October 23, 2026 | success |

**Stop Smoking**

| Date | Status |
|---|---|
| October 20, 2026 | success |
| October 21, 2026 | success |
| October 22, 2026 | relapse |
| October 23, 2026 | success |

The historical streak view separated these into four periods with lengths of 1, 2, 2, and 1 successful check-ins.

### Grace-Day Test

Tested successful check-ins on October 1, 2, 4, 5, and 7.

The test used two missing days to check the one-grace-day rule.

The calculation returned a first streak covering October 1–5 with four successful check-ins, followed by a separate streak on October 7 with one successful check-in.

### Current and Longest Streak Test

On October 24, 2026, the local database returned:

| Goal | Current Streak | Longest Streak |
|---|---:|---:|
| Reduce Social Media | 2 | 2 |
| Stop Smoking | 1 | 2 |

These results matched the expected values for the sample dataset.

The revised materialized summary also returned a longest streak of 2 for both goals.

**Testing limitation:** These tests cover selected sample scenarios. They do not establish that every edge case, time-zone transition, or streak-expiration scenario is correct.

## 5. SQL Files

The current Role 2 implementation includes:

1. `recovery_goals.sql`
2. `daily_checkins.sql`
3. `streak_periods_grace.sql`
4. `streak_stats.sql`
5. `streak_summary.sql`

The scripts depend on an existing `auth.users` table and should be applied in the listed order in a compatible database.

The SQL files have been prepared for team review. Some recent revisions in the repository have not yet been revalidated against the shared team environment.

## 6. Remaining Work

The following tasks are not yet complete:

- Obtain team agreement on grace-day and time-zone rules.
- Review remaining edge cases in the current streak calculation.
- Integrate with the team's authentication and Row-Level Security implementation.
- Confirm check-in creation and update behavior, including automatic maintenance of `updated_at`.
- Decide how materialized-view refreshes will be triggered.
- Implement or integrate backend APIs for goal management, daily check-ins, and streak retrieval.
- Validate integration with other team modules and the shared database.
- Coordinate merge into the main project branch after team review.

## 7. Notes for the Next Developer

Please review the proposed grace-day and time-zone policies with the team before treating them as final requirements.

The regular SQL views calculate streak results from the stored check-ins, while the materialized view stores a cached summary that must be refreshed after data changes.

The current database work was developed locally, and integration with the complete application is still pending.

Do not assume that the SQL files alone provide authentication, API endpoints, automatic refresh scheduling, or complete production-ready streak behavior.

## 8. Summary

The initial Role 2 database schema and streak calculation components have been implemented, documented, and tested using sample records.

The next priorities are agreeing on the proposed design decisions, reviewing remaining edge cases, integrating with the other modules, and completing team review before merging.
