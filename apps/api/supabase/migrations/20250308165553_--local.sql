set check_function_bodies = off;

create or replace view "public"."group_standings" as  SELECT t.id AS team_id,
    t.name AS team_name,
    t.tournament_id,
    t.group_id,
    COALESCE(sum(
        CASE
            WHEN (r.winner_id = t.id) THEN 3
            WHEN ((r.winner_id IS NULL) AND (r.id IS NOT NULL)) THEN 1
            ELSE 0
        END), (0)::bigint) AS points,
    COALESCE(count(
        CASE
            WHEN (r.winner_id = t.id) THEN 1
            ELSE NULL::integer
        END), (0)::bigint) AS wins,
    COALESCE(count(
        CASE
            WHEN ((r.winner_id IS NULL) AND (r.id IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END), (0)::bigint) AS draws,
    COALESCE(count(
        CASE
            WHEN ((r.winner_id IS NOT NULL) AND (r.winner_id <> t.id)) THEN 1
            ELSE NULL::integer
        END), (0)::bigint) AS losses,
    COALESCE(sum(
        CASE
            WHEN (m.team1_id = t.id) THEN r.team1_score
            ELSE r.team2_score
        END), (0)::bigint) AS goals_scored,
    COALESCE(sum(
        CASE
            WHEN (m.team1_id = t.id) THEN r.team2_score
            ELSE r.team1_score
        END), (0)::bigint) AS goals_conceded,
    (COALESCE(sum(
        CASE
            WHEN (m.team1_id = t.id) THEN r.team1_score
            ELSE r.team2_score
        END), (0)::bigint) - COALESCE(sum(
        CASE
            WHEN (m.team1_id = t.id) THEN r.team2_score
            ELSE r.team1_score
        END), (0)::bigint)) AS goal_difference
   FROM ((team t
     LEFT JOIN match m ON (((t.id = m.team1_id) OR (t.id = m.team2_id))))
     LEFT JOIN result r ON ((r.match_id = m.id)))
  WHERE (t.group_id IS NOT NULL)
  GROUP BY t.id, t.name, t.tournament_id, t.group_id
  ORDER BY t.group_id, COALESCE(sum(
        CASE
            WHEN (r.winner_id = t.id) THEN 3
            WHEN ((r.winner_id IS NULL) AND (r.id IS NOT NULL)) THEN 1
            ELSE 0
        END), (0)::bigint) DESC, (COALESCE(sum(
        CASE
            WHEN (m.team1_id = t.id) THEN r.team1_score
            ELSE r.team2_score
        END), (0)::bigint) - COALESCE(sum(
        CASE
            WHEN (m.team1_id = t.id) THEN r.team2_score
            ELSE r.team1_score
        END), (0)::bigint)) DESC, COALESCE(sum(
        CASE
            WHEN (m.team1_id = t.id) THEN r.team1_score
            ELSE r.team2_score
        END), (0)::bigint) DESC;


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
    VALUES (p_tournament_id, team1, team2, start_time + interval_minutes, 'Finale');
  END IF;

  -- Insert 3rd place match
  FETCH third_place_teams INTO team3, team4;
  IF FOUND THEN
    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team3, team4, start_time, 'Kleines Finale');
  END IF;

  -- Clean up temporary table and cursors
  CLOSE final_teams;
  CLOSE third_place_teams;
  DROP TABLE semifinal_results;
END;
$function$
;

create policy "authenticated can update "
on "public"."result"
as permissive
for update
to authenticated
using (true);



