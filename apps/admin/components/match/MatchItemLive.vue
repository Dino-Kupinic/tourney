<script setup lang="ts">
import type { Match } from "~/types/match"

const { match } = defineProps<{
  match: Match
}>()

const logoTeam1 = computed(() => {
  return match.team1?.logo_variant?.image_path ?? match.team1?.logo?.image_path
})
const logoTeam2 = computed(() => {
  return match.team2?.logo_variant?.image_path ?? match.team2?.logo?.image_path
})

const timeElapsed = ref<number>(0)
const isRunning = ref<boolean>(false)

const { resume } = useIntervalFn(
  () => {
    timeElapsed.value++
  },
  1000,
  { immediate: true },
)

const startStopwatch = () => {
  isRunning.value = true
  resume()
}
startStopwatch()

const formattedTime = computed(() => {
  const minutes = Math.floor(timeElapsed.value / 60)
  const seconds = timeElapsed.value % 60
  return `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`
})

const score1 = ref<number>(0)
const score2 = ref<number>(0)

const winner = computed(() => {
  if (score1.value > score2.value) {
    return match.team1
  } else if (score1.value < score2.value) {
    return match.team2
  } else {
    return null
  }
})

const isOpenConfirm = ref<boolean>(false)
const liveMatches = useState<Match[]>("liveMatches")
const completeMatch = () => {
  isOpenConfirm.value = false
}
</script>

<template>
  <ModalMatch v-model="isOpenConfirm" @confirm="completeMatch">
    <p>
      {{ match.team1?.name }} hat <strong>{{ score1 }}</strong> Punkt(e) <br />
      {{ match.team2?.name }} hat <strong>{{ score2 }}</strong> Punkt(e)
    </p>
    <br />
    <p>
      Anhand von diesen Angaben, wird
      <strong class="text-primary-500">{{ winner?.name ?? "keiner" }}</strong>
      der Gewinner.
    </p>
    <p v-if="winner === null">Somit ein Unentschieden.</p>
  </ModalMatch>
  <div
    class="flex w-96 flex-col items-center justify-between gap-1 rounded-md border border-gray-200 px-6 py-3 shadow-sm dark:border-gray-700"
  >
    <div>
      <p class="font-mono text-xs">{{ match.round }} - {{ formattedTime }}</p>
      <p class="text-center text-xs italic text-gray-500">
        gestartet um {{ match.start_time }}
      </p>
    </div>
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
        <div class="space-x-0.5">
          <UButton
            :ui="{ rounded: 'rounded-full' }"
            size="2xs"
            color="gray"
            square
            icon="i-heroicons-minus"
            @click="score1--"
          />
          <UButton
            :ui="{ rounded: 'rounded-full' }"
            size="2xs"
            color="gray"
            square
            icon="i-heroicons-plus"
            @click="score1++"
          />
        </div>
      </div>
      <div class="flex items-center gap-5">
        <p class="text-4xl font-bold">{{ score1 }}</p>
        <p>vs</p>
        <p class="text-4xl font-bold">{{ score2 }}</p>
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
        <div class="space-x-0.5">
          <UButton
            :ui="{ rounded: 'rounded-full' }"
            size="2xs"
            color="gray"
            square
            icon="i-heroicons-minus"
            @click="score2--"
          />
          <UButton
            :ui="{ rounded: 'rounded-full' }"
            size="2xs"
            color="gray"
            square
            icon="i-heroicons-plus"
            @click="score2++"
          />
        </div>
      </div>
    </div>
    <UButton
      icon="i-heroicons-hand-raised"
      variant="soft"
      color="fuchsia"
      label="Spiel beenden..."
      size="2xs"
      @click="isOpenConfirm = true"
    />
  </div>
</template>
