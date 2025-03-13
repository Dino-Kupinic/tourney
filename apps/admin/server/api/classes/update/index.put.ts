import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const body = await readBody(event)

  const { id, name, year } = body

  if (!id || !name || !year) {
    throw createError({
      message: "ID, name, and year are required",
      statusCode: 400,
    })
  }

  const { data, error } = await supabase
    .from("class")
    .update({ name, year })
    .eq("id", id)
    .select()
    .single()

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }

  return data
})