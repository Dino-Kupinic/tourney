import type { ParsedJsonTournament } from "@tourney/types"

export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const { data } = await supabase.from("tournament").select("*")

  return data as ParsedJsonTournament[] | null
})
