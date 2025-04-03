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
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trigger_generate_quarterfinals()
  RETURNS TRIGGER AS
$$
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
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_group_stage_results
  AFTER INSERT OR UPDATE
  ON public.result
  FOR EACH ROW
EXECUTE FUNCTION trigger_generate_quarterfinals();
