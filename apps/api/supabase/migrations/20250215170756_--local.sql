set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.generate_group_stage_matches(p_tournament_id uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
  team_a           UUID;
  team_c           UUID;
  team_b           UUID;
  team_d           UUID;
  start_time       TIME := '08:00';
  interval_minutes INT  := 15;
BEGIN
  -- LOOP through Groups A vs C
  FOR team_a, team_c IN
    SELECT t1.id, t2.id
    FROM public.team t1
           JOIN public.team t2 ON t1.group_id <> t2.group_id
    WHERE t1.group_id IN (SELECT id FROM public.group WHERE name = 'Gruppe A' AND tournament_id = p_tournament_id)
      AND t2.group_id IN (SELECT id FROM public.group WHERE name = 'Gruppe C' AND tournament_id = p_tournament_id)
    LOOP
      INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
      VALUES (p_tournament_id, team_a, team_c, start_time, 'Gruppenphase');
      start_time := start_time + (interval_minutes || ' minutes')::INTERVAL;
    END LOOP;

  -- LOOP through Groups B vs D
  FOR team_b, team_d IN
    SELECT t1.id, t2.id
    FROM public.team t1
           JOIN public.team t2 ON t1.group_id <> t2.group_id
    WHERE t1.group_id IN (SELECT id FROM public.group WHERE name = 'Gruppe B' AND tournament_id = p_tournament_id)
      AND t2.group_id IN (SELECT id FROM public.group WHERE name = 'Gruppe D' AND tournament_id = p_tournament_id)
    LOOP
      INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
      VALUES (p_tournament_id, team_b, team_d, start_time, 'Gruppenphase');
      start_time := start_time + (interval_minutes || ' minutes')::INTERVAL;
    END LOOP;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.generate_group_stage_matches(p_tournament_id uuid, p_start_time time without time zone)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
  team_a           UUID;
  team_b           UUID;
  grp_id           UUID; 
  start_time       TIME := p_start_time;
  interval_minutes INT  := 15;
BEGIN
  -- Loop through each group
  FOR grp_id IN
    SELECT id FROM public.group WHERE tournament_id = p_tournament_id
    LOOP
      -- Generate round-robin matches within the same group
      FOR team_a, team_b IN
        SELECT t1.id, t2.id
        FROM public.team t1
               JOIN public.team t2 ON t1.id < t2.id -- Ensures unique matches
        WHERE t1.group_id = grp_id
          AND t2.group_id = grp_id -- Use "grp_id" instead of "group_id"
        LOOP
          INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
          VALUES (p_tournament_id, team_a, team_b, start_time, 'Gruppenphase');

          start_time := start_time + (interval_minutes || ' minutes')::INTERVAL;
        END LOOP;
    END LOOP;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.generate_group_stage_matches(p_tournament_id uuid, p_start_time_ac time without time zone, p_start_time_bd time without time zone)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
  team_a           UUID;
  team_b           UUID;
  grp_id           UUID;
  start_time_ac    TIME := p_start_time_ac;
  start_time_bd    TIME := p_start_time_bd;
  interval_minutes INT  := 12;
BEGIN
  -- Loop through each group
  FOR grp_id IN
    SELECT id FROM public.group WHERE tournament_id = p_tournament_id
    LOOP
      -- Determine if this group is A/C or B/D based on group name
      IF grp_id IN
         (SELECT id FROM public.group WHERE name IN ('Gruppe A', 'Gruppe C') AND tournament_id = p_tournament_id) THEN
        -- Round-robin for Groups A & C (parallel matches)
        FOR team_a, team_b IN
          SELECT t1.id, t2.id
          FROM public.team t1
                 JOIN public.team t2 ON t1.id < t2.id
          WHERE t1.group_id = grp_id
            AND t2.group_id = grp_id
          LOOP
            INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
            VALUES (p_tournament_id, team_a, team_b, start_time_ac, 'Gruppenphase');

            start_time_ac := start_time_ac + (interval_minutes || ' minutes')::INTERVAL;
          END LOOP;
      ELSE
        -- Round-robin for Groups B & D (parallel matches)
        FOR team_a, team_b IN
          SELECT t1.id, t2.id
          FROM public.team t1
                 JOIN public.team t2 ON t1.id < t2.id
          WHERE t1.group_id = grp_id
            AND t2.group_id = grp_id
          LOOP
            INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
            VALUES (p_tournament_id, team_a, team_b, start_time_bd, 'Gruppenphase');

            start_time_bd := start_time_bd + (interval_minutes || ' minutes')::INTERVAL;
          END LOOP;
      END IF;
    END LOOP;
END;
$function$
;

create or replace view "public"."team_standings" as  SELECT t.id AS team_id,
    t.name AS team_name,
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
  GROUP BY t.id, t.name
  ORDER BY COALESCE(sum(
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


create policy "authenticated can create"
on "public"."match"
as permissive
for insert
to authenticated
with check (true);


create policy "authenticated can delete"
on "public"."player"
as permissive
for delete
to authenticated
using (true);


create policy "authenticated can update"
on "public"."player"
as permissive
for update
to authenticated
using (true);



