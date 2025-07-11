export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const { data } = await supabase.from("logo_variant").select("*")

  return data
})
