CREATE EXTENSION IF NOT EXISTS "pg_cron" WITH SCHEMA "pg_catalog";

ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";
ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."match";
ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."result";

CREATE OR REPLACE FUNCTION update_registration_status()
  RETURNS VOID AS
$$
BEGIN
  UPDATE public.registration
  SET status = 'Abgelehnt'::public.registration_status
  WHERE expire_date = CURRENT_DATE;
END;
$$ LANGUAGE plpgsql;

SELECT cron.schedule(
         'check_expire_date',
         '0 0 * * *',
         $$SELECT update_registration_status();$$
       );

CREATE POLICY "everyone can read buckets" ON "storage"."buckets"
  AS PERMISSIVE FOR SELECT
  TO public
  USING (true);

CREATE POLICY "everyone can read images 1ffg0oo_0" ON storage.objects FOR SELECT TO public USING (bucket_id = 'images');
CREATE POLICY "authenticated can do all 1zu98_0" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'misc');
CREATE POLICY "authenticated can do all 1zu98_1" ON storage.objects FOR SELECT TO authenticated USING (bucket_id = 'misc');
CREATE POLICY "authenticated can do all 1zu98_2" ON storage.objects FOR UPDATE TO authenticated USING (bucket_id = 'misc');
CREATE POLICY "authenticated can do all 1zu98_3" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'misc');
