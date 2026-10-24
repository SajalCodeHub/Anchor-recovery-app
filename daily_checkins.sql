-- Table: public.daily_checkins

-- DROP TABLE IF EXISTS public.daily_checkins;

CREATE TABLE IF NOT EXISTS public.daily_checkins
(
    goal_id uuid NOT NULL,
    checkin_date date NOT NULL,
    status text COLLATE pg_catalog."default" NOT NULL,
    urge_level smallint,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT daily_checkins_pk PRIMARY KEY (goal_id, checkin_date),
    CONSTRAINT daily_checkins_goal_id_fkey FOREIGN KEY (goal_id)
        REFERENCES public.recovery_goals (goal_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT daily_checkins_valid_status CHECK (status = ANY (ARRAY['success'::text, 'relapse'::text])),
    CONSTRAINT daily_checkins_valid_urge CHECK (urge_level IS NULL OR urge_level >= 0 AND urge_level <= 10)
);


-- Index: idx_daily_checkins_date

-- DROP INDEX IF EXISTS public.idx_daily_checkins_date;

CREATE INDEX IF NOT EXISTS idx_daily_checkins_date
    ON public.daily_checkins USING btree
    (checkin_date ASC NULLS LAST)
;