import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const id = getRouterParam(event, "tournament_id")

  if (id === undefined) {
    throw createError({
      message: "Id is missing",
      statusCode: 400,
    })
  }

  const { data } = await supabase
    .from("team_standings")
    .select("*")
    .eq("tournament_id", id)

  return data
})
