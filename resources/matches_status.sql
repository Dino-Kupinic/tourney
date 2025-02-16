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
         ELSE 'upcoming'
         END   AS status
FROM public.match m
       LEFT JOIN public.result r ON r.match_id = m.id -- Check if a result exists
       LEFT JOIN public.team t1 ON m.team1_id = t1.id
       LEFT JOIN public.team t2 ON m.team2_id = t2.id
ORDER BY m.start_time; -- Show upcoming matches first

-- SELECT * FROM matches_status WHERE status = 'upcoming' AND tournament_id = 'YOUR_TOURNAMENT_UUID';
