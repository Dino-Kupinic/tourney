CREATE OR REPLACE FUNCTION record_match_result(p_match_id UUID, p_team1_score SMALLINT, p_team2_score SMALLINT)
  RETURNS VOID AS
$$
DECLARE
  winner UUID;
BEGIN
  -- Determine the winner
  IF p_team1_score > p_team2_score THEN
    SELECT team1_id INTO winner FROM public.match WHERE id = p_match_id;
  ELSIF p_team1_score < p_team2_score THEN
    SELECT team2_id INTO winner FROM public.match WHERE id = p_match_id;
  ELSE
    winner := NULL; -- Draw (no winner)
  END IF;

  -- Insert result
  INSERT INTO public.result (match_id, team1_score, team2_score, winner_id)
  VALUES (p_match_id, p_team1_score, p_team2_score, winner);

END;
$$ LANGUAGE plpgsql;

-- SELECT record_match_result('match-id', 2, 1);
