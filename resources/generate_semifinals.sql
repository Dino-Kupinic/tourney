CREATE OR REPLACE FUNCTION generate_semifinals(
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
  semifinal_teams  REFCURSOR;
BEGIN
  -- Fetch the winners of the quarter-finals
  CREATE TEMP TABLE quarterfinal_winners AS
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
    AND m.round = 'Viertelfinale';

  -- Pair the quarter-final winners for semi-finals
  OPEN semifinal_teams FOR
    SELECT q1.winner_id AS team1,
           q2.winner_id AS team2
    FROM quarterfinal_winners q1
           JOIN quarterfinal_winners q2 ON q1.match_id < q2.match_id
    LIMIT 2;

  -- Insert semi-final matches
  LOOP
    FETCH semifinal_teams INTO team1, team2;
    EXIT WHEN NOT FOUND;

    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Semifinale');

    start_time := start_time + interval_minutes;
  END LOOP;

  -- Clean up temporary table
  DROP TABLE quarterfinal_winners;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trigger_generate_semifinals()
  RETURNS TRIGGER AS
$$
DECLARE
  tournament_id              UUID;
  quarterfinal_count         INT;
  quarterfinal_results_count INT;
BEGIN
  -- Get the tournament_id of the match being updated
  tournament_id := NEW.match_id;

  -- Count the total number of quarter-final matches
  SELECT COUNT(*)
  INTO quarterfinal_count
  FROM public.match
  WHERE tournament_id = tournament_id
    AND round = 'Viertelfinale';

  -- Count the number of quarter-final matches with results
  SELECT COUNT(*)
  INTO quarterfinal_results_count
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = tournament_id
    AND m.round = 'Viertelfinale'
    AND r.id IS NOT NULL;

  -- If all quarter-final results are available, generate semi-finals
  IF quarterfinal_count = quarterfinal_results_count THEN
    PERFORM generate_semifinals(
      tournament_id,
      NOW()::TIME, -- Use the current time as the start time
      30 -- Interval in minutes between matches
            );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER trigger_quarterfinal_results
  AFTER INSERT OR UPDATE
  ON public.result
  FOR EACH ROW
EXECUTE FUNCTION trigger_generate_semifinals();
