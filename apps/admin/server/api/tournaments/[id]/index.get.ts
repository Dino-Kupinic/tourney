import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"
import type { ParsedJsonTournament } from "~/types/prizes"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const id = getRouterParam(event, "id")

  if (id === undefined) {
    throw createError({
      message: "Tournament id missing",
      statusCode: 400,
    })
  }

  const { data } = await supabase
    .from("tournament")
    .select("*")
    .eq("id", id)
    .single()

  return data as ParsedJsonTournament | null
})
