export default defineEventHandler(async (event) => {
  const data = await readBody<string[]>(event)
  const supabase = await useDatabase(event)

  const { error } = await supabase
    .from("registration")
    .update({ hidden: true })
    .in("id", data)

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }
})
