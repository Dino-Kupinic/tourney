create type "public"."tournament_phase" as enum ('Gruppenphase', 'Kreuzspiele', 'Halbfinale', 'Finale', 'Kleines Finale');

alter table "public"."match" drop constraint "match_winner_id_fkey";

create table "public"."group" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "tournament_id" uuid not null
);


alter table "public"."group" enable row level security;

create table "public"."result" (
    "id" uuid not null default gen_random_uuid(),
    "team1_score" smallint not null,
    "team2_score" smallint not null,
    "winner_id" uuid,
    "match_id" uuid not null
);


alter table "public"."result" enable row level security;

alter table "public"."match" drop column "team1_score";

alter table "public"."match" drop column "team2_score";

alter table "public"."match" drop column "winner_id";

alter table "public"."match" add column "group_id" uuid;

-- alter table "public"."match" alter column "round" set data type tournament_phase using "round"::tournament_phase;
ALTER TABLE "public"."match" DROP COLUMN "round";
ALTER TABLE "public"."match" ADD COLUMN "round" tournament_phase;

alter table "public"."match" alter column "team1_id" set not null;

alter table "public"."match" alter column "team2_id" set not null;

alter table "public"."match" alter column "tournament_id" set not null;

alter table "public"."team" drop column "group";

alter table "public"."team" add column "group_id" uuid not null;

alter table "public"."tournament" add column "group_teams" smallint not null;

alter table "public"."tournament" add column "groups" smallint not null;

CREATE UNIQUE INDEX group_pkey ON public."group" USING btree (id);

CREATE UNIQUE INDEX result_pkey ON public.result USING btree (id);

alter table "public"."group" add constraint "group_pkey" PRIMARY KEY using index "group_pkey";

alter table "public"."result" add constraint "result_pkey" PRIMARY KEY using index "result_pkey";

alter table "public"."group" add constraint "group_tournament_id_fkey" FOREIGN KEY (tournament_id) REFERENCES tournament(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."group" validate constraint "group_tournament_id_fkey";

alter table "public"."match" add constraint "match_group_id_fkey" FOREIGN KEY (group_id) REFERENCES "group"(id) not valid;

alter table "public"."match" validate constraint "match_group_id_fkey";

alter table "public"."result" add constraint "result_match_id_fkey" FOREIGN KEY (match_id) REFERENCES match(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."result" validate constraint "result_match_id_fkey";

alter table "public"."result" add constraint "result_winner_id_fkey" FOREIGN KEY (winner_id) REFERENCES team(id) ON DELETE CASCADE not valid;

alter table "public"."result" validate constraint "result_winner_id_fkey";

alter table "public"."team" add constraint "team_group_id_fkey" FOREIGN KEY (group_id) REFERENCES "group"(id) not valid;

alter table "public"."team" validate constraint "team_group_id_fkey";

grant delete on table "public"."group" to "anon";

grant insert on table "public"."group" to "anon";

grant references on table "public"."group" to "anon";

grant select on table "public"."group" to "anon";

grant trigger on table "public"."group" to "anon";

grant truncate on table "public"."group" to "anon";

grant update on table "public"."group" to "anon";

grant delete on table "public"."group" to "authenticated";

grant insert on table "public"."group" to "authenticated";

grant references on table "public"."group" to "authenticated";

grant select on table "public"."group" to "authenticated";

grant trigger on table "public"."group" to "authenticated";

grant truncate on table "public"."group" to "authenticated";

grant update on table "public"."group" to "authenticated";

grant delete on table "public"."group" to "service_role";

grant insert on table "public"."group" to "service_role";

grant references on table "public"."group" to "service_role";

grant select on table "public"."group" to "service_role";

grant trigger on table "public"."group" to "service_role";

grant truncate on table "public"."group" to "service_role";

grant update on table "public"."group" to "service_role";

grant delete on table "public"."result" to "anon";

grant insert on table "public"."result" to "anon";

grant references on table "public"."result" to "anon";

grant select on table "public"."result" to "anon";

grant trigger on table "public"."result" to "anon";

grant truncate on table "public"."result" to "anon";

grant update on table "public"."result" to "anon";

grant delete on table "public"."result" to "authenticated";

grant insert on table "public"."result" to "authenticated";

grant references on table "public"."result" to "authenticated";

grant select on table "public"."result" to "authenticated";

grant trigger on table "public"."result" to "authenticated";

grant truncate on table "public"."result" to "authenticated";

grant update on table "public"."result" to "authenticated";

grant delete on table "public"."result" to "service_role";

grant insert on table "public"."result" to "service_role";

grant references on table "public"."result" to "service_role";

grant select on table "public"."result" to "service_role";

grant trigger on table "public"."result" to "service_role";

grant truncate on table "public"."result" to "service_role";

grant update on table "public"."result" to "service_role";

create policy "Enable insert for authenticated users only"
on "public"."group"
as permissive
for insert
to authenticated
with check (true);


create policy "Enable read access for all users"
on "public"."group"
as permissive
for select
to public
using (true);


create policy "authenticated can delete"
on "public"."group"
as permissive
for delete
to authenticated
using (true);


create policy "Enable read access for all users"
on "public"."result"
as permissive
for select
to public
using (true);



