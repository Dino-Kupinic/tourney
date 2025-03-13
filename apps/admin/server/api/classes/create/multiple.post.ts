import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const body = await readBody(event)

  const { prefix, count, year } = body

  if (!prefix || !count || !year) {
    throw createError({
      message: "Prefix, count, and year are required",
      statusCode: 400,
    })
  }

  if (count < 1 || count > 20) {
    throw createError({
      message: "Count must be between 1 and 20",
      statusCode: 400,
    })
  }

  const classes = []
  for (let i = 1; i <= count; i++) {
    // Create class names like "10a", "10b", etc.
    const className = `${prefix}${String.fromCharCode(96 + i)}`
    classes.push({ name: className, year })
  }

  const { data, error } = await supabase
    .from("class")
    .insert(classes)
    .select()

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }

  return data
})