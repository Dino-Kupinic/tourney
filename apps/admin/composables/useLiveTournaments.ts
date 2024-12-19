export const useLiveTournaments = () => {
  const liveTournaments = useState<number>("liveTournaments", () => 0)

  const fetchLiveTournaments = async () => {
    const { data } = await useFetch("/api/tournaments/live/count")
    liveTournaments.value = data.value ?? 0
  }

  return {
    liveTournaments,
    fetchLiveTournaments,
  }
}
