import type { ParsedJsonTournament } from "@tourney/types"

export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
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
