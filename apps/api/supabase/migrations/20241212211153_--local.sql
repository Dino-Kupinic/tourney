alter table "public"."registration" drop constraint "registration_class_id_fkey";

alter table "public"."team" drop constraint "team_tournament_id_fkey";

alter table "public"."registration" add constraint "registration_class_id_fkey" FOREIGN KEY (class_id) REFERENCES class(id) ON DELETE CASCADE not valid;

alter table "public"."registration" validate constraint "registration_class_id_fkey";

alter table "public"."team" add constraint "team_tournament_id_fkey" FOREIGN KEY (tournament_id) REFERENCES tournament(id) ON DELETE CASCADE not valid;

alter table "public"."team" validate constraint "team_tournament_id_fkey";

create policy "Enable delete for authenticated users"
on "public"."team"
as permissive
for delete
to authenticated
using (true);



