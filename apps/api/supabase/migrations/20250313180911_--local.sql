create policy "authenticated can delete"
on "public"."class"
as permissive
for delete
to authenticated
using (true);


create policy "authenticated can update"
on "public"."class"
as permissive
for update
to authenticated
using (true);



