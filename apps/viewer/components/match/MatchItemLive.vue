<script setup lang="ts">
import type { Match } from "~/types/match"

const { match } = defineProps<{ match: Match }>()

const logoTeam1 = computed(
  () => match.team1?.logo_variant?.image_path ?? match.team1?.logo?.image_path,
)
const logoTeam2 = computed(
  () => match.team2?.logo_variant?.image_path ?? match.team2?.logo?.image_path,
)

const timeElapsed = ref<number>(0)
const isRunning = ref<boolean>(false)

const now = useTimestamp({ immediate: true })

const calculateElapsedTime = () => {
  if (!match.start_time) return
  const [hours, minutes, seconds] = match.start_time.split(":").map(Number)
  const startDateTime = new Date()
  startDateTime.setHours(hours, minutes, seconds || 0, 0)
  const startTimeMs = startDateTime.getTime()
  timeElapsed.value = now.value - startTimeMs
}

calculateElapsedTime()

const { resume } = useIntervalFn(
  () => {
    timeElapsed.value += 1
  },
  1,
  { immediate: true },
)

const startStopwatch = () => {
  isRunning.value = true
  resume()
}

startStopwatch()

const formattedTime = computed(() => {
  const totalSeconds = Math.floor(timeElapsed.value / 1000)
  const minutes = Math.floor(totalSeconds / 60)
  const seconds = totalSeconds % 60
  const milliseconds = timeElapsed.value % 1000

  return `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}.${String(milliseconds).padStart(3, "0")}`
})
</script>

<template>
  <div class="rounded-md border border-gray-200 shadow-sm dark:border-gray-700">
    <div
      class="flex justify-between gap-0.5 rounded-t-md border-b border-gray-200 bg-gray-100 p-0.5 dark:border-gray-700 dark:bg-gray-800"
    >
      <div class="flex gap-0.5">
        <UBadge
          :label="match.round ?? 'Unbekannte Runde'"
          color="fuchsia"
          size="xs"
          variant="subtle"
          block
        />
        <UBadge
          :label="match.start_time!"
          color="indigo"
          size="xs"
          variant="subtle"
          icon="i-heroicons-clock"
          block
        />
      </div>
      <ClientOnly>
        <UBadge
          :label="formattedTime"
          icon="i-heroicons-clock"
          color="primary"
          size="xs"
          variant="subtle"
          :trailing="false"
          class="w-[90px]"
          block
        />
      </ClientOnly>
    </div>
    <div class="flex flex-col items-center justify-between gap-1 px-6 py-3">
      <div class="flex w-full items-center justify-between">
        <div class="flex flex-col items-center space-y-1">
          <NuxtImg
            width="36"
            height="36"
            :src="getImageUrl(logoTeam1!)"
            :class="{
              'dark:invert dark:filter': match.team1?.logo_variant === null,
            }"
          />
          <p class="text-xs">{{ match.team1?.name }}</p>
        </div>
        <div class="flex items-center gap-5">
          <p class="text-lg">vs</p>
        </div>
        <div class="flex flex-col items-center space-y-1">
          <NuxtImg
            width="36"
            height="36"
            :src="getImageUrl(logoTeam2!)"
            :class="{
              'dark:invert dark:filter': match.team2?.logo_variant === null,
            }"
          />
          <p class="text-xs">{{ match.team2?.name }}</p>
        </div>
      </div>
    </div>
  </div>
</template>
