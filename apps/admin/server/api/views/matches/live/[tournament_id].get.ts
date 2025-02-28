import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"
import type { Match } from "~/types/match"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const id = getRouterParam(event, "tournament_id")

  if (!id) {
    throw createError({
      message: "Id is missing",
      statusCode: 400,
    })
  }

  const { data, error } = await supabase
    .from("matches_status")
    .select(
      "*, team1:team1_id(*, group:group_id(*), logo:logo_id(*), logo_variant:logo_variant_id(*)), team2:team2_id(*, group:group_id(*), logo:logo_id(*), logo_variant:logo_variant_id(*))",
    )
    .eq("tournament_id", id)
    .eq("status", "live")
    .order("start_time", { ascending: true })

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }

  return data
})
