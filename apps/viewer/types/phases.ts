import type { Database } from "~/types/database.types"

export interface TeamInGroup {
  id: string
  name: string
}

export interface GroupWithTeams {
  id: string
  name: string
  teams: TeamInGroup[]
}

export interface MatchResult {
  match_id: string
  team1_score: number
  team2_score: number
  winner_id: string | null
}

export interface TournamentMatch {
  match_id: string | null
  round: Database["public"]["Enums"]["tournament_phase"] | null
  start_time: string | null
  end_time: string | null
  status: string | null
  team1_id: string | null
  team1_name: string | null
  team2_id: string | null
  team2_name: string | null
  tournament_id: string | null
  result: MatchResult | null
}

export interface TournamentWinner {
  team_id: string
  position: number
}

export interface TournamentPhases {
  groups: GroupWithTeams[]
  matches: TournamentMatch[]
  phases: {
    groupPhase: TournamentMatch[]
    quarterFinals: TournamentMatch[]
    semiFinals: TournamentMatch[]
    final: TournamentMatch | null
    thirdPlace: TournamentMatch | null
  }
  winner: TournamentWinner | null
}
