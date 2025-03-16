-- this function reverts a tournament to the group phase, development use only.

CREATE OR REPLACE FUNCTION revert_tournament_to_group_phase(p_tournament_id UUID)
  RETURNS VOID AS
$$
DECLARE
  v_count INT;
BEGIN
  SELECT COUNT(*) INTO v_count FROM public.tournament WHERE id = p_tournament_id;
  IF v_count = 0 THEN
    RAISE EXCEPTION 'Tournament with ID % does not exist', p_tournament_id;
  END IF;

  DELETE FROM public.tournament_result
  WHERE tournament_id = p_tournament_id;

  DELETE FROM public.result
  WHERE match_id IN (
    SELECT id FROM public.match
    WHERE tournament_id = p_tournament_id
    AND round IN ('Viertelfinale', 'Semifinale', 'Finale', 'Kleines Finale')
  );

  DELETE FROM public.match
  WHERE tournament_id = p_tournament_id
  AND round IN ('Viertelfinale', 'Semifinale', 'Finale', 'Kleines Finale');

  UPDATE public.match
  SET is_live = false
  WHERE tournament_id = p_tournament_id
  AND round = 'Gruppenphase';

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
$$ LANGUAGE plpgsql;
