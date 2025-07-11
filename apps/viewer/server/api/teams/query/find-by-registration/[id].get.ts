export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const id = getRouterParam(event, "id")

  if (id === undefined) {
    throw createError({
      message: "Registration id missing",
      statusCode: 400,
    })
  }

  const { data } = await supabase
    .from("team")
    .select("*")
    .eq("registration_id", id)
    .single()

  return data
})
