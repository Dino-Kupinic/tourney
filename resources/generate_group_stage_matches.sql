CREATE OR REPLACE FUNCTION generate_group_stage_matches(
  p_tournament_id UUID,
  p_start_time TIME,
  p_interval_minutes INT
)
  RETURNS VOID AS
$$
DECLARE
  team1 UUID;
  team2 UUID;
  start_time TIME := p_start_time;
  interval_minutes INTERVAL := (p_interval_minutes || ' minutes')::INTERVAL;
  group_a_matches REFCURSOR;
  group_c_matches REFCURSOR;
  group_b_matches REFCURSOR;
  group_d_matches REFCURSOR;
BEGIN
  -- Open cursors for each group's matches
  OPEN group_a_matches FOR
    SELECT t1.id AS team1, t2.id AS team2
    FROM public.team t1
           JOIN public.team t2 ON t1.group_id = t2.group_id AND t1.id < t2.id
           JOIN public."group" g ON t1.group_id = g.id
    WHERE g.tournament_id = p_tournament_id AND g.name = 'Gruppe A';

  OPEN group_c_matches FOR
    SELECT t1.id AS team1, t2.id AS team2
    FROM public.team t1
           JOIN public.team t2 ON t1.group_id = t2.group_id AND t1.id < t2.id
           JOIN public."group" g ON t1.group_id = g.id
    WHERE g.tournament_id = p_tournament_id AND g.name = 'Gruppe C';

  OPEN group_b_matches FOR
    SELECT t1.id AS team1, t2.id AS team2
    FROM public.team t1
           JOIN public.team t2 ON t1.group_id = t2.group_id AND t1.id < t2.id
           JOIN public."group" g ON t1.group_id = g.id
    WHERE g.tournament_id = p_tournament_id AND g.name = 'Gruppe B';

  OPEN group_d_matches FOR
    SELECT t1.id AS team1, t2.id AS team2
    FROM public.team t1
           JOIN public.team t2 ON t1.group_id = t2.group_id AND t1.id < t2.id
           JOIN public."group" g ON t1.group_id = g.id
    WHERE g.tournament_id = p_tournament_id AND g.name = 'Gruppe D';

  -- Generate matches in parallel: A&C at the same time, B&D at the same time
  LOOP
    -- Fetch the next match for Group A
    FETCH group_a_matches INTO team1, team2;
    EXIT WHEN NOT FOUND;

    -- Insert the match for Group A
    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Gruppenphase');

    -- Fetch the next match for Group C
    FETCH group_c_matches INTO team1, team2;
    EXIT WHEN NOT FOUND;

    -- Insert the match for Group C (same start time as Group A)
    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Gruppenphase');

    -- Increment the start time for the next round
    start_time := start_time + interval_minutes;

    -- Fetch the next match for Group B
    FETCH group_b_matches INTO team1, team2;
    EXIT WHEN NOT FOUND;

    -- Insert the match for Group B
    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Gruppenphase');

    -- Fetch the next match for Group D
    FETCH group_d_matches INTO team1, team2;
    EXIT WHEN NOT FOUND;

    -- Insert the match for Group D (same start time as Group B)
    INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
    VALUES (p_tournament_id, team1, team2, start_time, 'Gruppenphase');

    -- Increment the start time for the next round
    start_time := start_time + interval_minutes;
  END LOOP;

  -- Close cursors
  CLOSE group_a_matches;
  CLOSE group_c_matches;
  CLOSE group_b_matches;
  CLOSE group_d_matches;
END;
$$ LANGUAGE plpgsql;
