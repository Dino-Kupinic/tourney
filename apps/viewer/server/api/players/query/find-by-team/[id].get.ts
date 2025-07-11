export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const id = getRouterParam(event, "id")

  if (id === undefined) {
    throw createError({
      message: "Team id missing",
      statusCode: 400,
    })
  }

  const { data, error } = await supabase
    .from("player")
    .select("*")
    .eq("team_id", id)

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }

  return data
})
