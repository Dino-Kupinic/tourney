export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)
  const id = getRouterParam(event, "id")

  if (!id) {
    throw createError({
      message: "Tournament id missing",
      statusCode: 400,
    })
  }

  // Get groups and teams for the tournament
  const { data: groups, error: groupsError } = await supabase
    .from("group")
    .select("id, name")
    .eq("tournament_id", id)

  if (groupsError) {
    throw createError({
      message: groupsError.message,
      statusCode: 500,
    })
  }

  // Get teams for each group
  const groupsWithTeams = await Promise.all(
    groups.map(async (group) => {
      const { data: teams, error: teamsError } = await supabase
        .from("team")
        .select("id, name")
        .eq("group_id", group.id)

      if (teamsError) {
        throw createError({
          message: teamsError.message,
          statusCode: 500,
        })
      }

      return {
        id: group.id,
        name: group.name,
        teams: teams || [],
      }
    })
  )

  // Get all matches for the tournament
  const { data: matches, error: matchesError } = await supabase
    .from("matches_status")
    .select("*")
    .eq("tournament_id", id)
    .order("start_time", { ascending: true })

  if (matchesError) {
    throw createError({
      message: matchesError.message,
      statusCode: 500,
    })
  }

  // Get results for matches
  const { data: results, error: resultsError } = await supabase
    .from("result")
    .select("match_id, team1_score, team2_score, winner_id")
    .in(
      "match_id",
      matches.map((match) => match.match_id)
    )

  if (resultsError) {
    throw createError({
      message: resultsError.message,
      statusCode: 500,
    })
  }

  // Get tournament winner if exists
  const { data: tournamentResults, error: tournamentResultsError } = await supabase
    .from("tournament_result")
    .select("team_id, position")
    .eq("tournament_id", id)
    .eq("position", 1)
    .limit(1)

  if (tournamentResultsError) {
    throw createError({
      message: tournamentResultsError.message,
      statusCode: 500,
    })
  }

  // Organize matches by phase
  const groupPhaseMatches = matches.filter((match) => match.round === "Gruppenphase")
  const quarterFinalMatches = matches.filter((match) => match.round === "Viertelfinale")
  const semiFinalMatches = matches.filter((match) => match.round === "Semifinale")
  const finalMatch = matches.find((match) => match.round === "Finale")
  const thirdPlaceMatch = matches.find((match) => match.round === "Kleines Finale")

  // Add results to matches
  const matchesWithResults = matches.map((match) => {
    const result = results.find((r) => r.match_id === match.match_id)
    return {
      ...match,
      result: result || null,
    }
  })

  return {
    groups: groupsWithTeams,
    matches: matchesWithResults,
    phases: {
      groupPhase: groupPhaseMatches,
      quarterFinals: quarterFinalMatches,
      semiFinals: semiFinalMatches,
      final: finalMatch || null,
      thirdPlace: thirdPlaceMatch || null,
    },
    winner: tournamentResults && tournamentResults.length > 0 ? tournamentResults[0] : null,
  }
})
