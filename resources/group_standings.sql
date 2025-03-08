CREATE OR REPLACE VIEW group_standings AS
SELECT t.id                                                                                     AS team_id,
       t.name                                                                                   AS team_name,
       t.tournament_id,
       t.group_id,
       COALESCE(SUM(
                  CASE
                    WHEN r.winner_id = t.id THEN 3 -- Win → 3 points
                    WHEN r.winner_id IS NULL AND r.id IS NOT NULL THEN 1 -- Draw → 1 point
                    ELSE 0 -- Loss → 0 points
                    END
                ), 0)                                                                           AS points,
       COALESCE(COUNT(CASE WHEN r.winner_id = t.id THEN 1 END), 0)                              AS wins,
       COALESCE(COUNT(CASE WHEN r.winner_id IS NULL AND r.id IS NOT NULL THEN 1 END), 0)        AS draws,
       COALESCE(COUNT(CASE WHEN r.winner_id IS NOT NULL AND r.winner_id <> t.id THEN 1 END), 0) AS losses,
       COALESCE(SUM(CASE WHEN m.team1_id = t.id THEN r.team1_score ELSE r.team2_score END), 0)  AS goals_scored,
       COALESCE(SUM(CASE WHEN m.team1_id = t.id THEN r.team2_score ELSE r.team1_score END), 0)  AS goals_conceded,
       COALESCE(SUM(CASE WHEN m.team1_id = t.id THEN r.team1_score ELSE r.team2_score END), 0) -
       COALESCE(SUM(CASE WHEN m.team1_id = t.id THEN r.team2_score ELSE r.team1_score END), 0)  AS goal_difference
FROM public.team t
       LEFT JOIN public.match m ON (t.id = m.team1_id OR t.id = m.team2_id)
       LEFT JOIN public.result r ON r.match_id = m.id -- Only count completed matches
WHERE t.group_id IS NOT NULL -- Ensures teams belong to a group
GROUP BY t.id, t.name, t.tournament_id, t.group_id -- Ensure t.group_id is grouped correctly
ORDER BY t.group_id, points DESC, goal_difference DESC, goals_scored DESC;
