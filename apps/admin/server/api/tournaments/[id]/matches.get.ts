export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const id = getRouterParam(event, "id")

  if (id === undefined) {
    throw createError({
      message: "Tournament id missing",
      statusCode: 400,
    })
  }

  const { data: matches, error } = await supabase
    .from("match")
    .select("*")
    .eq("tournament_id", id)

  if (error) {
    throw createError({
      statusCode: 500,
      statusMessage: error.message,
    })
  }

  return matches
})