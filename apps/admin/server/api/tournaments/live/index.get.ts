import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"
import type { ParsedJsonTournament } from "~/types/prizes"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const { data } = await supabase
    .from("tournament")
    .select("*")
    .eq("is_live", true)

  return data as ParsedJsonTournament[] | null
})
