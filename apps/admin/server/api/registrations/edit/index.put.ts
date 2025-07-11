export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const { id, expire_date, allow_class_mixing } = await readBody<{
    id: string
    expire_date: string
    name: string
    allow_class_mixing: boolean
    class: string
  }>(event)

  const { error } = await supabase
    .from("registration")
    .update({ expire_date, allow_class_mixing })
    .eq("id", id)

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }

  setResponseStatus(event, 201)
})
