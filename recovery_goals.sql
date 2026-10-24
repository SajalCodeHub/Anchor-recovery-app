-- Table: public.recovery_goals

-- DROP TABLE IF EXISTS public.recovery_goals;

CREATE TABLE IF NOT EXISTS public.recovery_goals
(
    goal_id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    goal_name character varying(150) COLLATE pg_catalog."default" NOT NULL,
    start_date date NOT NULL DEFAULT CURRENT_DATE,
    time_zone text COLLATE pg_catalog."default" NOT NULL DEFAULT 'UTC'::text,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT recovery_goals_pkey PRIMARY KEY (goal_id),
    CONSTRAINT recovery_goals_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES auth.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT recovery_goals_name_not_blank CHECK (length(TRIM(BOTH FROM goal_name)) > 0)
);




-- Index: idx_recovery_goals_user

-- DROP INDEX IF EXISTS public.idx_recovery_goals_user;

CREATE INDEX IF NOT EXISTS idx_recovery_goals_user
    ON public.recovery_goals USING btree
    (user_id ASC NULLS LAST)
;