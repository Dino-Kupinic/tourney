drop policy "Enable insert for authenticated users only" on "public"."team";

alter table "public"."registration" add column "allow_class_mixing" boolean not null default false;

alter table "public"."team" add column "logo_variant_id" uuid;

alter table "public"."team" alter column "group" drop not null;

alter table "public"."team" alter column "logo_id" set not null;

alter table "public"."team" alter column "registration_id" set not null;

alter table "public"."team" alter column "tournament_id" set not null;

alter table "public"."tournament" alter column "location" set default '''Sportplatz''::text'::text;

alter table "public"."team" add constraint "team_logo_variant_id_fkey" FOREIGN KEY (logo_variant_id) REFERENCES logo_variant(id) not valid;

alter table "public"."team" validate constraint "team_logo_variant_id_fkey";

create policy "Enable read access for all users"
on "public"."logo"
as permissive
for select
to public
using (true);


create policy "Enable read access for all users"
on "public"."logo_variant"
as permissive
for select
to public
using (true);


create policy "Enable read access for all users"
on "public"."match"
as permissive
for select
to public
using (true);


create policy "Enable Insert for all users"
on "public"."player"
as permissive
for insert
to public
with check (true);


create policy "Enable read access for all users"
on "public"."player"
as permissive
for select
to public
using (true);


create policy "Enable insert for authenticated users only"
on "public"."team"
as permissive
for insert
to public
with check (true);



