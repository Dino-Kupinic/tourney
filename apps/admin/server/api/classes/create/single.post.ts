import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const body = await readBody(event)

  const { name, year } = body

  if (!name || !year) {
    throw createError({
      message: "Name and year are required",
      statusCode: 400,
    })
  }

  const { data, error } = await supabase
    .from("class")
    .insert({ name, year })
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