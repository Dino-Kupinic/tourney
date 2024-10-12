create type "public"."registration_status" as enum ('Ausstehend', 'Abgesendet', 'Abgeschlossen', 'Abgelehnt');

create type "public"."sport_type" as enum ('Fußball', 'Volleyball', 'Basketball');

create table "public"."class" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "year" text not null
);


alter table "public"."class" enable row level security;

create table "public"."logo" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "image_path" text not null
);


alter table "public"."logo" enable row level security;

create table "public"."logo_variant" (
    "id" uuid not null default gen_random_uuid(),
    "color" text not null,
    "image_path" text not null,
    "logo_id" uuid not null
);


alter table "public"."logo_variant" enable row level security;

create table "public"."match" (
    "id" uuid not null default gen_random_uuid(),
    "tournament_id" uuid,
    "team1_id" uuid,
    "team2_id" uuid,
    "start_time" time without time zone not null,
    "end_time" time without time zone,
    "team1_score" smallint not null default '0'::smallint,
    "team2_score" smallint not null default '0'::smallint,
    "round" smallint not null,
    "winner_id" uuid
);


alter table "public"."match" enable row level security;

create table "public"."player" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "first_name" text not null,
    "last_name" text not null,
    "class" text not null,
    "note" text,
    "team_id" uuid not null
);


alter table "public"."player" enable row level security;

create table "public"."registration" (
    "id" uuid not null default gen_random_uuid(),
    "expire_date" date not null,
    "status" registration_status not null default 'Ausstehend'::registration_status,
    "class_id" uuid not null,
    "name" text not null
);


alter table "public"."registration" enable row level security;

create table "public"."team" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "name" text not null,
    "group" text not null,
    "logo_id" uuid,
    "tournament_id" uuid,
    "registration_id" uuid
);


alter table "public"."team" enable row level security;

create table "public"."tournament" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "name" text not null,
    "description" text,
    "rules" text,
    "start_date" date not null,
    "from" time without time zone not null,
    "to" time without time zone not null,
    "is_live" boolean not null default false,
    "year" smallint not null,
    "last_edited_by_id" uuid not null,
    "sport" sport_type not null
);


alter table "public"."tournament" enable row level security;

CREATE UNIQUE INDEX class_pkey ON public.class USING btree (id);

CREATE UNIQUE INDEX logo_pkey ON public.logo USING btree (id);

CREATE UNIQUE INDEX logo_variant_pkey ON public.logo_variant USING btree (id);

CREATE UNIQUE INDEX match_pkey ON public.match USING btree (id);

CREATE UNIQUE INDEX player_pkey ON public.player USING btree (id);

CREATE UNIQUE INDEX registration_pkey ON public.registration USING btree (id);

CREATE UNIQUE INDEX team_pkey ON public.team USING btree (id);

CREATE UNIQUE INDEX tournament_pkey ON public.tournament USING btree (id);

alter table "public"."class" add constraint "class_pkey" PRIMARY KEY using index "class_pkey";

alter table "public"."logo" add constraint "logo_pkey" PRIMARY KEY using index "logo_pkey";

alter table "public"."logo_variant" add constraint "logo_variant_pkey" PRIMARY KEY using index "logo_variant_pkey";

alter table "public"."match" add constraint "match_pkey" PRIMARY KEY using index "match_pkey";

alter table "public"."player" add constraint "player_pkey" PRIMARY KEY using index "player_pkey";

alter table "public"."registration" add constraint "registration_pkey" PRIMARY KEY using index "registration_pkey";

alter table "public"."team" add constraint "team_pkey" PRIMARY KEY using index "team_pkey";

alter table "public"."tournament" add constraint "tournament_pkey" PRIMARY KEY using index "tournament_pkey";

alter table "public"."logo_variant" add constraint "logo_variant_logo_id_fkey" FOREIGN KEY (logo_id) REFERENCES logo(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."logo_variant" validate constraint "logo_variant_logo_id_fkey";

alter table "public"."match" add constraint "match_team1_id_fkey" FOREIGN KEY (team1_id) REFERENCES team(id) not valid;

alter table "public"."match" validate constraint "match_team1_id_fkey";

alter table "public"."match" add constraint "match_team2_id_fkey" FOREIGN KEY (team2_id) REFERENCES team(id) not valid;

alter table "public"."match" validate constraint "match_team2_id_fkey";

alter table "public"."match" add constraint "match_tournament_id_fkey" FOREIGN KEY (tournament_id) REFERENCES tournament(id) not valid;

alter table "public"."match" validate constraint "match_tournament_id_fkey";

alter table "public"."match" add constraint "match_winner_id_fkey" FOREIGN KEY (winner_id) REFERENCES team(id) not valid;

alter table "public"."match" validate constraint "match_winner_id_fkey";

alter table "public"."player" add constraint "player_team_id_fkey" FOREIGN KEY (team_id) REFERENCES team(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."player" validate constraint "player_team_id_fkey";

alter table "public"."registration" add constraint "registration_class_id_fkey" FOREIGN KEY (class_id) REFERENCES class(id) not valid;

alter table "public"."registration" validate constraint "registration_class_id_fkey";

alter table "public"."team" add constraint "team_logo_id_fkey" FOREIGN KEY (logo_id) REFERENCES logo(id) not valid;

alter table "public"."team" validate constraint "team_logo_id_fkey";

alter table "public"."team" add constraint "team_registration_id_fkey" FOREIGN KEY (registration_id) REFERENCES registration(id) not valid;

alter table "public"."team" validate constraint "team_registration_id_fkey";

alter table "public"."team" add constraint "team_tournament_id_fkey" FOREIGN KEY (tournament_id) REFERENCES tournament(id) not valid;

alter table "public"."team" validate constraint "team_tournament_id_fkey";

alter table "public"."tournament" add constraint "tournament_last_edited_by_id_fkey" FOREIGN KEY (last_edited_by_id) REFERENCES auth.users(id) not valid;

alter table "public"."tournament" validate constraint "tournament_last_edited_by_id_fkey";

grant delete on table "public"."class" to "anon";

grant insert on table "public"."class" to "anon";

grant references on table "public"."class" to "anon";

grant select on table "public"."class" to "anon";

grant trigger on table "public"."class" to "anon";

grant truncate on table "public"."class" to "anon";

grant update on table "public"."class" to "anon";

grant delete on table "public"."class" to "authenticated";

grant insert on table "public"."class" to "authenticated";

grant references on table "public"."class" to "authenticated";

grant select on table "public"."class" to "authenticated";

grant trigger on table "public"."class" to "authenticated";

grant truncate on table "public"."class" to "authenticated";

grant update on table "public"."class" to "authenticated";

grant delete on table "public"."class" to "service_role";

grant insert on table "public"."class" to "service_role";

grant references on table "public"."class" to "service_role";

grant select on table "public"."class" to "service_role";

grant trigger on table "public"."class" to "service_role";

grant truncate on table "public"."class" to "service_role";

grant update on table "public"."class" to "service_role";

grant delete on table "public"."logo" to "anon";

grant insert on table "public"."logo" to "anon";

grant references on table "public"."logo" to "anon";

grant select on table "public"."logo" to "anon";

grant trigger on table "public"."logo" to "anon";

grant truncate on table "public"."logo" to "anon";

grant update on table "public"."logo" to "anon";

grant delete on table "public"."logo" to "authenticated";

grant insert on table "public"."logo" to "authenticated";

grant references on table "public"."logo" to "authenticated";

grant select on table "public"."logo" to "authenticated";

grant trigger on table "public"."logo" to "authenticated";

grant truncate on table "public"."logo" to "authenticated";

grant update on table "public"."logo" to "authenticated";

grant delete on table "public"."logo" to "service_role";

grant insert on table "public"."logo" to "service_role";

grant references on table "public"."logo" to "service_role";

grant select on table "public"."logo" to "service_role";

grant trigger on table "public"."logo" to "service_role";

grant truncate on table "public"."logo" to "service_role";

grant update on table "public"."logo" to "service_role";

grant delete on table "public"."logo_variant" to "anon";

grant insert on table "public"."logo_variant" to "anon";

grant references on table "public"."logo_variant" to "anon";

grant select on table "public"."logo_variant" to "anon";

grant trigger on table "public"."logo_variant" to "anon";

grant truncate on table "public"."logo_variant" to "anon";

grant update on table "public"."logo_variant" to "anon";

grant delete on table "public"."logo_variant" to "authenticated";

grant insert on table "public"."logo_variant" to "authenticated";

grant references on table "public"."logo_variant" to "authenticated";

grant select on table "public"."logo_variant" to "authenticated";

grant trigger on table "public"."logo_variant" to "authenticated";

grant truncate on table "public"."logo_variant" to "authenticated";

grant update on table "public"."logo_variant" to "authenticated";

grant delete on table "public"."logo_variant" to "service_role";

grant insert on table "public"."logo_variant" to "service_role";

grant references on table "public"."logo_variant" to "service_role";

grant select on table "public"."logo_variant" to "service_role";

grant trigger on table "public"."logo_variant" to "service_role";

grant truncate on table "public"."logo_variant" to "service_role";

grant update on table "public"."logo_variant" to "service_role";

grant delete on table "public"."match" to "anon";

grant insert on table "public"."match" to "anon";

grant references on table "public"."match" to "anon";

grant select on table "public"."match" to "anon";

grant trigger on table "public"."match" to "anon";

grant truncate on table "public"."match" to "anon";

grant update on table "public"."match" to "anon";

grant delete on table "public"."match" to "authenticated";

grant insert on table "public"."match" to "authenticated";

grant references on table "public"."match" to "authenticated";

grant select on table "public"."match" to "authenticated";

grant trigger on table "public"."match" to "authenticated";

grant truncate on table "public"."match" to "authenticated";

grant update on table "public"."match" to "authenticated";

grant delete on table "public"."match" to "service_role";

grant insert on table "public"."match" to "service_role";

grant references on table "public"."match" to "service_role";

grant select on table "public"."match" to "service_role";

grant trigger on table "public"."match" to "service_role";

grant truncate on table "public"."match" to "service_role";

grant update on table "public"."match" to "service_role";

grant delete on table "public"."player" to "anon";

grant insert on table "public"."player" to "anon";

grant references on table "public"."player" to "anon";

grant select on table "public"."player" to "anon";

grant trigger on table "public"."player" to "anon";

grant truncate on table "public"."player" to "anon";

grant update on table "public"."player" to "anon";

grant delete on table "public"."player" to "authenticated";

grant insert on table "public"."player" to "authenticated";

grant references on table "public"."player" to "authenticated";

grant select on table "public"."player" to "authenticated";

grant trigger on table "public"."player" to "authenticated";

grant truncate on table "public"."player" to "authenticated";

grant update on table "public"."player" to "authenticated";

grant delete on table "public"."player" to "service_role";

grant insert on table "public"."player" to "service_role";

grant references on table "public"."player" to "service_role";

grant select on table "public"."player" to "service_role";

grant trigger on table "public"."player" to "service_role";

grant truncate on table "public"."player" to "service_role";

grant update on table "public"."player" to "service_role";

grant delete on table "public"."registration" to "anon";

grant insert on table "public"."registration" to "anon";

grant references on table "public"."registration" to "anon";

grant select on table "public"."registration" to "anon";

grant trigger on table "public"."registration" to "anon";

grant truncate on table "public"."registration" to "anon";

grant update on table "public"."registration" to "anon";

grant delete on table "public"."registration" to "authenticated";

grant insert on table "public"."registration" to "authenticated";

grant references on table "public"."registration" to "authenticated";

grant select on table "public"."registration" to "authenticated";

grant trigger on table "public"."registration" to "authenticated";

grant truncate on table "public"."registration" to "authenticated";

grant update on table "public"."registration" to "authenticated";

grant delete on table "public"."registration" to "service_role";

grant insert on table "public"."registration" to "service_role";

grant references on table "public"."registration" to "service_role";

grant select on table "public"."registration" to "service_role";

grant trigger on table "public"."registration" to "service_role";

grant truncate on table "public"."registration" to "service_role";

grant update on table "public"."registration" to "service_role";

grant delete on table "public"."team" to "anon";

grant insert on table "public"."team" to "anon";

grant references on table "public"."team" to "anon";

grant select on table "public"."team" to "anon";

grant trigger on table "public"."team" to "anon";

grant truncate on table "public"."team" to "anon";

grant update on table "public"."team" to "anon";

grant delete on table "public"."team" to "authenticated";

grant insert on table "public"."team" to "authenticated";

grant references on table "public"."team" to "authenticated";

grant select on table "public"."team" to "authenticated";

grant trigger on table "public"."team" to "authenticated";

grant truncate on table "public"."team" to "authenticated";

grant update on table "public"."team" to "authenticated";

grant delete on table "public"."team" to "service_role";

grant insert on table "public"."team" to "service_role";

grant references on table "public"."team" to "service_role";

grant select on table "public"."team" to "service_role";

grant trigger on table "public"."team" to "service_role";

grant truncate on table "public"."team" to "service_role";

grant update on table "public"."team" to "service_role";

grant delete on table "public"."tournament" to "anon";

grant insert on table "public"."tournament" to "anon";

grant references on table "public"."tournament" to "anon";

grant select on table "public"."tournament" to "anon";

grant trigger on table "public"."tournament" to "anon";

grant truncate on table "public"."tournament" to "anon";

grant update on table "public"."tournament" to "anon";

grant delete on table "public"."tournament" to "authenticated";

grant insert on table "public"."tournament" to "authenticated";

grant references on table "public"."tournament" to "authenticated";

grant select on table "public"."tournament" to "authenticated";

grant trigger on table "public"."tournament" to "authenticated";

grant truncate on table "public"."tournament" to "authenticated";

grant update on table "public"."tournament" to "authenticated";

grant delete on table "public"."tournament" to "service_role";

grant insert on table "public"."tournament" to "service_role";

grant references on table "public"."tournament" to "service_role";

grant select on table "public"."tournament" to "service_role";

grant trigger on table "public"."tournament" to "service_role";

grant truncate on table "public"."tournament" to "service_role";

grant update on table "public"."tournament" to "service_role";

create policy "Enable insert for authenticated users only"
on "public"."class"
as permissive
for insert
to authenticated
with check (true);


create policy "Enable read access for all users"
on "public"."class"
as permissive
for select
to public
using (true);


create policy "Enable insert for authenticated users only"
on "public"."registration"
as permissive
for insert
to authenticated
with check (true);


create policy "Enable read access for all users"
on "public"."registration"
as permissive
for select
to public
using (true);


create policy "Enable insert for authenticated users only"
on "public"."team"
as permissive
for insert
to authenticated
with check (true);


create policy "Enable read access for all users"
on "public"."team"
as permissive
for select
to public
using (true);


create policy "Enable insert for authenticated users only"
on "public"."tournament"
as permissive
for insert
to authenticated
with check (true);


create policy "Enable read access for all users"
on "public"."tournament"
as permissive
for select
to public
using (true);



