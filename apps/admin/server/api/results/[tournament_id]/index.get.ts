export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const tournamentId = getRouterParam(event, "tournament_id")

  if (!tournamentId) {
    throw createError({
      statusCode: 400,
      statusMessage: "Missing tournament id",
    })
  }

  const { data: matches, error: matchError } = await supabase
    .from("match")
    .select("id, start_time")
    .eq("tournament_id", tournamentId)
    .order("start_time", { ascending: true })

  if (matchError) {
    throw createError({
      message: matchError.message,
      statusCode: 500,
    })
  }

  const matchIds = matches.map((match) => match.id)
  if (matchIds.length === 0) {
    return []
  }

  const { data: results, error: resultError } = await supabase
    .from("result")
    .select(
      "*, match:match_id(*, team1:team1_id(*, group:group_id(*), logo:logo_id(*), logo_variant:logo_variant_id(*)), team2:team2_id(*, group:group_id(*), logo:logo_id(*), logo_variant:logo_variant_id(*)))",
    )
    .in("match_id", matchIds)

  if (resultError) {
    throw createError({
      message: resultError.message,
      statusCode: 500,
    })
  }

  const matchOrderMap = new Map<string, number>(
    matches.map((match, index) => [match.id, index]),
  )
  results.sort((a, b) => {
    const indexA = matchOrderMap.get(a.match_id) ?? Number.MAX_SAFE_INTEGER
    const indexB = matchOrderMap.get(b.match_id) ?? Number.MAX_SAFE_INTEGER
    return indexB - indexA
  })

  return results
})
