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

let lastTimestamp = Date.now()
const { resume } = useIntervalFn(
  () => {
    const currentTimestamp = Date.now()
    const delta = currentTimestamp - lastTimestamp
    timeElapsed.value += delta
    lastTimestamp = currentTimestamp
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
          color="white"
          size="xs"
          icon="i-heroicons-clock"
          block
        />
      </div>
      <ClientOnly>
        <UBadge
          :label="formattedTime"
          icon="i-heroicons-clock"
          color="white"
          size="xs"
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
          <p class="text-xs text-gray-500">{{ match.team1?.group?.name }}</p>
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
          <p class="text-xs text-gray-500">{{ match.team2?.group?.name }}</p>
        </div>
      </div>
    </div>
  </div>
</template>
