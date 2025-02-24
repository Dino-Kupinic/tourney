CREATE OR REPLACE FUNCTION update_tournament_results(p_tournament_id UUID)
  RETURNS VOID AS
$$
DECLARE
  final_winner_id       UUID;
  final_loser_id        UUID;
  third_place_winner_id UUID;
  third_place_loser_id  UUID;
BEGIN
  -- Get the winner and loser of the final
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
  INTO final_winner_id, final_loser_id
  FROM public.match m
         LEFT JOIN public.result r ON m.id = r.match_id
  WHERE m.tournament_id = p_tournament_id
    AND m.round = 'Finale';

  -- Get the winner and loser of the 3rd place match
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

  -- Insert final rankings into tournament_results
  INSERT INTO public.tournament_result (tournament_id, team_id, position)
  VALUES (p_tournament_id, final_winner_id, 1),       -- Champion
         (p_tournament_id, final_loser_id, 2),        -- Runner-up
         (p_tournament_id, third_place_winner_id, 3), -- 3rd place
         (p_tournament_id, third_place_loser_id, 4); -- 4th place
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
  -- Retrieve tournament_id and round from the match table
  SELECT m.tournament_id, m.round
  INTO v_tournament_id, v_round
  FROM public.match m
  WHERE m.id = NEW.match_id;

  -- Ensure we have a valid tournament ID and that this match is from the finale or 3rd place match
  IF v_tournament_id IS NULL OR (v_round <> 'Finale' AND v_round <> 'Kleines Finale') THEN
    RETURN NEW;
  END IF;

  -- Count the number of results for the finale and 3rd place match
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

  -- If both the finale and 3rd place match have results, update the tournament results
  IF finale_results_count = 1 AND third_place_results_count = 1 THEN
    PERFORM update_tournament_results(v_tournament_id);
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE OR REPLACE TRIGGER trigger_final_results
  AFTER INSERT OR UPDATE
  ON public.result
  FOR EACH ROW
EXECUTE FUNCTION trigger_update_tournament_results();
