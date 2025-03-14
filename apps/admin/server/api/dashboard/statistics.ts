import type { DashboardStatistics } from "~/types/dashboard"

export default defineEventHandler(async (event) => {
  const supabase = await useDatabase(event)

  const stats: DashboardStatistics = {
    tournaments: {
      total: 0,
    },
    teams: {
      total: 0,
    },
    registrations: {
      total: 0,
    },
    matches: {
      total: 0,
    },
  }

  try {
    const { count: totalTournaments } = await supabase
      .from("tournament")
      .select("*", { count: "exact" })

    if (totalTournaments) {
      stats.tournaments.total = totalTournaments
    }

    const { count: totalTeams } = await supabase
      .from("team")
      .select("*", { count: "exact", head: true })

    if (totalTeams) {
      stats.teams.total = totalTeams
    }

    const { data: registrations, count: totalRegistrations } = await supabase
      .from("registration")
      .select("*", { count: "exact" })

    if (totalRegistrations) {
      stats.registrations.total = totalRegistrations
    }

    const { data: matches, count: totalMatches } = await supabase
      .from("match")
      .select("*", { count: "exact" })

    if (totalMatches) {
      stats.matches.total = totalMatches
    }

    return stats
  } catch (error) {
    console.error("Error fetching dashboard statistics:", error)
    throw createError({
      statusCode: 500,
      statusMessage: "Failed to fetch dashboard statistics",
    })
  }
})
