import { serverSupabaseClient } from "#supabase/server"
import type { Database } from "~/types/database.types"
import type { Match } from "~/types/match"

export default defineEventHandler(async (event) => {
  const supabase = await serverSupabaseClient<Database>(event)
  const id = getRouterParam(event, "id")

  if (!id) {
    throw createError({
      message: "Tournament id missing",
      statusCode: 400,
    })
  }

  // Fetch all matches for this tournament, grouped by phase
  const { data: matches, error } = await supabase
    .from("matches_status")
    .select(
      "*, team1:team1_id(*, group:group_id(*), logo:logo_id(*), logo_variant:logo_variant_id(*)), team2:team2_id(*, group:group_id(*), logo:logo_id(*), logo_variant:logo_variant_id(*))"
    )
    .eq("tournament_id", id)
    .order("start_time", { ascending: true })

  if (error) {
    throw createError({
      message: error.message,
      statusCode: 500,
    })
  }

  // Fetch groups for this tournament
  const { data: groups, error: groupsError } = await supabase
    .from("group")
    .select("*, teams:team(name)")
    .eq("tournament_id", id)

  if (groupsError) {
    throw createError({
      message: groupsError.message,
      statusCode: 500,
    })
  }

  // Format groups data
  const formattedGroups = groups?.map((group) => ({
    name: group.name,
    teams: group.teams?.map((team) => team.name) || [],
  })) || []

  // Group matches by tournament phase
  const matchesByPhase = matches?.reduce((acc, match) => {
    const phase = match.round
    if (!acc[phase]) {
      acc[phase] = []
    }
    acc[phase].push(match)
    return acc
  }, {} as Record<string, typeof matches>)

  // Determine winners for each phase
  const winners: Record<string, Record<string, string>> = {}

  // Process group stage winners
  if (matchesByPhase?.Gruppenphase) {
    winners.Gruppenphase = {}
    formattedGroups.forEach((group) => {
      // In a real implementation, this would calculate group standings
      // For now, we'll just take the first two teams from each group
      winners.Gruppenphase[group.name] = group.teams.slice(0, 2)
    })
  }

  // Process knockout stage winners
  const processPhaseWinners = (phase: string) => {
    if (matchesByPhase?.[phase]) {
      winners[phase] = {}
      matchesByPhase[phase].forEach((match, index) => {
        const matchId = `${phase.toLowerCase().replace(/[^a-z]/g, '')}_${index + 1}`
        if (match.team1_score !== null && match.team2_score !== null) {
          const winnerTeam = match.team1_score > match.team2_score 
            ? match.team1?.name 
            : match.team2?.name
          winners[phase][matchId] = winnerTeam || ''
        }
      })
    }
  }

  processPhaseWinners('Viertelfinale')
  processPhaseWinners('Semifinale')
  processPhaseWinners('Finale')

  return {
    groups: formattedGroups,
    results: {
      groupWinners: winners.Gruppenphase || {},
      quarterfinals: matchesByPhase?.Viertelfinale?.reduce((acc, match, index) => {
        const id = `qf${index + 1}`
        acc[id] = {
          teams: [match.team1?.name || 'Pending', match.team2?.name || 'Pending'],
          winner: winners.Viertelfinale?.[`viertelfinale_${index + 1}`] || null
        }
        return acc
      }, {} as Record<string, {teams: string[], winner: string | null}>) || {},
      semifinals: matchesByPhase?.Semifinale?.reduce((acc, match, index) => {
        const id = `sf${index + 1}`
        acc[id] = {
          teams: [match.team1?.name || 'Pending', match.team2?.name || 'Pending'],
          winner: winners.Semifinale?.[`semifinale_${index + 1}`] || null
        }
        return acc
      }, {} as Record<string, {teams: string[], winner: string | null}>) || {},
      final: matchesByPhase?.Finale?.[0] ? {
        teams: [
          matchesByPhase.Finale[0].team1?.name || 'Pending',
          matchesByPhase.Finale[0].team2?.name || 'Pending'
        ],
        winner: winners.Finale?.finale_1 || null
      } : {
        teams: ['Pending', 'Pending'],
        winner: null
      }
    }
  }
})