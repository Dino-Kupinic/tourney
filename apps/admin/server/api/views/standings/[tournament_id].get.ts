export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const id = getRouterParam(event, "tournament_id")

  if (id === undefined) {
    throw createError({
      message: "Id is missing",
      statusCode: 400,
    })
  }

  const { data } = await supabase
    .from("team_standings")
    .select("*")
    .eq("tournament_id", id)

  return data
})
