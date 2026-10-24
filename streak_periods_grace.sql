-- ANCHOR | Role 2: Streak Engine
-- Historical streak periods with one grace day per streak.
-- A relapse always breaks the streak.
-- streak_length counts successful check-ins, not grace days.

CREATE OR REPLACE VIEW public.streak_periods_grace AS
WITH RECURSIVE ordered_checkins AS (
    SELECT
        dc.goal_id,
        dc.checkin_date,
        dc.status,
        ROW_NUMBER() OVER (
            PARTITION BY dc.goal_id
            ORDER BY dc.checkin_date
        ) AS rn
    FROM public.daily_checkins dc
),
streak_walk AS (
    SELECT
        oc.goal_id,
        oc.checkin_date,
        oc.status,
        oc.rn,
        1::bigint AS streak_group,
        0 AS grace_used
    FROM ordered_checkins oc
    WHERE oc.rn = 1

    UNION ALL

    SELECT
        n.goal_id,
        n.checkin_date,
        n.status,
        n.rn,
        CASE
            WHEN n.status = 'relapse'
              OR p.status = 'relapse'
              OR n.checkin_date - p.checkin_date > 2
              OR (
                  n.checkin_date - p.checkin_date = 2
                  AND p.grace_used = 1
              )
            THEN p.streak_group + 1
            ELSE p.streak_group
        END,
        CASE
            WHEN n.status = 'relapse'
              OR p.status = 'relapse'
              OR n.checkin_date - p.checkin_date > 2
              OR (
                  n.checkin_date - p.checkin_date = 2
                  AND p.grace_used = 1
              )
            THEN 0
            WHEN n.checkin_date - p.checkin_date = 2
            THEN 1
            ELSE p.grace_used
        END
    FROM streak_walk p
    JOIN ordered_checkins n
      ON n.goal_id = p.goal_id
     AND n.rn = p.rn + 1
)
SELECT
    goal_id,
    MIN(checkin_date) AS streak_start,
    MAX(checkin_date) AS streak_end,
    COUNT(*) AS streak_length
FROM streak_walk
WHERE status = 'success'
GROUP BY goal_id, streak_group;