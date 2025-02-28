import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"

type Body = {
  id: string
  start_time?: string
}

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const { id, start_time } = await readBody<Body>(event)

  if (!id) {
    throw createError({
      statusCode: 400,
      statusMessage: "Missing match id",
    })
  }

  const { error } = await supabase
    .from("match")
    .update({ is_live: true })
    .eq("id", id)

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }

  if (start_time) {
    const { error: startTimeError } = await supabase
      .from("match")
      .update({ start_time: start_time })
      .eq("id", id)

    if (startTimeError) {
      throw createError({
        message: startTimeError.message,
        statusCode: 500,
      })
    }
  }
})
