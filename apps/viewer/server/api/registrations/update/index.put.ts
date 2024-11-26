import { serverSupabaseClient } from "#supabase/server"
import type { Database, Enums } from "~/types/database.types"

export default defineEventHandler(async (event) => {
  const { registration_id, status } = await readBody<{
    registration_id: string
    status: Enums<"registration_status">
  }>(event)
  const supabase = await serverSupabaseClient<Database>(event)

  const { error } = await supabase
    .from("registration")
    .update({ status: status })
    .eq("id", registration_id)

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }

  setResponseStatus(event, 200, "success")
})
