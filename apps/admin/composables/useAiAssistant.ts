export const useAiAssistant = () => {
  const storedPreference = useCookie<boolean>("admin-ai-assistant-enabled", {
    default: () => false,
  })
  const enabled = useState<boolean>(
    "admin-ai-assistant-enabled",
    () => storedPreference.value ?? false,
  )
  const collapsed = useState<boolean>(
    "admin-ai-assistant-collapsed",
    () => false,
  )

  if (import.meta.server) {
    enabled.value = storedPreference.value ?? false
    return {
      collapsed,
      enabled,
    }
  }

  const isInitialized = useState<boolean>(
    "admin-ai-assistant-enabled-initialized",
    () => false,
  )

  if (!isInitialized.value) {
    enabled.value = storedPreference.value ?? false

    watch(
      enabled,
      (value) => {
        storedPreference.value = value
      },
      { immediate: true },
    )

    watch(enabled, (value, oldValue) => {
      if (value && oldValue === false) {
        collapsed.value = false
      }
    })

    isInitialized.value = true
  }

  return {
    collapsed,
    enabled,
  }
}
