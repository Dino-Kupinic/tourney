alter table "public"."team" alter column "tournament_id" drop not null;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.add_rls_policies_for_misc()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
  CREATE POLICY "authenticated can do all 1zu98_0" ON storage.objects FOR SELECT TO authenticated USING (bucket_id = 'misc');
  CREATE POLICY "authenticated can do all 1zu98_1" ON storage.objects FOR UPDATE TO authenticated USING (bucket_id = 'misc');
  CREATE POLICY "authenticated can do all 1zu98_2" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'misc');
  CREATE POLICY "authenticated can do all 1zu98_3" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'misc');
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_registration_status()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
  UPDATE public.registration
  SET status = 'Abgelehnt'::public.registration_status
  WHERE expire_date = CURRENT_DATE;
END;
$function$
;


