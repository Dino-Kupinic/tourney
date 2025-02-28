drop view if exists "public"."team_standings";

create or replace view "public"."team_standings" as  SELECT t.id AS team_id,
    t.name AS team_name,
    t.tournament_id,
    COALESCE(sum(
        CASE
            WHEN (r.winner_id = t.id) THEN 3
            WHEN ((r.winner_id IS NULL) AND (r.id IS NOT NULL)) THEN 1
            ELSE 0
        END), (0)::bigint) AS points,
    COALESCE(count(
        CASE
            WHEN (r.winner_id = t.id) THEN 1
            ELSE NULL::integer
        END), (0)::bigint) AS wins,
    COALESCE(count(
        CASE
            WHEN ((r.winner_id IS NULL) AND (r.id IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END), (0)::bigint) AS draws,
    COALESCE(count(
        CASE
            WHEN ((r.winner_id IS NOT NULL) AND (r.winner_id <> t.id)) THEN 1
            ELSE NULL::integer
        END), (0)::bigint) AS losses,
    COALESCE(sum(
        CASE
            WHEN (m.team1_id = t.id) THEN r.team1_score
            ELSE r.team2_score
        END), (0)::bigint) AS goals_scored,
    COALESCE(sum(
        CASE
            WHEN (m.team1_id = t.id) THEN r.team2_score
            ELSE r.team1_score
        END), (0)::bigint) AS goals_conceded,
    (COALESCE(sum(
        CASE
            WHEN (m.team1_id = t.id) THEN r.team1_score
            ELSE r.team2_score
        END), (0)::bigint) - COALESCE(sum(
        CASE
            WHEN (m.team1_id = t.id) THEN r.team2_score
            ELSE r.team1_score
        END), (0)::bigint)) AS goal_difference
   FROM ((team t
     LEFT JOIN match m ON ((((t.id = m.team1_id) OR (t.id = m.team2_id)) AND (m.tournament_id = t.tournament_id))))
     LEFT JOIN result r ON ((r.match_id = m.id)))
  WHERE (t.tournament_id IS NOT NULL)
  GROUP BY t.id, t.name, t.tournament_id
  ORDER BY t.tournament_id, COALESCE(sum(
        CASE
            WHEN (r.winner_id = t.id) THEN 3
            WHEN ((r.winner_id IS NULL) AND (r.id IS NOT NULL)) THEN 1
            ELSE 0
        END), (0)::bigint) DESC, (COALESCE(sum(
        CASE
            WHEN (m.team1_id = t.id) THEN r.team1_score
            ELSE r.team2_score
        END), (0)::bigint) - COALESCE(sum(
        CASE
            WHEN (m.team1_id = t.id) THEN r.team2_score
            ELSE r.team1_score
        END), (0)::bigint)) DESC, COALESCE(sum(
        CASE
            WHEN (m.team1_id = t.id) THEN r.team1_score
            ELSE r.team2_score
        END), (0)::bigint) DESC;



