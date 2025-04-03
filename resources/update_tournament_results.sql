CREATE OR REPLACE FUNCTION update_tournament_results(p_tournament_id UUID)
  RETURNS VOID AS
$$
DECLARE
  final_winner_id       UUID;
  final_loser_id        UUID;
  third_place_winner_id UUID;
  third_place_loser_id  UUID;
BEGIN

  SELECT CASE
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
  INTO final_winner_id, final_loser_id
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = p_tournament_id
    AND m.round = 'Finale';


  SELECT CASE
           WHEN r.winner_id IS NOT NULL THEN r.winner_id
           WHEN r.team1_score > r.team2_score THEN m.team1_id
           WHEN r.team2_score > r.team1_score THEN m.team2_id
           ELSE NULL
           END AS winner_id,
         CASE
           WHEN r.winner_id IS NOT NULL THEN
             CASE
               WHEN r.winner_id = m.team1_id THEN m.team2_id
               ELSE m.team1_id
               END
           WHEN r.team1_score > r.team2_score THEN m.team2_id
           WHEN r.team2_score > r.team1_score THEN m.team1_id
           ELSE NULL
           END AS loser_id
  INTO third_place_winner_id, third_place_loser_id
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = p_tournament_id
    AND m.round = 'Kleines Finale';


  INSERT INTO public.tournament_result (tournament_id, team_id, position)
  VALUES (p_tournament_id, final_winner_id, 1),
         (p_tournament_id, final_loser_id, 2),
         (p_tournament_id, third_place_winner_id, 3),
         (p_tournament_id, third_place_loser_id, 4);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trigger_update_tournament_results()
  RETURNS TRIGGER AS
$$
DECLARE
  v_tournament_id           UUID;
  v_round                   TEXT;
  finale_results_count      INT;
  third_place_results_count INT;
BEGIN

  SELECT m.tournament_id, m.round
  INTO v_tournament_id, v_round
  FROM public.match m
  WHERE m.id = NEW.match_id;


  IF v_tournament_id IS NULL OR (v_round <> 'Finale' AND v_round <> 'Kleines Finale') THEN
    RETURN NEW;
  END IF;


  SELECT COUNT(*)
  INTO finale_results_count
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = v_tournament_id
    AND m.round = 'Finale'
    AND r.id IS NOT NULL;

  SELECT COUNT(*)
  INTO third_place_results_count
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = v_tournament_id
    AND m.round = 'Kleines Finale'
    AND r.id IS NOT NULL;


  IF finale_results_count = 1 AND third_place_results_count = 1 THEN
    PERFORM update_tournament_results(v_tournament_id);
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER trigger_final_results
  AFTER INSERT OR UPDATE
  ON public.result
  FOR EACH ROW
EXECUTE FUNCTION trigger_update_tournament_results();
