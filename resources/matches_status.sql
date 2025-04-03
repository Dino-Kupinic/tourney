CREATE OR REPLACE VIEW matches_status AS
SELECT m.id    AS match_id,
       m.tournament_id,
       m.team1_id,
       t1.name AS team1_name,
       m.team2_id,
       t2.name AS team2_name,
       m.start_time,
       m.end_time,
       m.round,
       CASE
         WHEN r.id IS NOT NULL THEN 'completed'
         WHEN m.is_live THEN 'live'
         ELSE 'upcoming'
         END   AS status
FROM public.match m
       LEFT JOIN public.result r ON r.match_id = m.id
       LEFT JOIN public.team t1 ON m.team1_id = t1.id
       LEFT JOIN public.team t2 ON m.team2_id = t2.id
ORDER BY m.start_time ASC;
