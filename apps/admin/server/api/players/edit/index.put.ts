type Body = {
  id: string
  note: string
}

export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const { id, note } = await readBody<Body>(event)

  if (!id || note === undefined) {
    throw createError({
      statusCode: 400,
      statusMessage: "Missing player id or note",
    })
  }

  const { error } = await supabase
    .from("player")
    .update({ note: note })
    .eq("id", id)

  if (error) {
    throw createError({
      statusCode: 500,
      statusMessage: error.message,
    })
  }

  setResponseStatus(event, 200, "Note updated successfully")
})
