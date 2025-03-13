import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const classIds = await readBody(event)

  if (!classIds || !Array.isArray(classIds) || classIds.length === 0) {
    throw createError({
      message: "Class IDs are required",
      statusCode: 400,
    })
  }

  const { error } = await supabase
    .from("class")
    .delete()
    .in("id", classIds)

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }

  return { success: true }
})