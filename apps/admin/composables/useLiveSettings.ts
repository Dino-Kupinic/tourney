export const useLiveSettings = () => {
  const storedGroupedStandings = useCookie<boolean>(
    "admin-live-grouped-standings",
    {
      default: () => true,
    },
  )
  const showGroupedStandings = useState<boolean>(
    "admin-live-grouped-standings",
    () => storedGroupedStandings.value ?? true,
  )

  if (import.meta.server) {
    showGroupedStandings.value = storedGroupedStandings.value ?? true

    return {
      showGroupedStandings,
    }
  }

  const isInitialized = useState<boolean>(
    "admin-live-grouped-standings-initialized",
    () => false,
  )

  if (!isInitialized.value) {
    showGroupedStandings.value = storedGroupedStandings.value ?? true

    watch(
      showGroupedStandings,
      (value) => {
        storedGroupedStandings.value = value
      },
      { immediate: true },
    )

    isInitialized.value = true
  }

  return {
    showGroupedStandings,
  }
}
