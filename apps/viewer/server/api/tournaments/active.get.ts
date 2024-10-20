import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"
import type { ParsedJsonTournament } from "~/types/prizes"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const currentDate = new Date().toISOString()

  const { data } = await supabase
    .from("tournament")
    .select("*")
    .gt("start_date", currentDate)

  return data as ParsedJsonTournament[] | null
})
