import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const id = getRouterParam(event, "id")

  if (id === undefined) {
    throw createError({
      message: "Registration id missing",
      statusCode: 400,
    })
  }

  const { data } = await supabase
    .from("registration")
    .select("*")
    .eq("id", id)
    .single()

  return data
})
