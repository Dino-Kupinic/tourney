alter table "public"."match" add column "is_live" boolean not null default false;

create or replace view "public"."matches_status" as  SELECT m.id AS match_id,
    m.tournament_id,
    m.team1_id,
    t1.name AS team1_name,
    m.team2_id,
    t2.name AS team2_name,
    m.start_time,
    m.end_time,
    m.round,
        CASE
            WHEN (r.id IS NOT NULL) THEN 'completed'::text
            ELSE 'upcoming'::text
        END AS status
   FROM (((match m
     LEFT JOIN result r ON ((r.match_id = m.id)))
     LEFT JOIN team t1 ON ((m.team1_id = t1.id)))
     LEFT JOIN team t2 ON ((m.team2_id = t2.id)))
  ORDER BY m.start_time;



