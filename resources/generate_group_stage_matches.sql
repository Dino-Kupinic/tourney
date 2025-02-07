CREATE OR REPLACE FUNCTION generate_group_stage_matches(
  p_tournament_id UUID,
  p_start_time_ac TIME,
  p_start_time_bd TIME
)
  RETURNS VOID AS
$$
DECLARE
  team_a        UUID;
  team_c        UUID;
  team_b        UUID;
  team_d        UUID;
  start_time_ac TIME := p_start_time_ac;
  start_time_bd TIME := p_start_time_bd;
  interval_ac   INT  := 15;
  interval_bd   INT  := 15;
BEGIN
  -- loop through Groups A vs C
  FOR team_a, team_c IN
    SELECT t1.id, t2.id
    FROM public.team t1
           JOIN public.team t2 ON t1.group_id <> t2.group_id
    WHERE t1.group_id IN (SELECT id FROM public.group WHERE name = 'Gruppe A' AND tournament_id = p_tournament_id)
      AND t2.group_id IN (SELECT id FROM public.group WHERE name = 'Gruppe C' AND tournament_id = p_tournament_id)
    LOOP
      INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
      VALUES (p_tournament_id, team_a, team_c, start_time_ac, 'Gruppenphase');
      start_time_ac := start_time_ac + (interval_ac || ' minutes')::INTERVAL;
    END LOOP;

  -- loop through Groups B vs D
  FOR team_b, team_d IN
    SELECT t1.id, t2.id
    FROM public.team t1
           JOIN public.team t2 ON t1.group_id <> t2.group_id
    WHERE t1.group_id IN (SELECT id FROM public.group WHERE name = 'Gruppe B' AND tournament_id = p_tournament_id)
      AND t2.group_id IN (SELECT id FROM public.group WHERE name = 'Gruppe D' AND tournament_id = p_tournament_id)
    LOOP
      INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
      VALUES (p_tournament_id, team_b, team_d, start_time_bd, 'Gruppenphase');
      start_time_bd := start_time_bd + (interval_bd || ' minutes')::INTERVAL;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
