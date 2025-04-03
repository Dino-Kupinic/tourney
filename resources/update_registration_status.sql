CREATE OR REPLACE FUNCTION update_registration_status()
  RETURNS VOID AS
$$
BEGIN
  UPDATE public.registration
  SET status = 'Abgelehnt'::public.registration_status
  WHERE expire_date = CURRENT_DATE
    AND status != 'Abgeschlossen'::public.registration_status;
END;
$$ LANGUAGE plpgsql;

SELECT cron.schedule(
         'check_expire_date',
         '0 0 * * *',
         $$SELECT update_registration_status();$$
       );
