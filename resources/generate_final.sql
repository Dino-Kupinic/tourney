CREATE OR REPLACE FUNCTION generate_final(
  p_tournament_id UUID,
  p_start_time TIME,
  p_interval_minutes INT
)
  RETURNS VOID AS
$$
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
  CREATE TEMP TABLE semifinal_results AS
  SELECT m.id  AS match_id,
         CASE
           WHEN r.winner_id IS NOT NULL THEN r.winner_id
           WHEN r.team1_score > r.team2_score THEN m.team1_id
           WHEN r.team2_score > r.team1_score THEN m.team2_id
           END AS winner_id,
         CASE
           WHEN r.winner_id IS NOT NULL THEN
             CASE
               WHEN r.winner_id = m.team1_id THEN m.team2_id
               ELSE m.team1_id
               END
           WHEN r.team1_score > r.team2_score THEN m.team2_id
           WHEN r.team2_score > r.team1_score THEN m.team1_id
           END AS loser_id
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = p_tournament_id
    AND m.round = 'Semifinale';

  OPEN final_teams FOR
    SELECT s1.winner_id AS team1,
           s2.winner_id AS team2
    FROM semifinal_results s1
           JOIN semifinal_results s2 ON s1.match_id < s2.match_id;

  OPEN third_place_teams FOR
    SELECT s1.loser_id AS team3,
           s2.loser_id AS team4
    FROM semifinal_results s1
           JOIN semifinal_results s2 ON s1.match_id < s2.match_id;

  FETCH final_teams INTO team1, team2;
  IF FOUND THEN
    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time + interval_minutes, 'Finale');
  END IF;

  FETCH third_place_teams INTO team3, team4;
  IF FOUND THEN
    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team3, team4, start_time, 'Kleines Finale');
  END IF;

  CLOSE final_teams;
  CLOSE third_place_teams;
  DROP TABLE semifinal_results;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trigger_generate_final()
  RETURNS TRIGGER AS
$$
DECLARE
  v_tournament_id            UUID;
  v_round                    TEXT;
  semifinal_count            INT;
  semifinal_results_count    INT;
  existing_final_count       INT;
  existing_third_place_count INT;
  v_knockout_interval        INT;
BEGIN
  SELECT m.tournament_id, m.round
  INTO v_tournament_id, v_round
  FROM public.match m
  WHERE m.id = NEW.match_id;

  IF v_tournament_id IS NULL OR v_round <> 'Semifinale' THEN
    RETURN NEW;
  END IF;

  SELECT COUNT(*)
  INTO semifinal_count
  FROM public.match
  WHERE tournament_id = v_tournament_id
    AND round = 'Semifinale';

  SELECT COUNT(*)
  INTO semifinal_results_count
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = v_tournament_id
    AND m.round = 'Semifinale'
    AND r.id IS NOT NULL;

  SELECT COUNT(*)
  INTO existing_final_count
  FROM public.match
  WHERE tournament_id = v_tournament_id
    AND round = 'Finale';

  SELECT COUNT(*)
  INTO existing_third_place_count
  FROM public.match
  WHERE tournament_id = v_tournament_id
    AND round = 'Kleines Finale';

  IF semifinal_count = semifinal_results_count AND existing_final_count = 0 AND existing_third_place_count = 0 THEN
    SELECT knockout_interval
    INTO v_knockout_interval
    FROM public.tournament
    WHERE id = v_tournament_id;

    PERFORM generate_final(
      v_tournament_id,
      NOW()::TIME,
      COALESCE(v_knockout_interval, 15)
            );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_semifinal_results
  AFTER INSERT OR UPDATE
  ON public.result
  FOR EACH ROW
EXECUTE FUNCTION trigger_generate_final();
