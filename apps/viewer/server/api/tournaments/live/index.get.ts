import type { ParsedJsonTournament } from "@tourney/types"

export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const { data } = await supabase
    .from("tournament")
    .select("*")
    .eq("is_live", true)

  return data as ParsedJsonTournament[] | null
})
