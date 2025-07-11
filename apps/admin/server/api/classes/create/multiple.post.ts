export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const { classes, year } = await readBody(event)

  if (!classes || !year) {
    throw createError({
      message: "classes and year are required",
      statusCode: 400,
    })
  }

  const insert = classes.map((name: string) => ({ name: name, year: year }))

  const { data, error } = await supabase.from("class").insert(insert).select()

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }

  return data
})
