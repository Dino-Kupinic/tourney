import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"
import type { Match } from "~/types/match"

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
    .from("match")
    .select(
      "*, team1:team!match_team1_id_fkey(*, group:group_id(*), logo:logo_id(*), logo_variant:logo_variant_id(*)), team2:team!match_team2_id_fkey(*, group:group_id(*), logo:logo_id(*), logo_variant:logo_variant_id(*))",
    )
    .eq("tournament_id", id)
    .order("start_time", { ascending: true })

  return (data ?? []) as Match[]
})
