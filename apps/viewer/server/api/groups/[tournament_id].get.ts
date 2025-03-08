export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const tournamentId = getRouterParam(event, "tournament_id")

  if (!tournamentId) {
    throw createError({
      statusCode: 400,
      statusMessage: "Missing tournament id",
    })
  }

  const { data: groups, error: groupError } = await supabase
    .from("group")
    .select("*")
    .eq("tournament_id", tournamentId)

  if (groupError) {
    throw createError({
      message: groupError.message,
      statusCode: 500,
    })
  }

  return groups
})
