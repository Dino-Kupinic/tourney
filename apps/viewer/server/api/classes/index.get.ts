export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const { data } = await supabase.from("class").select("*")

  return data
})
