CREATE OR REPLACE FUNCTION generate_final(
  p_tournament_id UUID,
  p_start_time TIME,
  p_interval_minutes INT
)
  RETURNS VOID AS
$$
DECLARE
  team1            UUID;
  team2            UUID;
  start_time       TIME     := p_start_time;
  interval_minutes INTERVAL := (p_interval_minutes || ' minutes')::INTERVAL;
  final_teams      REFCURSOR;
BEGIN
  -- Fetch the winners of the semi-finals
  CREATE TEMP TABLE semifinal_winners AS
  SELECT m.id  AS match_id,
         CASE
           WHEN r.winner_id IS NOT NULL THEN r.winner_id
           WHEN r.team1_score > r.team2_score THEN m.team1_id
           WHEN r.team2_score > r.team1_score THEN m.team2_id
           ELSE NULL -- Handle draws (if applicable)
           END AS winner_id
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = p_tournament_id
    AND m.round = 'Semifinale';

  -- Pair the semi-final winners for the final
  OPEN final_teams FOR
    SELECT s1.winner_id AS team1,
           s2.winner_id AS team2
    FROM semifinal_winners s1
           JOIN semifinal_winners s2 ON s1.match_id < s2.match_id;

  -- Insert final match
  FETCH final_teams INTO team1, team2;
  IF FOUND THEN
    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Finale');
  END IF;

  -- Clean up temporary table
  CLOSE final_teams;
  DROP TABLE semifinal_winners;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trigger_generate_final()
  RETURNS TRIGGER AS
$$
DECLARE
  v_tournament_id         UUID;
  v_round                 TEXT;
  semifinal_count         INT;
  semifinal_results_count INT;
  existing_final_count    INT;
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

  -- If all semi-final results are available and no final exists, generate the final
  IF semifinal_count = semifinal_results_count AND existing_final_count = 0 THEN
    PERFORM generate_final(
      v_tournament_id,
      NOW()::TIME, -- Use the current time as the start time
      15 -- Interval in minutes (not used for final)
            );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE OR REPLACE TRIGGER trigger_semifinal_results
  AFTER INSERT OR UPDATE
  ON public.result
  FOR EACH ROW
EXECUTE FUNCTION trigger_generate_final();
