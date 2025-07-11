export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const { count } = await supabase
    .from("tournament")
    .select("*", { count: "exact", head: true })
    .eq("is_live", true)

  return count
})
