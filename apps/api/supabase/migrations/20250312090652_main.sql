SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_cron" WITH SCHEMA "pg_catalog";



CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";



CREATE EXTENSION IF NOT EXISTS "pgsodium";



COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "hypopg" WITH SCHEMA "extensions";



CREATE EXTENSION IF NOT EXISTS "index_advisor" WITH SCHEMA "extensions";



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";



CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";



CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";



CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";



CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";



CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";



CREATE TYPE "public"."registration_status" AS ENUM (
  'Ausstehend',
  'Abgesendet',
  'Abgeschlossen',
  'Abgelehnt'
  );


ALTER TYPE "public"."registration_status" OWNER TO "postgres";


CREATE TYPE "public"."sport_type" AS ENUM (
  'Fußball',
  'Volleyball',
  'Basketball'
  );


ALTER TYPE "public"."sport_type" OWNER TO "postgres";


CREATE TYPE "public"."tournament_phase" AS ENUM (
  'Gruppenphase',
  'Viertelfinale',
  'Semifinale',
  'Finale',
  'Kleines Finale'
  );


ALTER TYPE "public"."tournament_phase" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_final"("p_tournament_id" "uuid", "p_start_time" time without time zone,
                                                     "p_interval_minutes" integer) RETURNS "void"
  LANGUAGE "plpgsql"
AS
$$
DECLARE
  team1             UUID;
  team2             UUID;
  team3             UUID;
  team4             UUID;
  start_time        TIME     := p_start_time;
  interval_minutes  INTERVAL := (p_interval_minutes || ' minutes')::INTERVAL;
  final_teams       REFCURSOR;
  third_place_teams REFCURSOR;
BEGIN
  CREATE TEMP TABLE semifinal_results AS
  SELECT m.id  AS match_id,
         CASE
           WHEN r.winner_id IS NOT NULL THEN r.winner_id
           WHEN r.team1_score > r.team2_score THEN m.team1_id
           WHEN r.team2_score > r.team1_score THEN m.team2_id
           END AS winner_id,
         CASE
           WHEN r.winner_id IS NOT NULL THEN
             CASE
               WHEN r.winner_id = m.team1_id THEN m.team2_id
               ELSE m.team1_id
               END
           WHEN r.team1_score > r.team2_score THEN m.team2_id
           WHEN r.team2_score > r.team1_score THEN m.team1_id
           END AS loser_id
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = p_tournament_id
    AND m.round = 'Semifinale';

  OPEN final_teams FOR
    SELECT s1.winner_id AS team1,
           s2.winner_id AS team2
    FROM semifinal_results s1
           JOIN semifinal_results s2 ON s1.match_id < s2.match_id;

  OPEN third_place_teams FOR
    SELECT s1.loser_id AS team3,
           s2.loser_id AS team4
    FROM semifinal_results s1
           JOIN semifinal_results s2 ON s1.match_id < s2.match_id;

  FETCH final_teams INTO team1, team2;
  IF FOUND THEN
    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time + interval_minutes, 'Finale');
  END IF;

  FETCH third_place_teams INTO team3, team4;
  IF FOUND THEN
    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team3, team4, start_time, 'Kleines Finale');
  END IF;

  CLOSE final_teams;
  CLOSE third_place_teams;
  DROP TABLE semifinal_results;
END;
$$;


ALTER FUNCTION "public"."generate_final"("p_tournament_id" "uuid", "p_start_time" time without time zone, "p_interval_minutes" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_group_stage_matches"("p_tournament_id" "uuid",
                                                                   "p_start_time" time without time zone,
                                                                   "p_interval_minutes" integer) RETURNS "void"
  LANGUAGE "plpgsql"
AS
$$
DECLARE
  team1            UUID;
  team2            UUID;
  start_time       TIME     := p_start_time;
  interval_minutes INTERVAL := (p_interval_minutes || ' minutes')::INTERVAL;
  group_a_matches  REFCURSOR;
  group_c_matches  REFCURSOR;
  group_b_matches  REFCURSOR;
  group_d_matches  REFCURSOR;
BEGIN

  OPEN group_a_matches FOR
    SELECT t1.id AS team1, t2.id AS team2
    FROM public.team t1
           JOIN public.team t2 ON t1.group_id = t2.group_id AND t1.id < t2.id
           JOIN public."group" g ON t1.group_id = g.id
    WHERE g.tournament_id = p_tournament_id
      AND g.name = 'Gruppe A';

  OPEN group_c_matches FOR
    SELECT t1.id AS team1, t2.id AS team2
    FROM public.team t1
           JOIN public.team t2 ON t1.group_id = t2.group_id AND t1.id < t2.id
           JOIN public."group" g ON t1.group_id = g.id
    WHERE g.tournament_id = p_tournament_id
      AND g.name = 'Gruppe C';

  OPEN group_b_matches FOR
    SELECT t1.id AS team1, t2.id AS team2
    FROM public.team t1
           JOIN public.team t2 ON t1.group_id = t2.group_id AND t1.id < t2.id
           JOIN public."group" g ON t1.group_id = g.id
    WHERE g.tournament_id = p_tournament_id
      AND g.name = 'Gruppe B';

  OPEN group_d_matches FOR
    SELECT t1.id AS team1, t2.id AS team2
    FROM public.team t1
           JOIN public.team t2 ON t1.group_id = t2.group_id AND t1.id < t2.id
           JOIN public."group" g ON t1.group_id = g.id
    WHERE g.tournament_id = p_tournament_id
      AND g.name = 'Gruppe D';


  LOOP

    FETCH group_a_matches INTO team1, team2;
    EXIT WHEN NOT FOUND;


    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Gruppenphase');

    FETCH group_c_matches INTO team1, team2;
    EXIT WHEN NOT FOUND;

    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Gruppenphase');

    start_time := start_time + interval_minutes;

    FETCH group_b_matches INTO team1, team2;
    EXIT WHEN NOT FOUND;

    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Gruppenphase');

    FETCH group_d_matches INTO team1, team2;
    EXIT WHEN NOT FOUND;

    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Gruppenphase');

    start_time := start_time + interval_minutes;
  END LOOP;

  CLOSE group_a_matches;
  CLOSE group_c_matches;
  CLOSE group_b_matches;
  CLOSE group_d_matches;
END;
$$;


ALTER FUNCTION "public"."generate_group_stage_matches"("p_tournament_id" "uuid", "p_start_time" time without time zone, "p_interval_minutes" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_quarterfinals"("p_tournament_id" "uuid",
                                                             "p_start_time" time without time zone,
                                                             "p_interval_minutes" integer) RETURNS "void"
  LANGUAGE "plpgsql"
AS
$$
DECLARE
  team1              UUID;
  team2              UUID;
  start_time         TIME     := p_start_time;
  interval_minutes   INTERVAL := (p_interval_minutes || ' minutes')::INTERVAL;
  quarterfinal_teams REFCURSOR;
BEGIN
  CREATE TEMP TABLE top_teams AS
  WITH ranked_teams AS (SELECT t.id                                                                                              AS team_id,
                               t.name                                                                                            AS team_name,
                               g.tournament_id,
                               g.name                                                                                            AS group_name,
                               ts.points,
                               ts.goal_difference,
                               ts.goals_scored,
                               ROW_NUMBER()
                               OVER (PARTITION BY g.name ORDER BY ts.points DESC, ts.goal_difference DESC, ts.goals_scored DESC) AS rank
                        FROM public.team t
                               JOIN public."group" g ON t.group_id = g.id
                               JOIN public.team_standings ts ON t.id = ts.team_id
                        WHERE g.tournament_id = p_tournament_id)
  SELECT team_id,
         team_name,
         tournament_id,
         group_name,
         points,
         goal_difference,
         goals_scored,
         rank
  FROM ranked_teams
  WHERE rank <= 2;

  OPEN quarterfinal_teams FOR
    SELECT a.team_id AS team1,
           b.team_id AS team2
    FROM top_teams a
           JOIN top_teams b ON a.tournament_id = b.tournament_id
    WHERE a.group_name = 'Gruppe A'
      AND a.rank = 1
      AND b.group_name = 'Gruppe B'
      AND b.rank = 2
    UNION ALL
    SELECT a.team_id AS team1,
           b.team_id AS team2
    FROM top_teams a
           JOIN top_teams b ON a.tournament_id = b.tournament_id
    WHERE a.group_name = 'Gruppe B'
      AND a.rank = 1
      AND b.group_name = 'Gruppe A'
      AND b.rank = 2
    UNION ALL
    SELECT a.team_id AS team1,
           b.team_id AS team2
    FROM top_teams a
           JOIN top_teams b ON a.tournament_id = b.tournament_id
    WHERE a.group_name = 'Gruppe C'
      AND a.rank = 1
      AND b.group_name = 'Gruppe D'
      AND b.rank = 2
    UNION ALL
    SELECT a.team_id AS team1,
           b.team_id AS team2
    FROM top_teams a
           JOIN top_teams b ON a.tournament_id = b.tournament_id
    WHERE a.group_name = 'Gruppe D'
      AND a.rank = 1
      AND b.group_name = 'Gruppe C'
      AND b.rank = 2;

  LOOP
    FETCH quarterfinal_teams INTO team1, team2;
    EXIT WHEN NOT FOUND;

    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Viertelfinale');

    start_time := start_time + interval_minutes;
  END LOOP;

  CLOSE quarterfinal_teams;
  DROP TABLE top_teams;
END;
$$;


ALTER FUNCTION "public"."generate_quarterfinals"("p_tournament_id" "uuid", "p_start_time" time without time zone, "p_interval_minutes" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_semifinals"("p_tournament_id" "uuid",
                                                          "p_start_time" time without time zone,
                                                          "p_interval_minutes" integer) RETURNS "void"
  LANGUAGE "plpgsql"
AS
$$
DECLARE
  team_ids         UUID[];
  start_time       TIME     := p_start_time;
  interval_minutes INTERVAL := (p_interval_minutes || ' minutes')::INTERVAL;
BEGIN
  SELECT ARRAY_AGG(winner_id ORDER BY match_id)
  INTO team_ids
  FROM (SELECT m.id  AS match_id,
               CASE
                 WHEN r.winner_id IS NOT NULL THEN r.winner_id
                 WHEN r.team1_score > r.team2_score THEN m.team1_id
                 WHEN r.team2_score > r.team1_score THEN m.team2_id
                 END AS winner_id
        FROM public.match m
               LEFT JOIN public.result r ON m.id = r.match_id
        WHERE m.tournament_id = p_tournament_id
          AND m.round = 'Viertelfinale') AS quarterfinal_winners
  WHERE winner_id IS NOT NULL;

  IF array_length(team_ids, 1) != 4 THEN
    RAISE NOTICE 'Invalid number of quarter-final winners: %', array_length(team_ids, 1);
    RETURN;
  END IF;

  INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
  VALUES (p_tournament_id, team_ids[1], team_ids[3], start_time, 'Semifinale'),
         (p_tournament_id, team_ids[2], team_ids[4], start_time + interval_minutes, 'Semifinale');

END;
$$;


ALTER FUNCTION "public"."generate_semifinals"("p_tournament_id" "uuid", "p_start_time" time without time zone, "p_interval_minutes" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."record_match_result"("p_match_id" "uuid", "p_team1_score" smallint,
                                                          "p_team2_score" smallint) RETURNS "void"
  LANGUAGE "plpgsql"
AS
$$
DECLARE
  winner UUID;
BEGIN

  IF p_team1_score > p_team2_score THEN
    SELECT team1_id INTO winner FROM public.match WHERE id = p_match_id;
  ELSIF p_team1_score < p_team2_score THEN
    SELECT team2_id INTO winner FROM public.match WHERE id = p_match_id;
  ELSE
    winner := NULL;
  END IF;


  INSERT INTO public.result (match_id, team1_score, team2_score, winner_id)
  VALUES (p_match_id, p_team1_score, p_team2_score, winner);

END;
$$;


ALTER FUNCTION "public"."record_match_result"("p_match_id" "uuid", "p_team1_score" smallint, "p_team2_score" smallint) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."trigger_generate_final"() RETURNS "trigger"
  LANGUAGE "plpgsql"
AS
$$
DECLARE
  v_tournament_id            UUID;
  v_round                    TEXT;
  semifinal_count            INT;
  semifinal_results_count    INT;
  existing_final_count       INT;
  existing_third_place_count INT;
  v_knockout_interval        INT;
BEGIN
  SELECT m.tournament_id, m.round
  INTO v_tournament_id, v_round
  FROM public.match m
  WHERE m.id = NEW.match_id;

  IF v_tournament_id IS NULL OR v_round <> 'Semifinale' THEN
    RETURN NEW;
  END IF;

  SELECT COUNT(*)
  INTO semifinal_count
  FROM public.match
  WHERE tournament_id = v_tournament_id
    AND round = 'Semifinale';

  SELECT COUNT(*)
  INTO semifinal_results_count
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = v_tournament_id
    AND m.round = 'Semifinale'
    AND r.id IS NOT NULL;

  SELECT COUNT(*)
  INTO existing_final_count
  FROM public.match
  WHERE tournament_id = v_tournament_id
    AND round = 'Finale';

  SELECT COUNT(*)
  INTO existing_third_place_count
  FROM public.match
  WHERE tournament_id = v_tournament_id
    AND round = 'Kleines Finale';

  IF semifinal_count = semifinal_results_count AND existing_final_count = 0 AND existing_third_place_count = 0 THEN
    SELECT knockout_interval
    INTO v_knockout_interval
    FROM public.tournament
    WHERE id = v_tournament_id;

    PERFORM generate_final(
      v_tournament_id,
      NOW()::TIME,
      COALESCE(v_knockout_interval, 15)
            );
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."trigger_generate_final"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."trigger_generate_quarterfinals"() RETURNS "trigger"
  LANGUAGE "plpgsql"
AS
$$
DECLARE
  v_tournament_id           UUID;
  v_round                   TEXT;
  group_stage_count         INT;
  group_stage_results_count INT;
  v_knockout_interval       INT;
BEGIN
  SELECT m.tournament_id, m.round
  INTO v_tournament_id, v_round
  FROM public.match m
  WHERE m.id = NEW.match_id;

  IF v_tournament_id IS NULL OR v_round <> 'Gruppenphase' THEN
    RETURN NEW;
  END IF;

  SELECT COUNT(*)
  INTO group_stage_count
  FROM public.match
  WHERE tournament_id = v_tournament_id
    AND round = 'Gruppenphase';

  SELECT COUNT(*)
  INTO group_stage_results_count
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = v_tournament_id
    AND m.round = 'Gruppenphase'
    AND r.id IS NOT NULL;

  IF group_stage_count = group_stage_results_count THEN
    SELECT knockout_interval
    INTO v_knockout_interval
    FROM public.tournament
    WHERE id = v_tournament_id;

    PERFORM generate_quarterfinals(
      v_tournament_id,
      NOW()::TIME,
      COALESCE(v_knockout_interval, 15)
            );
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."trigger_generate_quarterfinals"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."trigger_generate_semifinals"() RETURNS "trigger"
  LANGUAGE "plpgsql"
AS
$$
DECLARE
  v_tournament_id            UUID;
  v_round                    TEXT;
  quarterfinal_count         INT;
  quarterfinal_results_count INT;
  v_knockout_interval        INT;
BEGIN
  SELECT m.tournament_id, m.round
  INTO v_tournament_id, v_round
  FROM public.match m
  WHERE m.id = NEW.match_id;

  IF v_tournament_id IS NULL OR v_round <> 'Viertelfinale' THEN
    RETURN NEW;
  END IF;

  SELECT COUNT(*)
  INTO quarterfinal_count
  FROM public.match
  WHERE tournament_id = v_tournament_id
    AND round = 'Viertelfinale';

  SELECT COUNT(*)
  INTO quarterfinal_results_count
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = v_tournament_id
    AND m.round = 'Viertelfinale'
    AND r.id IS NOT NULL;

  IF quarterfinal_count = quarterfinal_results_count THEN
    SELECT knockout_interval
    INTO v_knockout_interval
    FROM public.tournament
    WHERE id = v_tournament_id;

    PERFORM generate_semifinals(
      v_tournament_id,
      NOW()::TIME,
      COALESCE(v_knockout_interval, 15)
            );
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."trigger_generate_semifinals"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."trigger_update_tournament_results"() RETURNS "trigger"
  LANGUAGE "plpgsql"
AS
$$
DECLARE
  v_tournament_id           UUID;
  v_round                   TEXT;
  finale_results_count      INT;
  third_place_results_count INT;
BEGIN

  SELECT m.tournament_id, m.round
  INTO v_tournament_id, v_round
  FROM public.match m
  WHERE m.id = NEW.match_id;


  IF v_tournament_id IS NULL OR (v_round <> 'Finale' AND v_round <> 'Kleines Finale') THEN
    RETURN NEW;
  END IF;


  SELECT COUNT(*)
  INTO finale_results_count
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = v_tournament_id
    AND m.round = 'Finale'
    AND r.id IS NOT NULL;

  SELECT COUNT(*)
  INTO third_place_results_count
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = v_tournament_id
    AND m.round = 'Kleines Finale'
    AND r.id IS NOT NULL;


  IF finale_results_count = 1 AND third_place_results_count = 1 THEN
    PERFORM update_tournament_results(v_tournament_id);
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."trigger_update_tournament_results"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_registration_status"() RETURNS "void"
  LANGUAGE "plpgsql"
AS
$$
BEGIN
  UPDATE public.registration
  SET status = 'Abgelehnt'::public.registration_status
  WHERE expire_date = CURRENT_DATE;
END;
$$;


ALTER FUNCTION "public"."update_registration_status"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_tournament_results"("p_tournament_id" "uuid") RETURNS "void"
  LANGUAGE "plpgsql"
AS
$$
DECLARE
  final_winner_id       UUID;
  final_loser_id        UUID;
  third_place_winner_id UUID;
  third_place_loser_id  UUID;
BEGIN

  SELECT CASE
           WHEN r.winner_id IS NOT NULL THEN r.winner_id
           WHEN r.team1_score > r.team2_score THEN m.team1_id
           WHEN r.team2_score > r.team1_score THEN m.team2_id
           ELSE NULL
           END AS winner_id,
         CASE
           WHEN r.winner_id IS NOT NULL THEN
             CASE
               WHEN r.winner_id = m.team1_id THEN m.team2_id
               ELSE m.team1_id
               END
           WHEN r.team1_score > r.team2_score THEN m.team2_id
           WHEN r.team2_score > r.team1_score THEN m.team1_id
           ELSE NULL
           END AS loser_id
  INTO final_winner_id, final_loser_id
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = p_tournament_id
    AND m.round = 'Finale';


  SELECT CASE
           WHEN r.winner_id IS NOT NULL THEN r.winner_id
           WHEN r.team1_score > r.team2_score THEN m.team1_id
           WHEN r.team2_score > r.team1_score THEN m.team2_id
           ELSE NULL
           END AS winner_id,
         CASE
           WHEN r.winner_id IS NOT NULL THEN
             CASE
               WHEN r.winner_id = m.team1_id THEN m.team2_id
               ELSE m.team1_id
               END
           WHEN r.team1_score > r.team2_score THEN m.team2_id
           WHEN r.team2_score > r.team1_score THEN m.team1_id
           ELSE NULL
           END AS loser_id
  INTO third_place_winner_id, third_place_loser_id
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = p_tournament_id
    AND m.round = 'Kleines Finale';


  INSERT INTO public.tournament_result (tournament_id, team_id, position)
  VALUES (p_tournament_id, final_winner_id, 1),
         (p_tournament_id, final_loser_id, 2),
         (p_tournament_id, third_place_winner_id, 3),
         (p_tournament_id, third_place_loser_id, 4);
END;
$$;


ALTER FUNCTION "public"."update_tournament_results"("p_tournament_id" "uuid") OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."class"
(
  "id"   "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
  "name" "text"                             NOT NULL,
  "year" "text"                             NOT NULL
);


ALTER TABLE "public"."class"
  OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."group"
(
  "id"            "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
  "name"          "text"                             NOT NULL,
  "tournament_id" "uuid"                             NOT NULL
);


ALTER TABLE "public"."group"
  OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."match"
(
  "id"            "uuid"  DEFAULT "gen_random_uuid"() NOT NULL,
  "tournament_id" "uuid"                              NOT NULL,
  "team1_id"      "uuid"                              NOT NULL,
  "team2_id"      "uuid"                              NOT NULL,
  "start_time"    time without time zone              NOT NULL,
  "end_time"      time without time zone,
  "round"         "public"."tournament_phase"         NOT NULL,
  "is_live"       boolean DEFAULT false               NOT NULL
);


ALTER TABLE "public"."match"
  OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."result"
(
  "id"          "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
  "team1_score" smallint                           NOT NULL,
  "team2_score" smallint                           NOT NULL,
  "winner_id"   "uuid",
  "match_id"    "uuid"                             NOT NULL
);


ALTER TABLE "public"."result"
  OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."team"
(
  "id"              "uuid"                   DEFAULT "gen_random_uuid"() NOT NULL,
  "created_at"      timestamp with time zone DEFAULT "now"()             NOT NULL,
  "name"            "text"                                               NOT NULL,
  "logo_id"         "uuid"                                               NOT NULL,
  "tournament_id"   "uuid",
  "registration_id" "uuid"                                               NOT NULL,
  "logo_variant_id" "uuid",
  "group_id"        "uuid"
);


ALTER TABLE "public"."team"
  OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."group_standings" AS
SELECT "t"."id"                                                            AS "team_id",
       "t"."name"                                                          AS "team_name",
       "t"."tournament_id",
       "t"."group_id",
       COALESCE("sum"(
                  CASE
                    WHEN ("r"."winner_id" = "t"."id") THEN 3
                    WHEN (("r"."winner_id" IS NULL) AND ("r"."id" IS NOT NULL)) THEN 1
                    ELSE 0
                    END), (0)::bigint)                                     AS "points",
       COALESCE("count"(
                  CASE
                    WHEN ("r"."winner_id" = "t"."id") THEN 1
                    ELSE NULL::integer
                    END), (0)::bigint)                                     AS "wins",
       COALESCE("count"(
                  CASE
                    WHEN (("r"."winner_id" IS NULL) AND ("r"."id" IS NOT NULL)) THEN 1
                    ELSE NULL::integer
                    END), (0)::bigint)                                     AS "draws",
       COALESCE("count"(
                  CASE
                    WHEN (("r"."winner_id" IS NOT NULL) AND ("r"."winner_id" <> "t"."id")) THEN 1
                    ELSE NULL::integer
                    END), (0)::bigint)                                     AS "losses",
       COALESCE("sum"(
                  CASE
                    WHEN ("m"."team1_id" = "t"."id") THEN "r"."team1_score"
                    ELSE "r"."team2_score"
                    END), (0)::bigint)                                     AS "goals_scored",
       COALESCE("sum"(
                  CASE
                    WHEN ("m"."team1_id" = "t"."id") THEN "r"."team2_score"
                    ELSE "r"."team1_score"
                    END), (0)::bigint)                                     AS "goals_conceded",
       (COALESCE("sum"(
                   CASE
                     WHEN ("m"."team1_id" = "t"."id") THEN "r"."team1_score"
                     ELSE "r"."team2_score"
                     END), (0)::bigint) - COALESCE("sum"(
                                                     CASE
                                                       WHEN ("m"."team1_id" = "t"."id") THEN "r"."team2_score"
                                                       ELSE "r"."team1_score"
                                                       END), (0)::bigint)) AS "goal_difference"
FROM (("public"."team" "t"
  LEFT JOIN "public"."match" "m" ON ((("t"."id" = "m"."team1_id") OR ("t"."id" = "m"."team2_id"))))
  LEFT JOIN "public"."result" "r" ON (("r"."match_id" = "m"."id")))
WHERE ("t"."group_id" IS NOT NULL)
GROUP BY "t"."id", "t"."name", "t"."tournament_id", "t"."group_id"
ORDER BY "t"."group_id",
         COALESCE("sum"(
                    CASE
                      WHEN ("r"."winner_id" = "t"."id") THEN 3
                      WHEN (("r"."winner_id" IS NULL) AND ("r"."id" IS NOT NULL)) THEN 1
                      ELSE 0
                      END), (0)::bigint) DESC,
         (COALESCE("sum"(
                     CASE
                       WHEN ("m"."team1_id" = "t"."id") THEN "r"."team1_score"
                       ELSE "r"."team2_score"
                       END), (0)::bigint) - COALESCE("sum"(
                                                       CASE
                                                         WHEN ("m"."team1_id" = "t"."id") THEN "r"."team2_score"
                                                         ELSE "r"."team1_score"
                                                         END), (0)::bigint)) DESC,
         COALESCE("sum"(
                    CASE
                      WHEN ("m"."team1_id" = "t"."id") THEN "r"."team1_score"
                      ELSE "r"."team2_score"
                      END), (0)::bigint) DESC;


ALTER TABLE "public"."group_standings"
  OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."logo"
(
  "id"         "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
  "name"       "text"                             NOT NULL,
  "image_path" "text"                             NOT NULL
);


ALTER TABLE "public"."logo"
  OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."logo_variant"
(
  "id"         "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
  "color"      "text"                             NOT NULL,
  "image_path" "text"                             NOT NULL,
  "logo_id"    "uuid"                             NOT NULL
);


ALTER TABLE "public"."logo_variant"
  OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."matches_status" AS
SELECT "m"."id"    AS "match_id",
       "m"."tournament_id",
       "m"."team1_id",
       "t1"."name" AS "team1_name",
       "m"."team2_id",
       "t2"."name" AS "team2_name",
       "m"."start_time",
       "m"."end_time",
       "m"."round",
       CASE
         WHEN ("r"."id" IS NOT NULL) THEN 'completed'::"text"
         WHEN "m"."is_live" THEN 'live'::"text"
         ELSE 'upcoming'::"text"
         END       AS "status"
FROM ((("public"."match" "m"
  LEFT JOIN "public"."result" "r" ON (("r"."match_id" = "m"."id")))
  LEFT JOIN "public"."team" "t1" ON (("m"."team1_id" = "t1"."id")))
  LEFT JOIN "public"."team" "t2" ON (("m"."team2_id" = "t2"."id")))
ORDER BY "m"."start_time";


ALTER TABLE "public"."matches_status"
  OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."player"
(
  "id"         "uuid"                   DEFAULT "gen_random_uuid"() NOT NULL,
  "created_at" timestamp with time zone DEFAULT "now"()             NOT NULL,
  "first_name" "text"                                               NOT NULL,
  "last_name"  "text"                                               NOT NULL,
  "class"      "text"                                               NOT NULL,
  "note"       "text"                   DEFAULT ''::"text"          NOT NULL,
  "team_id"    "uuid"                                               NOT NULL
);


ALTER TABLE "public"."player"
  OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."registration"
(
  "id"                 "uuid"                         DEFAULT "gen_random_uuid"()                          NOT NULL,
  "expire_date"        "date"                                                                              NOT NULL,
  "status"             "public"."registration_status" DEFAULT 'Ausstehend'::"public"."registration_status" NOT NULL,
  "class_id"           "uuid"                                                                              NOT NULL,
  "name"               "text"                                                                              NOT NULL,
  "hidden"             boolean                        DEFAULT false                                        NOT NULL,
  "allow_class_mixing" boolean                        DEFAULT false                                        NOT NULL
);


ALTER TABLE "public"."registration"
  OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."team_standings" AS
SELECT "t"."id"                                                            AS "team_id",
       "t"."name"                                                          AS "team_name",
       "t"."tournament_id",
       COALESCE("sum"(
                  CASE
                    WHEN ("r"."winner_id" = "t"."id") THEN 3
                    WHEN (("r"."winner_id" IS NULL) AND ("r"."id" IS NOT NULL)) THEN 1
                    ELSE 0
                    END), (0)::bigint)                                     AS "points",
       COALESCE("count"(
                  CASE
                    WHEN ("r"."winner_id" = "t"."id") THEN 1
                    ELSE NULL::integer
                    END), (0)::bigint)                                     AS "wins",
       COALESCE("count"(
                  CASE
                    WHEN (("r"."winner_id" IS NULL) AND ("r"."id" IS NOT NULL)) THEN 1
                    ELSE NULL::integer
                    END), (0)::bigint)                                     AS "draws",
       COALESCE("count"(
                  CASE
                    WHEN (("r"."winner_id" IS NOT NULL) AND ("r"."winner_id" <> "t"."id")) THEN 1
                    ELSE NULL::integer
                    END), (0)::bigint)                                     AS "losses",
       COALESCE("sum"(
                  CASE
                    WHEN ("m"."team1_id" = "t"."id") THEN "r"."team1_score"
                    ELSE "r"."team2_score"
                    END), (0)::bigint)                                     AS "goals_scored",
       COALESCE("sum"(
                  CASE
                    WHEN ("m"."team1_id" = "t"."id") THEN "r"."team2_score"
                    ELSE "r"."team1_score"
                    END), (0)::bigint)                                     AS "goals_conceded",
       (COALESCE("sum"(
                   CASE
                     WHEN ("m"."team1_id" = "t"."id") THEN "r"."team1_score"
                     ELSE "r"."team2_score"
                     END), (0)::bigint) - COALESCE("sum"(
                                                     CASE
                                                       WHEN ("m"."team1_id" = "t"."id") THEN "r"."team2_score"
                                                       ELSE "r"."team1_score"
                                                       END), (0)::bigint)) AS "goal_difference"
FROM (("public"."team" "t"
  LEFT JOIN "public"."match" "m" ON (((("t"."id" = "m"."team1_id") OR ("t"."id" = "m"."team2_id")) AND
                                      ("m"."tournament_id" = "t"."tournament_id"))))
  LEFT JOIN "public"."result" "r" ON (("r"."match_id" = "m"."id")))
WHERE ("t"."tournament_id" IS NOT NULL)
GROUP BY "t"."id", "t"."name", "t"."tournament_id"
ORDER BY "t"."tournament_id",
         COALESCE("sum"(
                    CASE
                      WHEN ("r"."winner_id" = "t"."id") THEN 3
                      WHEN (("r"."winner_id" IS NULL) AND ("r"."id" IS NOT NULL)) THEN 1
                      ELSE 0
                      END), (0)::bigint) DESC,
         (COALESCE("sum"(
                     CASE
                       WHEN ("m"."team1_id" = "t"."id") THEN "r"."team1_score"
                       ELSE "r"."team2_score"
                       END), (0)::bigint) - COALESCE("sum"(
                                                       CASE
                                                         WHEN ("m"."team1_id" = "t"."id") THEN "r"."team2_score"
                                                         ELSE "r"."team1_score"
                                                         END), (0)::bigint)) DESC,
         COALESCE("sum"(
                    CASE
                      WHEN ("m"."team1_id" = "t"."id") THEN "r"."team1_score"
                      ELSE "r"."team2_score"
                      END), (0)::bigint) DESC;


ALTER TABLE "public"."team_standings"
  OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tournament"
(
  "id"                "uuid"                   DEFAULT "gen_random_uuid"()            NOT NULL,
  "created_at"        timestamp with time zone DEFAULT "now"()                        NOT NULL,
  "name"              "text"                                                          NOT NULL,
  "rules"             "text",
  "start_date"        "date"                                                          NOT NULL,
  "from"              time without time zone                                          NOT NULL,
  "to"                time without time zone                                          NOT NULL,
  "is_live"           boolean                  DEFAULT false                          NOT NULL,
  "year"              smallint                                                        NOT NULL,
  "last_edited_by_id" "uuid"                                                          NOT NULL,
  "sport"             "public"."sport_type"                                           NOT NULL,
  "location"          "text"                   DEFAULT '''Sportplatz''::text'::"text" NOT NULL,
  "prizes"            "jsonb",
  "thumbnail_path"    "text"                                                          NOT NULL,
  "group_teams"       smallint                                                        NOT NULL,
  "groups"            smallint                                                        NOT NULL,
  "knockout_interval" smallint                 DEFAULT '15'::smallint,
  CONSTRAINT "prizes_json_schema" CHECK ((("prizes" IS NULL) OR (("prizes" ? 'first'::"text") AND
                                                                 (("prizes" ->> 'first'::"text") IS NOT NULL) AND
                                                                 ("prizes" ? 'second'::"text") AND
                                                                 (("prizes" ->> 'second'::"text") IS NOT NULL) AND
                                                                 ("prizes" ? 'third'::"text") AND
                                                                 (("prizes" ->> 'third'::"text") IS NOT NULL) AND
                                                                 ("prizes" ? 'bonus'::"text") AND
                                                                 (("prizes" ->> 'bonus'::"text") IS NOT NULL))))
);


ALTER TABLE "public"."tournament"
  OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tournament_result"
(
  "tournament_id" "uuid"  NOT NULL,
  "team_id"       "uuid"  NOT NULL,
  "position"      integer NOT NULL
);


ALTER TABLE "public"."tournament_result"
  OWNER TO "postgres";


ALTER TABLE ONLY "public"."class"
  ADD CONSTRAINT "class_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."group"
  ADD CONSTRAINT "group_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."logo"
  ADD CONSTRAINT "logo_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."logo_variant"
  ADD CONSTRAINT "logo_variant_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."match"
  ADD CONSTRAINT "match_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."player"
  ADD CONSTRAINT "player_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."registration"
  ADD CONSTRAINT "registration_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."result"
  ADD CONSTRAINT "result_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."team"
  ADD CONSTRAINT "team_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tournament"
  ADD CONSTRAINT "tournament_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tournament_result"
  ADD CONSTRAINT "tournament_results_pkey" PRIMARY KEY ("tournament_id", "team_id");



CREATE INDEX "match_team1_id_idx" ON "public"."match" USING "btree" ("team1_id");



CREATE INDEX "match_team2_id_idx" ON "public"."match" USING "btree" ("team2_id");



CREATE INDEX "match_tournament_id_start_time_idx" ON "public"."match" USING "btree" ("tournament_id", "start_time");



CREATE INDEX "result_match_id_idx" ON "public"."result" USING "btree" ("match_id");



CREATE INDEX "tournament_live_idx" ON "public"."tournament" USING "btree" ("is_live") WHERE ("is_live" = true);



CREATE OR REPLACE TRIGGER "trigger_final_results"
  AFTER INSERT OR UPDATE
  ON "public"."result"
  FOR EACH ROW
EXECUTE FUNCTION "public"."trigger_update_tournament_results"();



CREATE OR REPLACE TRIGGER "trigger_group_stage_results"
  AFTER INSERT OR UPDATE
  ON "public"."result"
  FOR EACH ROW
EXECUTE FUNCTION "public"."trigger_generate_quarterfinals"();



CREATE OR REPLACE TRIGGER "trigger_quarterfinal_results"
  AFTER INSERT OR UPDATE
  ON "public"."result"
  FOR EACH ROW
EXECUTE FUNCTION "public"."trigger_generate_semifinals"();



CREATE OR REPLACE TRIGGER "trigger_semifinal_results"
  AFTER INSERT OR UPDATE
  ON "public"."result"
  FOR EACH ROW
EXECUTE FUNCTION "public"."trigger_generate_final"();



ALTER TABLE ONLY "public"."group"
  ADD CONSTRAINT "group_tournament_id_fkey" FOREIGN KEY ("tournament_id") REFERENCES "public"."tournament" ("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."logo_variant"
  ADD CONSTRAINT "logo_variant_logo_id_fkey" FOREIGN KEY ("logo_id") REFERENCES "public"."logo" ("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."match"
  ADD CONSTRAINT "match_team1_id_fkey" FOREIGN KEY ("team1_id") REFERENCES "public"."team" ("id");



ALTER TABLE ONLY "public"."match"
  ADD CONSTRAINT "match_team2_id_fkey" FOREIGN KEY ("team2_id") REFERENCES "public"."team" ("id");



ALTER TABLE ONLY "public"."match"
  ADD CONSTRAINT "match_tournament_id_fkey" FOREIGN KEY ("tournament_id") REFERENCES "public"."tournament" ("id");



ALTER TABLE ONLY "public"."player"
  ADD CONSTRAINT "player_team_id_fkey" FOREIGN KEY ("team_id") REFERENCES "public"."team" ("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."registration"
  ADD CONSTRAINT "registration_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "public"."class" ("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."result"
  ADD CONSTRAINT "result_match_id_fkey" FOREIGN KEY ("match_id") REFERENCES "public"."match" ("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."result"
  ADD CONSTRAINT "result_winner_id_fkey" FOREIGN KEY ("winner_id") REFERENCES "public"."team" ("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."team"
  ADD CONSTRAINT "team_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "public"."group" ("id");



ALTER TABLE ONLY "public"."team"
  ADD CONSTRAINT "team_logo_id_fkey" FOREIGN KEY ("logo_id") REFERENCES "public"."logo" ("id");



ALTER TABLE ONLY "public"."team"
  ADD CONSTRAINT "team_logo_variant_id_fkey" FOREIGN KEY ("logo_variant_id") REFERENCES "public"."logo_variant" ("id");



ALTER TABLE ONLY "public"."team"
  ADD CONSTRAINT "team_registration_id_fkey" FOREIGN KEY ("registration_id") REFERENCES "public"."registration" ("id");



ALTER TABLE ONLY "public"."team"
  ADD CONSTRAINT "team_tournament_id_fkey" FOREIGN KEY ("tournament_id") REFERENCES "public"."tournament" ("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tournament"
  ADD CONSTRAINT "tournament_last_edited_by_id_fkey" FOREIGN KEY ("last_edited_by_id") REFERENCES "auth"."users" ("id");



ALTER TABLE ONLY "public"."tournament_result"
  ADD CONSTRAINT "tournament_results_team_id_fkey" FOREIGN KEY ("team_id") REFERENCES "public"."team" ("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tournament_result"
  ADD CONSTRAINT "tournament_results_tournament_id_fkey" FOREIGN KEY ("tournament_id") REFERENCES "public"."tournament" ("id") ON UPDATE CASCADE ON DELETE CASCADE;



CREATE POLICY "Allow deletion" ON "public"."registration" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "Authenticated can update" ON "public"."tournament" FOR UPDATE TO "authenticated" USING (true);



CREATE POLICY "Enable Insert for all users" ON "public"."player" FOR INSERT WITH CHECK (true);



CREATE POLICY "Enable delete for authenticated users" ON "public"."team" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."class" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."group" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."registration" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."team" FOR INSERT WITH CHECK (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."tournament" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."tournament_result" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable read access for all users" ON "public"."class" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."group" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."logo" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."logo_variant" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."match" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."player" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."registration" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."result" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."team" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."tournament" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."tournament_result" FOR SELECT USING (true);



CREATE POLICY "Enable update for users based on email" ON "public"."registration" FOR UPDATE USING (true);



CREATE POLICY "authenticated can create" ON "public"."match" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "authenticated can delete" ON "public"."group" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "authenticated can delete" ON "public"."player" FOR DELETE TO "authenticated" USING (true);



CREATE POLICY "authenticated can insert" ON "public"."result" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "authenticated can update" ON "public"."match" FOR UPDATE TO "authenticated" USING (true);



CREATE POLICY "authenticated can update" ON "public"."player" FOR UPDATE TO "authenticated" USING (true);



CREATE POLICY "authenticated can update" ON "public"."team" FOR UPDATE TO "authenticated" USING (true);



CREATE POLICY "authenticated can update " ON "public"."result" FOR UPDATE TO "authenticated" USING (true);



CREATE POLICY "authenticated users can delete" ON "public"."tournament" FOR DELETE TO "authenticated" USING (true);



ALTER TABLE "public"."class"
  ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."group"
  ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."logo"
  ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."logo_variant"
  ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."match"
  ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."player"
  ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."registration"
  ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."result"
  ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."team"
  ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."tournament"
  ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."tournament_result"
  ENABLE ROW LEVEL SECURITY;



ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."match";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."result";



GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_final"("p_tournament_id" "uuid", "p_start_time" time without time zone, "p_interval_minutes" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."generate_final"("p_tournament_id" "uuid", "p_start_time" time without time zone, "p_interval_minutes" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_final"("p_tournament_id" "uuid", "p_start_time" time without time zone, "p_interval_minutes" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_group_stage_matches"("p_tournament_id" "uuid", "p_start_time" time without time zone, "p_interval_minutes" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."generate_group_stage_matches"("p_tournament_id" "uuid", "p_start_time" time without time zone, "p_interval_minutes" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_group_stage_matches"("p_tournament_id" "uuid", "p_start_time" time without time zone, "p_interval_minutes" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_quarterfinals"("p_tournament_id" "uuid", "p_start_time" time without time zone, "p_interval_minutes" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."generate_quarterfinals"("p_tournament_id" "uuid", "p_start_time" time without time zone, "p_interval_minutes" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_quarterfinals"("p_tournament_id" "uuid", "p_start_time" time without time zone, "p_interval_minutes" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_semifinals"("p_tournament_id" "uuid", "p_start_time" time without time zone, "p_interval_minutes" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."generate_semifinals"("p_tournament_id" "uuid", "p_start_time" time without time zone, "p_interval_minutes" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_semifinals"("p_tournament_id" "uuid", "p_start_time" time without time zone, "p_interval_minutes" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."record_match_result"("p_match_id" "uuid", "p_team1_score" smallint, "p_team2_score" smallint) TO "anon";
GRANT ALL ON FUNCTION "public"."record_match_result"("p_match_id" "uuid", "p_team1_score" smallint, "p_team2_score" smallint) TO "authenticated";
GRANT ALL ON FUNCTION "public"."record_match_result"("p_match_id" "uuid", "p_team1_score" smallint, "p_team2_score" smallint) TO "service_role";



GRANT ALL ON FUNCTION "public"."trigger_generate_final"() TO "anon";
GRANT ALL ON FUNCTION "public"."trigger_generate_final"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."trigger_generate_final"() TO "service_role";



GRANT ALL ON FUNCTION "public"."trigger_generate_quarterfinals"() TO "anon";
GRANT ALL ON FUNCTION "public"."trigger_generate_quarterfinals"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."trigger_generate_quarterfinals"() TO "service_role";



GRANT ALL ON FUNCTION "public"."trigger_generate_semifinals"() TO "anon";
GRANT ALL ON FUNCTION "public"."trigger_generate_semifinals"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."trigger_generate_semifinals"() TO "service_role";



GRANT ALL ON FUNCTION "public"."trigger_update_tournament_results"() TO "anon";
GRANT ALL ON FUNCTION "public"."trigger_update_tournament_results"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."trigger_update_tournament_results"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_registration_status"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_registration_status"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_registration_status"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_tournament_results"("p_tournament_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."update_tournament_results"("p_tournament_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_tournament_results"("p_tournament_id" "uuid") TO "service_role";



GRANT ALL ON TABLE "public"."class" TO "anon";
GRANT ALL ON TABLE "public"."class" TO "authenticated";
GRANT ALL ON TABLE "public"."class" TO "service_role";



GRANT ALL ON TABLE "public"."group" TO "anon";
GRANT ALL ON TABLE "public"."group" TO "authenticated";
GRANT ALL ON TABLE "public"."group" TO "service_role";



GRANT ALL ON TABLE "public"."match" TO "anon";
GRANT ALL ON TABLE "public"."match" TO "authenticated";
GRANT ALL ON TABLE "public"."match" TO "service_role";



GRANT ALL ON TABLE "public"."result" TO "anon";
GRANT ALL ON TABLE "public"."result" TO "authenticated";
GRANT ALL ON TABLE "public"."result" TO "service_role";



GRANT ALL ON TABLE "public"."team" TO "anon";
GRANT ALL ON TABLE "public"."team" TO "authenticated";
GRANT ALL ON TABLE "public"."team" TO "service_role";



GRANT ALL ON TABLE "public"."group_standings" TO "anon";
GRANT ALL ON TABLE "public"."group_standings" TO "authenticated";
GRANT ALL ON TABLE "public"."group_standings" TO "service_role";



GRANT ALL ON TABLE "public"."logo" TO "anon";
GRANT ALL ON TABLE "public"."logo" TO "authenticated";
GRANT ALL ON TABLE "public"."logo" TO "service_role";



GRANT ALL ON TABLE "public"."logo_variant" TO "anon";
GRANT ALL ON TABLE "public"."logo_variant" TO "authenticated";
GRANT ALL ON TABLE "public"."logo_variant" TO "service_role";



GRANT ALL ON TABLE "public"."matches_status" TO "anon";
GRANT ALL ON TABLE "public"."matches_status" TO "authenticated";
GRANT ALL ON TABLE "public"."matches_status" TO "service_role";



GRANT ALL ON TABLE "public"."player" TO "anon";
GRANT ALL ON TABLE "public"."player" TO "authenticated";
GRANT ALL ON TABLE "public"."player" TO "service_role";



GRANT ALL ON TABLE "public"."registration" TO "anon";
GRANT ALL ON TABLE "public"."registration" TO "authenticated";
GRANT ALL ON TABLE "public"."registration" TO "service_role";



GRANT ALL ON TABLE "public"."team_standings" TO "anon";
GRANT ALL ON TABLE "public"."team_standings" TO "authenticated";
GRANT ALL ON TABLE "public"."team_standings" TO "service_role";



GRANT ALL ON TABLE "public"."tournament" TO "anon";
GRANT ALL ON TABLE "public"."tournament" TO "authenticated";
GRANT ALL ON TABLE "public"."tournament" TO "service_role";



GRANT ALL ON TABLE "public"."tournament_result" TO "anon";
GRANT ALL ON TABLE "public"."tournament_result" TO "authenticated";
GRANT ALL ON TABLE "public"."tournament_result" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";



RESET ALL;



CREATE POLICY "authenticated can do all 1zu98_0" ON "storage"."objects" FOR INSERT TO "authenticated" WITH CHECK (("bucket_id" = 'misc'::"text"));



CREATE POLICY "authenticated can do all 1zu98_1" ON "storage"."objects" FOR SELECT TO "authenticated" USING (("bucket_id" = 'misc'::"text"));



CREATE POLICY "authenticated can do all 1zu98_2" ON "storage"."objects" FOR UPDATE TO "authenticated" USING (("bucket_id" = 'misc'::"text"));



CREATE POLICY "authenticated can do all 1zu98_3" ON "storage"."objects" FOR DELETE TO "authenticated" USING (("bucket_id" = 'misc'::"text"));



CREATE POLICY "everyone can read buckets" ON "storage"."buckets" FOR SELECT USING (true);



CREATE POLICY "everyone can read images 1ffg0oo_0" ON "storage"."objects" FOR SELECT USING (("bucket_id" = 'images'::"text"));
CREATE POLICY "authenticated can insert,update,delete 1ffg0oo_0" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'images');
CREATE POLICY "authenticated can insert,update,delete 1ffg0oo_1" ON storage.objects FOR UPDATE TO authenticated USING (bucket_id = 'images');
CREATE POLICY "authenticated can insert,update,delete 1ffg0oo_2" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'images');


SELECT cron.schedule(
         'check_expire_date',
         '0 0 * * *',
         $$SELECT update_registration_status();$$
       );
