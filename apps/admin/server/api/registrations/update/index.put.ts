import { serverSupabaseClient } from "#supabase/server"
import type { Database, Enums } from "~/types/database.types"

export default defineEventHandler(async (event) => {
  const { registrations, status } = await readBody<{
    registrations: string[]
    status: Enums<"registration_status">
  }>(event)
  const supabase = await serverSupabaseClient<Database>(event)

  const { error } = await supabase
    .from("registration")
    .update({ status: status })
    .in("id", registrations)

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }

  setResponseStatus(event, 204, "success")
})
