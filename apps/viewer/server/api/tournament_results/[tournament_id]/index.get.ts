export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const id = getRouterParam(event, "tournament_id")

  if (id === undefined) {
    throw createError({
      message: "Tournament id missing",
      statusCode: 400,
    })
  }

  const { data } = await supabase
    .from("tournament_result")
    .select("*, team:team_id(*)")
    .eq("tournament_id", id)
    .order("position")

  return data
})
