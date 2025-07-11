import type { ParsedJsonTournament } from "@tourney/types"

export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const currentDate = new Date().toISOString()

  const { data } = await supabase
    .from("tournament")
    .select("*")
    .gt("start_date", currentDate)

  return data as ParsedJsonTournament[] | null
})
