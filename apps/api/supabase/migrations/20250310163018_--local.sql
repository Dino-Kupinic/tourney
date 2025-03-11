create extension if not exists "hypopg" with schema "extensions";

create extension if not exists "index_advisor" with schema "extensions";


CREATE INDEX match_team1_id_idx ON public.match USING btree (team1_id);

CREATE INDEX match_team2_id_idx ON public.match USING btree (team2_id);

CREATE INDEX match_tournament_id_start_time_idx ON public.match USING btree (tournament_id, start_time);

CREATE INDEX result_match_id_idx ON public.result USING btree (match_id);

CREATE INDEX tournament_live_idx ON public.tournament USING btree (is_live) WHERE (is_live = true);


