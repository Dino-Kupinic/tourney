-- todo: Add group name to the team standings view
CREATE OR REPLACE VIEW team_standings AS
SELECT t.id                                                                                     AS team_id,
       t.name                                                                                   AS team_name,
       t.tournament_id,
       g.name                                                                                   AS group_name, -- Add group name
       COALESCE(SUM(
                  CASE
                    WHEN r.winner_id = t.id THEN 3 -- Win 3 points
                    WHEN r.winner_id IS NULL AND r.id IS NOT NULL THEN 1 -- Draw 1 point
                    ELSE 0 -- Loss 0 points
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
       LEFT JOIN public.match m ON (t.id = m.team1_id OR t.id = m.team2_id) AND m.tournament_id = t.tournament_id
       LEFT JOIN public.result r ON r.match_id = m.id -- Only count completed matches
       LEFT JOIN public."group" g ON t.group_id = g.id -- Join with the group table
WHERE t.tournament_id IS NOT NULL -- Ensures teams belong to a tournament
GROUP BY t.id, t.name, t.tournament_id, g.name -- Include g.name in GROUP BY
ORDER BY t.tournament_id, points DESC, goal_difference DESC, goals_scored DESC;
