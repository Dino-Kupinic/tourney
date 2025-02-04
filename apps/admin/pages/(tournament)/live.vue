<script setup lang="ts">
import type { Group } from "~/types/group"
import type { ParsedJsonTournament } from "~/types/prizes"

const title = ref<string>("Live")
useHead({
  title: () => title.value,
})

const { tournaments, fetchTournaments } = useLiveTournaments()
await fetchTournaments()
const selected = ref(tournaments.value[0])

const { data: tournament } = await useFetch<ParsedJsonTournament | null>(
  `/api/tournaments/${selected.value.id}`,
)
if (!tournament.value) {
  throw createError({
    statusCode: 404,
    message: "Turnier nicht gefunden",
  })
}
const { data: groups } = await useFetch(
  `/api/tournaments/${tournament.value.id}/groups`,
)
const flowGroups = computed<Group[]>(() => {
  return (
    groups.value?.map((group) => ({
      name: group.name,
      teams: group.teams.map((team) => team.name),
    })) ?? []
  )
})

const timeElapsed = ref(0)
const isRunning = ref(false)

const { pause, resume } = useIntervalFn(
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

const stopStopwatch = () => {
  isRunning.value = false
  pause()
}

const resetStopwatch = () => {
  stopStopwatch()
  timeElapsed.value = 0
}
startStopwatch()

const formattedTime = computed(() => {
  const minutes = Math.floor(timeElapsed.value / 60)
  const seconds = timeElapsed.value % 60
  return `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`
})
</script>

<template>
  <BasePageHeader :title="title">
    <USelect
      :options="tournaments"
      v-model="selected"
      size="xs"
      value-attribute="id"
      option-attribute="name"
    />
  </BasePageHeader>
  <BasePageContent>
    <div class="h-full w-full">
      <!--      <div class="h-1/3">-->
      <!--        <ClientOnly>-->
      <!--          <TournamentFlow-->
      <!--            :groups="flowGroups"-->
      <!--            :key="JSON.stringify(flowGroups)"-->
      <!--          />-->
      <!--          <template #fallback>-->
      <!--            <div-->
      <!--              class="flex h-full w-full items-center justify-center bg-gray-100 dark:bg-gray-800"-->
      <!--            >-->
      <!--              <UIcon name="i-svg-spinners-180-ring-with-bg" size="24" />-->
      <!--            </div>-->
      <!--          </template>-->
      <!--        </ClientOnly>-->
      <!--      </div>-->
      <div
        class="flex h-2/3 flex-col border-t border-gray-200 p-6 dark:border-gray-700"
      >
        <strong>Punkte</strong>
        <strong>Spiele</strong>
        <strong>Live</strong>
        <!-- todo: gradient based on team color -->
        <div
          class="flex w-80 flex-col items-center justify-between gap-1 rounded-md border px-6 py-3"
        >
          <div>
            <p class="font-mono">Gruppenphase - {{ formattedTime }}</p>
            <p class="text-center text-xs italic text-gray-500">
              gestartet um 11:30
            </p>
          </div>
          <div class="flex w-full items-center justify-between">
            <div class="flex flex-col items-center space-y-1">
              <UIcon name="i-game-icons-heartburn" size="40" />
              <p class="text-xs">1AHITN</p>
              <div class="space-x-0.5">
                <UButton
                  :ui="{ rounded: 'rounded-full' }"
                  size="xs"
                  color="gray"
                  square
                  icon="i-heroicons-minus"
                />
                <UButton
                  :ui="{ rounded: 'rounded-full' }"
                  size="xs"
                  color="gray"
                  square
                  icon="i-heroicons-plus"
                />
              </div>
            </div>
            <div class="flex items-center gap-5">
              <p class="text-4xl font-bold">2</p>
              <p>vs</p>
              <p class="text-4xl font-bold">0</p>
            </div>
            <div class="flex flex-col items-center space-y-1">
              <UIcon name="i-game-icons-dragon-head" size="40" />
              <p class="text-xs">2AHITN</p>
              <div class="space-x-0.5">
                <UButton
                  :ui="{ rounded: 'rounded-full' }"
                  size="xs"
                  color="gray"
                  square
                  icon="i-heroicons-minus"
                />
                <UButton
                  :ui="{ rounded: 'rounded-full' }"
                  size="xs"
                  color="gray"
                  square
                  icon="i-heroicons-plus"
                />
              </div>
            </div>
          </div>
          <UButton
            icon="i-heroicons-hand-raised"
            variant="soft"
            color="fuchsia"
            label="Spiel beenden..."
            size="xs"
          />
        </div>
      </div>
    </div>
  </BasePageContent>
</template>
