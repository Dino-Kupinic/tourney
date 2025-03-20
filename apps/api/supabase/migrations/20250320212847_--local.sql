alter table "public"."match" drop constraint "match_tournament_id_fkey";

alter table "public"."team" drop constraint "team_registration_id_fkey";

CREATE INDEX group_tournament_id_idx ON public."group" USING btree (tournament_id);

CREATE INDEX match_start_time_idx ON public.match USING btree (start_time);

CREATE INDEX team_group_id_idx ON public.team USING btree (group_id);

CREATE INDEX tournament_result_position_idx ON public.tournament_result USING btree ("position");

CREATE INDEX tournament_result_tournament_id_idx ON public.tournament_result USING btree (tournament_id);

alter table "public"."match" add constraint "match_tournament_id_fkey" FOREIGN KEY (tournament_id) REFERENCES tournament(id) ON DELETE CASCADE not valid;

alter table "public"."match" validate constraint "match_tournament_id_fkey";

alter table "public"."team" add constraint "team_registration_id_fkey" FOREIGN KEY (registration_id) REFERENCES registration(id) ON DELETE CASCADE not valid;

alter table "public"."team" validate constraint "team_registration_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.revert_tournament_to_group_phase(p_tournament_id uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
  v_count INT;
BEGIN
  -- Check if tournament exists
  SELECT COUNT(*) INTO v_count FROM public.tournament WHERE id = p_tournament_id;
  IF v_count = 0 THEN
    RAISE EXCEPTION 'Tournament with ID % does not exist', p_tournament_id;
  END IF;

  -- Step 1: Delete tournament results (final standings)
  DELETE FROM public.tournament_result
  WHERE tournament_id = p_tournament_id;

  -- Step 2: Delete results for all knockout phase matches
  DELETE FROM public.result
  WHERE match_id IN (
    SELECT id FROM public.match
    WHERE tournament_id = p_tournament_id
    AND round IN ('Viertelfinale', 'Semifinale', 'Finale', 'Kleines Finale')
  );

  -- Step 3: Delete all knockout phase matches
  DELETE FROM public.match
  WHERE tournament_id = p_tournament_id
  AND round IN ('Viertelfinale', 'Semifinale', 'Finale', 'Kleines Finale');

  -- Step 4: Set all group phase matches to not live
  UPDATE public.match
  SET is_live = false
  WHERE tournament_id = p_tournament_id
  AND round = 'Gruppenphase';

  -- Step 5: Delete the result record of the last group phase match
  -- This ensures we're at the point where the last match is about to be completed
  WITH last_group_match AS (
    SELECT id
    FROM public.match
    WHERE tournament_id = p_tournament_id
    AND round = 'Gruppenphase'
    ORDER BY start_time DESC
    LIMIT 1
  )
  DELETE FROM public.result
  WHERE match_id IN (SELECT id FROM last_group_match);

  -- Step 6: Find the last group phase match and set it to live
  -- This simulates being at the last game of the group phase
  WITH last_group_match AS (
    SELECT id
    FROM public.match
    WHERE tournament_id = p_tournament_id
    AND round = 'Gruppenphase'
    ORDER BY start_time DESC
    LIMIT 1
  )
  UPDATE public.match
  SET is_live = true
  FROM last_group_match
  WHERE match.id = last_group_match.id;

  RAISE NOTICE 'Tournament % has been reverted to the group phase', p_tournament_id;
END;
$function$
;


