import type { Tables } from "@tourney/types"

export const useLiveTournaments = () => {
  const liveTournaments = useState<number>("liveTournamentsCount", () => 0)
  const tournaments = useState<Tables<"tournament">[]>(
    "liveTournaments",
    () => [],
  )

  const fetchLiveTournaments = async () => {
    const { data } = await useFetch("/api/tournaments/live/count")
    liveTournaments.value = data.value ?? 0
  }

  const fetchTournaments = async () => {
    const { data } = await useFetch("/api/tournaments/live")
    tournaments.value = data.value ?? []
  }

  return {
    tournaments,
    liveTournaments,
    fetchLiveTournaments,
    fetchTournaments,
  }
}
