export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const id = getRouterParam(event, "id")

  if (id === undefined) {
    throw createError({
      statusCode: 400,
      statusMessage: "Missing data field id",
    })
  }

  const { error } = await supabase.from("tournament").delete().eq("id", id)

  if (error) {
    throw createError({
      statusCode: 500,
      statusMessage: error.message,
    })
  }

  setResponseStatus(event, 204, "success")
})
