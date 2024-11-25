import { serverSupabaseClient } from "#supabase/server"
import type { Database, Tables } from "~/types/database.types"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const id = getRouterParam(event, "id")

  if (id === undefined) {
    throw createError({
      message: "Logo id missing",
      statusCode: 400,
    })
  }

  const { data } = await supabase
    .from("logo_variant")
    .select("*")
    .eq("logo_id", id)

  return data
})
