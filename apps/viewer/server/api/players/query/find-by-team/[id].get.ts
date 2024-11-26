import type { Database } from "~/types/database.types"
import { serverSupabaseClient } from "#supabase/server"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const id = getRouterParam(event, "id")

  if (id === undefined) {
    throw createError({
      message: "Team id missing",
      statusCode: 400,
    })
  }

  const { data, error } = await supabase
    .from("player")
    .select("*")
    .eq("team_id", id)

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }

  return data
})
