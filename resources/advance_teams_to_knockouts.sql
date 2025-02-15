CREATE OR REPLACE FUNCTION advance_teams_to_knockouts(p_tournament_id UUID)
  RETURNS VOID AS
$$
DECLARE
  top_teams       UUID[];
  semifinal_teams UUID[];
  final_teams     UUID[];
  match_time      TIME := '12:15';
  final_time      TIME := '13:15';
BEGIN
  -- Get top team from each group
  SELECT array_agg(id ORDER BY
      (SELECT COUNT(*) FROM public.result WHERE winner_id = t.id) DESC)
  INTO top_teams
  FROM public.team t
  WHERE tournament_id = p_tournament_id
  GROUP BY group_id;

  -- Insert Cross-Matches (1st A vs. 1st C, 1st B vs. 1st D)
  INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
  VALUES (p_tournament_id, top_teams[1], top_teams[3], match_time, 'Semifinal'),
         (p_tournament_id, top_teams[2], top_teams[4], match_time, 'Semifinal');

  -- Get winners of semifinals
  SELECT array_agg(winner_id)
  INTO semifinal_teams
  FROM public.result
  WHERE match_id IN (SELECT id FROM public.match WHERE round = 'Semifinal' AND tournament_id = p_tournament_id);

  -- Insert Final and 3rd place match
  INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
  VALUES (p_tournament_id, semifinal_teams[1], semifinal_teams[2], final_time, 'Final'),
         (p_tournament_id, top_teams[1], top_teams[2], final_time, '3rd Place');
END;
$$ LANGUAGE plpgsql;

-- SELECT advance_teams_to_knockouts('your-tournament-id');
