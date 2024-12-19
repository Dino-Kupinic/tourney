create policy "authenticated users can delete"
on "public"."tournament"
as permissive
for delete
to authenticated
using (true);



