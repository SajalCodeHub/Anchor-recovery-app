-- ANCHOR | Role 2: Streak Engine
-- Materialized summary of historical streaks.
-- Uses the same one-grace-day rule as streak_periods_grace.
-- Refresh after daily check-in changes.

CREATE MATERIALIZED VIEW public.streak_summary AS
SELECT
    g.goal_id,
    g.goal_name,
    COALESCE(
        MAX(s.streak_length),
        0::bigint
    ) AS longest_streak
FROM public.recovery_goals g
LEFT JOIN public.streak_periods_grace s
    ON s.goal_id = g.goal_id
GROUP BY
    g.goal_id,
    g.goal_name
WITH DATA;