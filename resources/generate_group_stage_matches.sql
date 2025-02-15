CREATE OR REPLACE FUNCTION generate_group_stage_matches(
    p_tournament_id UUID,
    p_start_time_ac TIME,
    p_start_time_bd TIME,
    p_interval_minutes INT
)
    RETURNS VOID AS
$$
DECLARE
    team_a           UUID;
    team_b           UUID;
    grp_id           UUID;
    start_time_ac    TIME := p_start_time_ac;
    start_time_bd    TIME := p_start_time_bd;
    interval_minutes INT  := p_interval_minutes;
BEGIN
    -- Loop through each group
    FOR grp_id IN
        SELECT id FROM public.group WHERE tournament_id = p_tournament_id
        LOOP
            -- Determine if this group is A/C or B/D based on group name
            IF grp_id IN
               (SELECT id
                FROM public.group
                WHERE name IN ('Gruppe A', 'Gruppe C')
                  AND tournament_id = p_tournament_id) THEN
                -- Round-robin for Groups A & C (parallel matches)
                FOR team_a, team_b IN
                    SELECT t1.id, t2.id
                    FROM public.team t1
                             JOIN public.team t2 ON t1.id < t2.id
                    WHERE t1.group_id = grp_id
                      AND t2.group_id = grp_id
                    LOOP
                        INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
                        VALUES (p_tournament_id, team_a, team_b, start_time_ac, 'Gruppenphase');

                        start_time_ac := start_time_ac + (interval_minutes || ' minutes')::INTERVAL;
                    END LOOP;
            ELSE
                -- Round-robin for Groups B & D (parallel matches)
                FOR team_a, team_b IN
                    SELECT t1.id, t2.id
                    FROM public.team t1
                             JOIN public.team t2 ON t1.id < t2.id
                    WHERE t1.group_id = grp_id
                      AND t2.group_id = grp_id
                    LOOP
                        INSERT INTO public.match (tournament_id, team1_id, team2_id, start_time, round)
                        VALUES (p_tournament_id, team_a, team_b, start_time_bd, 'Gruppenphase');

                        start_time_bd := start_time_bd + (interval_minutes || ' minutes')::INTERVAL;
                    END LOOP;
            END IF;
        END LOOP;
END;
$$ LANGUAGE plpgsql;
