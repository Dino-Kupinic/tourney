CREATE OR REPLACE FUNCTION generate_quarterfinals(
  p_tournament_id UUID,
  p_start_time TIME,
  p_interval_minutes INT
)
  RETURNS VOID AS
$$
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
                               t.tournament_id,
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
         goals_scored
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
    VALUES (p_tournament_id, team1, team2, start_time, 'Quarter-final');

    start_time := start_time + interval_minutes;
  END LOOP;

  -- Clean up temporary table
  DROP TABLE top_teams;
END;
$$ LANGUAGE plpgsql;

-- Trigger to generate quarter-finals after group stage results
CREATE OR REPLACE FUNCTION trigger_generate_quarterfinals()
  RETURNS TRIGGER AS
$$
DECLARE
  tournament_id             UUID;
  group_stage_count         INT;
  group_stage_results_count INT;
BEGIN
  -- Get the tournament_id of the match being updated
  tournament_id := NEW.match_id;

  -- Count the total number of group stage matches
  SELECT COUNT(*)
  INTO group_stage_count
  FROM public.match
  WHERE tournament_id = tournament_id
    AND round = 'Gruppenphase';
  -- Assuming 'Gruppenphase' is the round name for group stage

  -- Count the number of group stage matches with results
  SELECT COUNT(*)
  INTO group_stage_results_count
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = tournament_id
    AND m.round = 'Gruppenphase'
    AND r.id IS NOT NULL;

  -- If all group stage results are available, generate quarter-finals
  IF group_stage_count = group_stage_results_count THEN
    PERFORM generate_quarterfinals(
      tournament_id,
      NOW()::TIME, -- Use the current time as the start time
      12 -- Interval in minutes between matches
            );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE OR REPLACE TRIGGER trigger_group_stage_results
  AFTER INSERT OR UPDATE
  ON public.result
  FOR EACH ROW
EXECUTE FUNCTION trigger_generate_quarterfinals();
