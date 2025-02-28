drop function if exists "public"."generate_group_stage_matches"(p_tournament_id uuid);

drop function if exists "public"."generate_group_stage_matches"(p_tournament_id uuid, p_start_time time without time zone);

drop function if exists "public"."generate_group_stage_matches"(p_tournament_id uuid, p_start_time_ac time without time zone, p_start_time_bd time without time zone);

drop view if exists "public"."matches_status";

alter type "public"."tournament_phase" rename to "tournament_phase__old_version_to_be_dropped";

create type "public"."tournament_phase" as enum ('Gruppenphase', 'Viertelfinale', 'Semifinale', 'Finale', 'Kleines Finale');

create table "public"."tournament_result" (
    "tournament_id" uuid not null,
    "team_id" uuid not null,
    "position" integer not null
);


alter table "public"."tournament_result" enable row level security;

alter table "public"."match" alter column round type "public"."tournament_phase" using round::text::"public"."tournament_phase";

drop type "public"."tournament_phase__old_version_to_be_dropped";

CREATE UNIQUE INDEX tournament_results_pkey ON public.tournament_result USING btree (tournament_id, team_id);

alter table "public"."tournament_result" add constraint "tournament_results_pkey" PRIMARY KEY using index "tournament_results_pkey";

alter table "public"."tournament_result" add constraint "tournament_results_team_id_fkey" FOREIGN KEY (team_id) REFERENCES team(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."tournament_result" validate constraint "tournament_results_team_id_fkey";

alter table "public"."tournament_result" add constraint "tournament_results_tournament_id_fkey" FOREIGN KEY (tournament_id) REFERENCES tournament(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."tournament_result" validate constraint "tournament_results_tournament_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.generate_final(p_tournament_id uuid, p_start_time time without time zone, p_interval_minutes integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
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
  -- Fetch the winners and losers of the semi-finals
  CREATE TEMP TABLE semifinal_results AS
  SELECT m.id  AS match_id,
         CASE
           WHEN r.winner_id IS NOT NULL THEN r.winner_id
           WHEN r.team1_score > r.team2_score THEN m.team1_id
           WHEN r.team2_score > r.team1_score THEN m.team2_id
           ELSE NULL -- Handle draws (if applicable)
           END AS winner_id,
         CASE
           WHEN r.winner_id IS NOT NULL THEN
             CASE
               WHEN r.winner_id = m.team1_id THEN m.team2_id
               ELSE m.team1_id
               END
           WHEN r.team1_score > r.team2_score THEN m.team2_id
           WHEN r.team2_score > r.team1_score THEN m.team1_id
           ELSE NULL -- Handle draws (if applicable)
           END AS loser_id
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = p_tournament_id
    AND m.round = 'Semifinale';

  -- Pair the semi-final winners for the final
  OPEN final_teams FOR
    SELECT s1.winner_id AS team1,
           s2.winner_id AS team2
    FROM semifinal_results s1
           JOIN semifinal_results s2 ON s1.match_id < s2.match_id;

  -- Pair the semi-final losers for the 3rd place match
  OPEN third_place_teams FOR
    SELECT s1.loser_id AS team3,
           s2.loser_id AS team4
    FROM semifinal_results s1
           JOIN semifinal_results s2 ON s1.match_id < s2.match_id;

  -- Insert final match
  FETCH final_teams INTO team1, team2;
  IF FOUND THEN
    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Finale');
  END IF;

  -- Insert 3rd place match
  FETCH third_place_teams INTO team3, team4;
  IF FOUND THEN
    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team3, team4, start_time + interval_minutes, 'Kleines Finale');
  END IF;

  -- Clean up temporary table and cursors
  CLOSE final_teams;
  CLOSE third_place_teams;
  DROP TABLE semifinal_results;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.generate_group_stage_matches(p_tournament_id uuid, p_start_time time without time zone, p_interval_minutes integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
  team1 UUID;
  team2 UUID;
  start_time TIME := p_start_time;
  interval_minutes INTERVAL := (p_interval_minutes || ' minutes')::INTERVAL;
  group_a_matches REFCURSOR;
  group_c_matches REFCURSOR;
  group_b_matches REFCURSOR;
  group_d_matches REFCURSOR;
BEGIN
  -- Open cursors for each group's matches
  OPEN group_a_matches FOR
    SELECT t1.id AS team1, t2.id AS team2
    FROM public.team t1
    JOIN public.team t2 ON t1.group_id = t2.group_id AND t1.id < t2.id
    JOIN public."group" g ON t1.group_id = g.id
    WHERE g.tournament_id = p_tournament_id AND g.name = 'Gruppe A';

  OPEN group_c_matches FOR
    SELECT t1.id AS team1, t2.id AS team2
    FROM public.team t1
    JOIN public.team t2 ON t1.group_id = t2.group_id AND t1.id < t2.id
    JOIN public."group" g ON t1.group_id = g.id
    WHERE g.tournament_id = p_tournament_id AND g.name = 'Gruppe C';

  OPEN group_b_matches FOR
    SELECT t1.id AS team1, t2.id AS team2
    FROM public.team t1
    JOIN public.team t2 ON t1.group_id = t2.group_id AND t1.id < t2.id
    JOIN public."group" g ON t1.group_id = g.id
    WHERE g.tournament_id = p_tournament_id AND g.name = 'Gruppe B';

  OPEN group_d_matches FOR
    SELECT t1.id AS team1, t2.id AS team2
    FROM public.team t1
    JOIN public.team t2 ON t1.group_id = t2.group_id AND t1.id < t2.id
    JOIN public."group" g ON t1.group_id = g.id
    WHERE g.tournament_id = p_tournament_id AND g.name = 'Gruppe D';

  -- Generate matches in parallel: A&C at the same time, B&D at the same time
  LOOP
    -- Fetch the next match for Group A
    FETCH group_a_matches INTO team1, team2;
    EXIT WHEN NOT FOUND;

    -- Insert the match for Group A
    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Gruppenphase');

    -- Fetch the next match for Group C
    FETCH group_c_matches INTO team1, team2;
    EXIT WHEN NOT FOUND;

    -- Insert the match for Group C (same start time as Group A)
    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Gruppenphase');

    -- Increment the start time for the next round
    start_time := start_time + interval_minutes;

    -- Fetch the next match for Group B
    FETCH group_b_matches INTO team1, team2;
    EXIT WHEN NOT FOUND;

    -- Insert the match for Group B
    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Gruppenphase');

    -- Fetch the next match for Group D
    FETCH group_d_matches INTO team1, team2;
    EXIT WHEN NOT FOUND;

    -- Insert the match for Group D (same start time as Group B)
    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Gruppenphase');

    -- Increment the start time for the next round
    start_time := start_time + interval_minutes;
  END LOOP;

  -- Close cursors
  CLOSE group_a_matches;
  CLOSE group_c_matches;
  CLOSE group_b_matches;
  CLOSE group_d_matches;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.generate_quarterfinals(p_tournament_id uuid, p_start_time time without time zone, p_interval_minutes integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
  team1              UUID;
  team2              UUID;
  start_time         TIME     := p_start_time;
  interval_minutes   INTERVAL := (p_interval_minutes || ' minutes')::INTERVAL;
  quarterfinal_teams REFCURSOR;
BEGIN
  -- Step 1: Identify the top 2 teams from each group
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

  -- Step 2: Generate quarter-final matches
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

  -- Insert quarter-final matches
  LOOP
    FETCH quarterfinal_teams INTO team1, team2;
    EXIT WHEN NOT FOUND;

    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Viertelfinale');

    start_time := start_time + interval_minutes;
  END LOOP;

  -- Clean up temporary table
  CLOSE quarterfinal_teams;
  DROP TABLE top_teams;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.generate_semifinals(p_tournament_id uuid, p_start_time time without time zone, p_interval_minutes integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
  team_ids         UUID[];
  start_time       TIME     := p_start_time;
  interval_minutes INTERVAL := (p_interval_minutes || ' minutes')::INTERVAL;
BEGIN
  -- Fetch the winners of the quarter-finals
  SELECT ARRAY_AGG(winner_id ORDER BY match_id)
  INTO team_ids
  FROM (SELECT m.id  AS match_id,
               CASE
                 WHEN r.winner_id IS NOT NULL THEN r.winner_id
                 WHEN r.team1_score > r.team2_score THEN m.team1_id
                 WHEN r.team2_score > r.team1_score THEN m.team2_id
                 ELSE NULL -- Handle draws (if applicable)
                 END AS winner_id
        FROM public.match m
               LEFT JOIN public.result r ON m.id = r.match_id
        WHERE m.tournament_id = p_tournament_id
          AND m.round = 'Viertelfinale') AS quarterfinal_winners
  WHERE winner_id IS NOT NULL;
  -- Ensure NULL values are removed

  -- Ensure we have exactly 4 winners
  IF array_length(team_ids, 1) != 4 THEN
    RAISE NOTICE 'Invalid number of quarter-final winners: %', array_length(team_ids, 1);
    RETURN;
  END IF;

  -- Insert two semi-final matches with correct pairing
  INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
  VALUES (p_tournament_id, team_ids[1], team_ids[3], start_time, 'Semifinale'),
         (p_tournament_id, team_ids[2], team_ids[4], start_time + interval_minutes, 'Semifinale');

END;
$function$
;

CREATE OR REPLACE FUNCTION public.record_match_result(p_match_id uuid, p_team1_score smallint, p_team2_score smallint)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
  winner UUID;
BEGIN
  -- Determine the winner
  IF p_team1_score > p_team2_score THEN
    SELECT team1_id INTO winner FROM public.match WHERE id = p_match_id;
  ELSIF p_team1_score < p_team2_score THEN
    SELECT team2_id INTO winner FROM public.match WHERE id = p_match_id;
  ELSE
    winner := NULL; -- Draw (no winner)
  END IF;

  -- Insert result
  INSERT INTO public.result (match_id, team1_score, team2_score, winner_id)
  VALUES (p_match_id, p_team1_score, p_team2_score, winner);

END;
$function$
;

CREATE OR REPLACE FUNCTION public.trigger_generate_final()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  v_tournament_id            UUID;
  v_round                    TEXT;
  semifinal_count            INT;
  semifinal_results_count    INT;
  existing_final_count       INT;
  existing_third_place_count INT;
BEGIN
  -- Retrieve tournament_id and round from the match table
  SELECT m.tournament_id, m.round
  INTO v_tournament_id, v_round
  FROM public.match m
  WHERE m.id = NEW.match_id;

  -- Ensure we have a valid tournament ID and that this match is from the semi-finals
  IF v_tournament_id IS NULL OR v_round <> 'Semifinale' THEN
    RETURN NEW;
  END IF;

  -- Count the total number of semi-final matches
  SELECT COUNT(*)
  INTO semifinal_count
  FROM public.match
  WHERE tournament_id = v_tournament_id
    AND round = 'Semifinale';

  -- Count the number of semi-final matches with results
  SELECT COUNT(*)
  INTO semifinal_results_count
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = v_tournament_id
    AND m.round = 'Semifinale'
    AND r.id IS NOT NULL;

  -- Check if a final match has already been generated
  SELECT COUNT(*)
  INTO existing_final_count
  FROM public.match
  WHERE tournament_id = v_tournament_id
    AND round = 'Finale';

  -- Check if a 3rd place match has already been generated
  SELECT COUNT(*)
  INTO existing_third_place_count
  FROM public.match
  WHERE tournament_id = v_tournament_id
    AND round = 'Kleines Finale';

  -- If all semi-final results are available and no final or 3rd place match exists, generate them
  IF semifinal_count = semifinal_results_count AND existing_final_count = 0 AND existing_third_place_count = 0 THEN
    PERFORM generate_final(
      v_tournament_id,
      NOW()::TIME, -- Use the current time as the start time
      15 -- Interval in minutes (used for 3rd place match)
            );
  END IF;

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.trigger_generate_quarterfinals()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  v_tournament_id           UUID;
  v_round                   TEXT;
  group_stage_count         INT;
  group_stage_results_count INT;
BEGIN
  -- Retrieve tournament_id and round from the match table
  SELECT m.tournament_id, m.round
  INTO v_tournament_id, v_round
  FROM public.match m
  WHERE m.id = NEW.match_id;

  -- Ensure we have a valid tournament ID and that this match is from the group stage
  IF v_tournament_id IS NULL OR v_round <> 'Gruppenphase' THEN
    RETURN NEW;
  END IF;

  -- Count the total number of group stage matches
  SELECT COUNT(*)
  INTO group_stage_count
  FROM public.match
  WHERE tournament_id = v_tournament_id
    AND round = 'Gruppenphase';

  -- Count the number of group stage matches with results
  SELECT COUNT(*)
  INTO group_stage_results_count
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = v_tournament_id
    AND m.round = 'Gruppenphase'
    AND r.id IS NOT NULL;

  -- If all group stage results are available, generate quarter-finals
  IF group_stage_count = group_stage_results_count THEN
    PERFORM generate_quarterfinals(
      v_tournament_id,
      NOW()::TIME, -- Use the current time as the start time
      15 -- Interval in minutes between matches
    );
  END IF;

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.trigger_generate_semifinals()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  v_tournament_id            UUID;
  v_round                    TEXT;
  quarterfinal_count         INT;
  quarterfinal_results_count INT;
BEGIN
  -- Retrieve tournament_id and round from the match table
  SELECT m.tournament_id, m.round
  INTO v_tournament_id, v_round
  FROM public.match m
  WHERE m.id = NEW.match_id;

  -- Ensure we have a valid tournament ID and that this match is from the quarter-finals
  IF v_tournament_id IS NULL OR v_round <> 'Viertelfinale' THEN
    RETURN NEW;
  END IF;

  -- Count the total number of quarter-final matches
  SELECT COUNT(*)
  INTO quarterfinal_count
  FROM public.match
  WHERE tournament_id = v_tournament_id
    AND round = 'Viertelfinale';

  -- Count the number of quarter-final matches with results
  SELECT COUNT(*)
  INTO quarterfinal_results_count
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = v_tournament_id
    AND m.round = 'Viertelfinale'
    AND r.id IS NOT NULL;

  -- If all quarter-final results are available, generate semi-finals
  IF quarterfinal_count = quarterfinal_results_count THEN
    PERFORM generate_semifinals(
      v_tournament_id,
      NOW()::TIME, -- Use the current time as the start time
      15 -- Interval in minutes between matches
            );
  END IF;

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.trigger_update_tournament_results()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  v_tournament_id           UUID;
  v_round                   TEXT;
  finale_results_count      INT;
  third_place_results_count INT;
BEGIN
  -- Retrieve tournament_id and round from the match table
  SELECT m.tournament_id, m.round
  INTO v_tournament_id, v_round
  FROM public.match m
  WHERE m.id = NEW.match_id;

  -- Ensure we have a valid tournament ID and that this match is from the finale or 3rd place match
  IF v_tournament_id IS NULL OR (v_round <> 'Finale' AND v_round <> 'Kleines Finale') THEN
    RETURN NEW;
  END IF;

  -- Count the number of results for the finale and 3rd place match
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

  -- If both the finale and 3rd place match have results, update the tournament results
  IF finale_results_count = 1 AND third_place_results_count = 1 THEN
    PERFORM update_tournament_results(v_tournament_id);
  END IF;

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_tournament_results(p_tournament_id uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
  final_winner_id       UUID;
  final_loser_id        UUID;
  third_place_winner_id UUID;
  third_place_loser_id  UUID;
BEGIN
  -- Get the winner and loser of the final
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

  -- Get the winner and loser of the 3rd place match
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

  -- Insert final rankings into tournament_results
  INSERT INTO public.tournament_result (tournament_id, team_id, position)
  VALUES (p_tournament_id, final_winner_id, 1),       -- Champion
         (p_tournament_id, final_loser_id, 2),        -- Runner-up
         (p_tournament_id, third_place_winner_id, 3), -- 3rd place
         (p_tournament_id, third_place_loser_id, 4); -- 4th place
END;
$function$
;

create or replace view "public"."matches_status" as  SELECT m.id AS match_id,
    m.tournament_id,
    m.team1_id,
    t1.name AS team1_name,
    m.team2_id,
    t2.name AS team2_name,
    m.start_time,
    m.end_time,
    m.round,
        CASE
            WHEN (r.id IS NOT NULL) THEN 'completed'::text
            WHEN m.is_live THEN 'live'::text
            ELSE 'upcoming'::text
        END AS status
   FROM (((match m
     LEFT JOIN result r ON ((r.match_id = m.id)))
     LEFT JOIN team t1 ON ((m.team1_id = t1.id)))
     LEFT JOIN team t2 ON ((m.team2_id = t2.id)))
  ORDER BY m.start_time;


grant delete on table "public"."tournament_result" to "anon";

grant insert on table "public"."tournament_result" to "anon";

grant references on table "public"."tournament_result" to "anon";

grant select on table "public"."tournament_result" to "anon";

grant trigger on table "public"."tournament_result" to "anon";

grant truncate on table "public"."tournament_result" to "anon";

grant update on table "public"."tournament_result" to "anon";

grant delete on table "public"."tournament_result" to "authenticated";

grant insert on table "public"."tournament_result" to "authenticated";

grant references on table "public"."tournament_result" to "authenticated";

grant select on table "public"."tournament_result" to "authenticated";

grant trigger on table "public"."tournament_result" to "authenticated";

grant truncate on table "public"."tournament_result" to "authenticated";

grant update on table "public"."tournament_result" to "authenticated";

grant delete on table "public"."tournament_result" to "service_role";

grant insert on table "public"."tournament_result" to "service_role";

grant references on table "public"."tournament_result" to "service_role";

grant select on table "public"."tournament_result" to "service_role";

grant trigger on table "public"."tournament_result" to "service_role";

grant truncate on table "public"."tournament_result" to "service_role";

grant update on table "public"."tournament_result" to "service_role";

create policy "authenticated can insert"
on "public"."result"
as permissive
for insert
to authenticated
with check (true);


create policy "Enable insert for authenticated users only"
on "public"."tournament_result"
as permissive
for insert
to authenticated
with check (true);


create policy "Enable read access for all users"
on "public"."tournament_result"
as permissive
for select
to public
using (true);


CREATE TRIGGER trigger_final_results AFTER INSERT OR UPDATE ON public.result FOR EACH ROW EXECUTE FUNCTION trigger_update_tournament_results();

CREATE TRIGGER trigger_group_stage_results AFTER INSERT OR UPDATE ON public.result FOR EACH ROW EXECUTE FUNCTION trigger_generate_quarterfinals();

CREATE TRIGGER trigger_quarterfinal_results AFTER INSERT OR UPDATE ON public.result FOR EACH ROW EXECUTE FUNCTION trigger_generate_semifinals();

CREATE TRIGGER trigger_semifinal_results AFTER INSERT OR UPDATE ON public.result FOR EACH ROW EXECUTE FUNCTION trigger_generate_final();


