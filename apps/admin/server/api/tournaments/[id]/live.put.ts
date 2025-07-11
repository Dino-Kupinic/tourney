export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const id = getRouterParam(event, "id")
  const { is_live } = await readBody<{ is_live: boolean }>(event)

  if (id === undefined) {
    throw createError({
      message: "Tournament id missing",
      statusCode: 400,
    })
  }

  if (is_live === undefined) {
    throw createError({
      message: "is_live missing",
      statusCode: 400,
    })
  }

  const { error } = await supabase
    .from("tournament")
    .update({ is_live: is_live })
    .eq("id", id)

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 400,
    })
  }

  setResponseStatus(event, 201, "success")
})
