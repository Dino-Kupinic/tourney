alter table "public"."tournament" add column "knockout_interval" smallint default '15'::smallint;

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
$function$
;


