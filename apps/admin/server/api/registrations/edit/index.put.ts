import type { Database, Enums } from "~/types/database.types"
import { serverSupabaseClient } from "#supabase/server"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const { id, expire_date, status, allow_class_mixing } = await readBody<{
    id: string
    expire_date: string
    name: string
    status: Enums<"registration_status">
    allow_class_mixing: boolean
    class: string
  }>(event)

  const { error } = await supabase
    .from("registration")
    .update({ expire_date, status, allow_class_mixing })
    .eq("id", id)

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }

  setResponseStatus(event, 201)
})
