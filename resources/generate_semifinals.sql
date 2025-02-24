CREATE OR REPLACE FUNCTION generate_semifinals(
  p_tournament_id UUID,
  p_start_time TIME,
  p_interval_minutes INT
)
  RETURNS VOID AS
$$
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
$$ LANGUAGE plpgsql;

-- Trigger to generate semi-finals after quarter-final results
CREATE OR REPLACE FUNCTION trigger_generate_semifinals()
  RETURNS TRIGGER AS
$$
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
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE OR REPLACE TRIGGER trigger_quarterfinal_results
  AFTER INSERT OR UPDATE
  ON public.result
  FOR EACH ROW
EXECUTE FUNCTION trigger_generate_semifinals();

