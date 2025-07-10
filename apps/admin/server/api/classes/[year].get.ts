export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const encodedYear = getRouterParam(event, "year")

  if (encodedYear === undefined) {
    throw createError({
      message: "Invalid Year URL parameter",
      statusCode: 400,
    })
  }

  const year = decodeURIComponent(encodedYear)

  const { data } = await supabase
    .from("class")
    .select("*")
    .eq("year", year)
    .order("name", { ascending: false })

  return data
})
