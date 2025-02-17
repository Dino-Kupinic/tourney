CREATE OR REPLACE FUNCTION declare_champion(p_tournament_id UUID)
  RETURNS TABLE
          (
            champion_name TEXT
          )
AS
$$
DECLARE
  champion UUID;
BEGIN
  -- Get winner of final
  SELECT winner_id
  INTO champion
  FROM public.result
  WHERE match_id = (SELECT id FROM public.match WHERE round = 'Final' AND tournament_id = p_tournament_id);

  -- Return winner's name
  RETURN QUERY
    SELECT name FROM public.team WHERE id = champion;
END;
$$ LANGUAGE plpgsql;

-- SELECT * FROM declare_champion('your-tournament-id');
