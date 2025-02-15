CREATE OR REPLACE FUNCTION check_and_advance_knockouts()
  RETURNS TRIGGER AS
$$
DECLARE
  total_group_matches     INT;
  completed_group_matches INT;
  tournament_uuid         UUID;
BEGIN
  -- Get tournament ID from the match
  SELECT tournament_id
  INTO tournament_uuid
  FROM public.match
  WHERE id = NEW.match_id;

  -- Count total group stage matches
  SELECT COUNT(*)
  INTO total_group_matches
  FROM public.match
  WHERE tournament_id = tournament_uuid
    AND round = 'Group Phase';

  -- Count completed group stage matches
  SELECT COUNT(*)
  INTO completed_group_matches
  FROM public.result r
         JOIN public.match m ON r.match_id = m.id
  WHERE m.tournament_id = tournament_uuid
    AND m.round = 'Group Phase';

  -- If all group matches are done, trigger knockout stage
  IF completed_group_matches = total_group_matches THEN
    PERFORM advance_teams_to_knockouts(tournament_uuid);
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- create trigger

CREATE TRIGGER trigger_advance_knockouts
  AFTER INSERT
  ON public.result
  FOR EACH ROW
EXECUTE FUNCTION check_and_advance_knockouts();
