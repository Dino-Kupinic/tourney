alter table "public"."team" alter column "tournament_id" drop not null;

set check_function_bodies = off;

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


