alter table "public"."registration" add column "hidden" boolean not null default false;

alter table "public"."tournament" drop column "description";

alter table "public"."tournament" add column "location" text not null default 'Sportplatz, HTL Steyr'::text;

alter table "public"."tournament" add column "prizes" jsonb;

alter table "public"."tournament" add column "thumbnail_path" text not null;

alter table "public"."tournament" add constraint "prizes_json_schema" CHECK (((prizes IS NULL) OR ((prizes ? 'first'::text) AND ((prizes ->> 'first'::text) IS NOT NULL) AND (prizes ? 'second'::text) AND ((prizes ->> 'second'::text) IS NOT NULL) AND (prizes ? 'third'::text) AND ((prizes ->> 'third'::text) IS NOT NULL) AND (prizes ? 'bonus'::text) AND ((prizes ->> 'bonus'::text) IS NOT NULL)))) not valid;

alter table "public"."tournament" validate constraint "prizes_json_schema";

create policy "Allow deletion"
on "public"."registration"
as permissive
for delete
to authenticated
using (true);


create policy "Enable update for users based on email"
on "public"."registration"
as permissive
for update
to public
using (true);



