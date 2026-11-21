
-- ANCHOR | Role 2: Streak Engine
-- Current and longest streak statistics.
-- Uses each goal's configured time zone.
-- One missing day is allowed per streak.
-- Grace days do NOT increase streak length.
-- A relapse resets the current streak.
-- Security invoker respects underlying RLS policies.

CREATE OR REPLACE VIEW public.streak_stats
WITH (security_invoker = true)
AS
WITH goal_dates AS (
    SELECT
        goal_id,
        goal_name,
        (CURRENT_TIMESTAMP AT TIME ZONE time_zone)::date
            AS local_today
    FROM public.recovery_goals
)
SELECT
    g.goal_id,
    g.goal_name,
    g.local_today,

    CASE
        -- A relapse resets the current streak.
        WHEN last_checkin.status = 'relapse'
        THEN 0::bigint

        -- Successful check-in today:
        -- the streak is active.
        WHEN latest.streak_end = g.local_today
        THEN latest.streak_length

        -- Last success was yesterday.
        -- Today can be a grace day ONLY if
        -- no earlier grace day was used
        -- in this same streak.
        WHEN latest.streak_end = g.local_today - 1
             AND (
                 latest.streak_end
                 - latest.streak_start + 1
             ) = latest.streak_length
        THEN latest.streak_length

        -- More than one missing day,
        -- or the grace allowance was used.
        ELSE 0::bigint
    END AS current_streak,

    COALESCE(
        history.longest_streak,
        0::bigint
    ) AS longest_streak

FROM goal_dates g

LEFT JOIN LATERAL (
    SELECT
        s.streak_start,
        s.streak_end,
        s.streak_length
    FROM public.streak_periods_grace s
    WHERE s.goal_id = g.goal_id
      AND s.streak_end <= g.local_today
    ORDER BY s.streak_end DESC
    LIMIT 1
) latest ON TRUE

LEFT JOIN LATERAL (
    SELECT dc.status
    FROM public.daily_checkins dc
    WHERE dc.goal_id = g.goal_id
      AND dc.checkin_date <= g.local_today
    ORDER BY dc.checkin_date DESC
    LIMIT 1
) last_checkin ON TRUE

LEFT JOIN LATERAL (
    SELECT
        MAX(s.streak_length) AS longest_streak
    FROM public.streak_periods_grace s
    WHERE s.goal_id = g.goal_id
) history ON TRUE;
