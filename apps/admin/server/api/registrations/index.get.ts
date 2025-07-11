export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const { data } = await supabase
    .from("registration")
    .select("*, class(id, name)")
    .eq("hidden", false)

  return data
})
