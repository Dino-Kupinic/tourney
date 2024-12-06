CREATE OR REPLACE FUNCTION update_registration_status()
  RETURNS VOID AS
$$
BEGIN
  UPDATE public.registration
  SET status = 'Abgelehnt'::public.registration_status
  WHERE expire_date = CURRENT_DATE;
END;
$$ LANGUAGE plpgsql;
