
-- ============================================================
-- ANCHOR: Streak Engine & Core Daily Logs
-- Role 2: Sahar Atie
-- Database: PostgreSQL / Supabase
--
-- Purpose:
-- Store recovery goals and daily check-ins.
-- Each user can track multiple recovery goals independently.
--
-- Dependencies:
-- Supabase Authentication (auth.users)
--
-- Integration note:
-- The Analytics module can use goal_id and checkin_date
-- to calculate trends for each recovery goal.
--
-- Design status:
-- Initial schema. Streak calculations, security policies,
-- seed data, and integration tests will be added separately.
-- ============================================================

-- TABLE 1: RECOVERY GOALS
-- A user can create multiple recovery goals.
-- Each goal belongs to exactly one authenticated user.

CREATE TABLE IF NOT EXISTS public.recovery_goals (
    goal_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL
        REFERENCES auth.users(id) ON DELETE CASCADE,

    goal_name VARCHAR(150) NOT NULL,

    start_date DATE NOT NULL DEFAULT CURRENT_DATE,

    time_zone TEXT NOT NULL DEFAULT 'UTC',

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT recovery_goals_name_not_blank
        CHECK (LENGTH(TRIM(goal_name)) > 0)
);

-- Index for retrieving goals belonging to a user.
CREATE INDEX IF NOT EXISTS idx_recovery_goals_user
ON public.recovery_goals (user_id);


-- TABLE 2: DAILY CHECK-INS
-- Stores one daily check-in per recovery goal.
-- The composite primary key prevents duplicate check-ins
-- for the same goal on the same date.

CREATE TABLE IF NOT EXISTS public.daily_checkins (
    goal_id UUID NOT NULL
        REFERENCES public.recovery_goals(goal_id)
        ON DELETE CASCADE,

    checkin_date DATE NOT NULL,

    status TEXT NOT NULL,

    urge_level SMALLINT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT daily_checkins_pk
        PRIMARY KEY (goal_id, checkin_date),

    CONSTRAINT daily_checkins_valid_status
        CHECK (status IN ('success', 'relapse')),

    CONSTRAINT daily_checkins_valid_urge
        CHECK (urge_level IS NULL OR urge_level BETWEEN 0 AND 10)
);

-- Supports chronological history and date-range retrieval.
CREATE INDEX IF NOT EXISTS idx_daily_checkins_date
ON public.daily_checkins (checkin_date);
