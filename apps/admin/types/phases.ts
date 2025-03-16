import type { Database } from "~/types/database.types"

// Define the team type used in groups
export interface TeamInGroup {
  id: string
  name: string
}

// Define the group with teams
export interface GroupWithTeams {
  id: string
  name: string
  teams: TeamInGroup[]
}

// Define the result type
export interface MatchResult {
  match_id: string
  team1_score: number
  team2_score: number
  winner_id: string | null
}

// Define the match type with result
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

// Define the tournament winner type
export interface TournamentWinner {
  team_id: string
  position: number
}

// Define the tournament phases structure
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