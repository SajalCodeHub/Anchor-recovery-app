
-- ANCHOR | Role 2: Security Configuration
-- Recovery goals, daily check-ins, and streak views.
-- PostgreSQL 17 / Supabase
--
-- Apply after creating the Role 2 tables and views.
-- Authenticated users can access only their own data.
-- The materialized summary is restricted from API users.

BEGIN;

-- 1. Default the goal owner to the authenticated user.

ALTER TABLE public.recovery_goals
    ALTER COLUMN user_id SET DEFAULT auth.uid();

-- 2. Enable row-level security.

ALTER TABLE public.recovery_goals
    ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.daily_checkins
    ENABLE ROW LEVEL SECURITY;

-- 3. Goals: each user manages only their own goals.

DROP POLICY IF EXISTS "Users can manage own goals"
ON public.recovery_goals;

CREATE POLICY "Users can manage own goals"
ON public.recovery_goals
FOR ALL
TO authenticated
USING (
    user_id = (SELECT auth.uid())
)
WITH CHECK (
    user_id = (SELECT auth.uid())
);

-- 4. Daily check-ins: access through goal ownership.

DROP POLICY IF EXISTS
    "Users can manage checkins for own goals"
ON public.daily_checkins;

CREATE POLICY "Users can manage checkins for own goals"
ON public.daily_checkins
FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.recovery_goals rg
        WHERE rg.goal_id = daily_checkins.goal_id
          AND rg.user_id = (SELECT auth.uid())
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.recovery_goals rg
        WHERE rg.goal_id = daily_checkins.goal_id
          AND rg.user_id = (SELECT auth.uid())
    )
);

-- 5. Restrict anonymous access to streak views.

ALTER VIEW public.streak_periods_grace
    SET (security_invoker = true);

ALTER VIEW public.streak_stats
    SET (security_invoker = true);

REVOKE SELECT ON TABLE
    public.streak_periods_grace,
    public.streak_stats
FROM PUBLIC, anon;

GRANT SELECT ON TABLE
    public.streak_periods_grace,
    public.streak_stats
TO authenticated;

-- 6. Restrict direct access to materialized summary.

REVOKE ALL PRIVILEGES
ON TABLE public.streak_summary
FROM PUBLIC, anon, authenticated;

COMMIT;
