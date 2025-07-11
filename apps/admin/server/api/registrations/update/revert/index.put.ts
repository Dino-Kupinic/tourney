export default defineEventHandler(async (event) => {
  const { registrations } = await readBody<{
    registrations: string[]
  }>(event)
  const supabase = await useDatabase(event)

  const { data: teams, error: teamsError } = await supabase
    .from("team")
    .select("id")
    .in("registration_id", registrations)

  if (teamsError) {
    throw createError({
      message: teamsError.message,
      statusCode: 500,
    })
  }

  const { error: playersError } = await supabase
    .from("player")
    .delete()
    .in(
      "team_id",
      teams.map((team) => team.id),
    )

  if (playersError) {
    throw createError({
      message: playersError.message,
      statusCode: 500,
    })
  }

  const { error } = await supabase
    .from("team")
    .delete()
    .in("registration_id", registrations)

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }

  setResponseStatus(event, 204, "success")
})
