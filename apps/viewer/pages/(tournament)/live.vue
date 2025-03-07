<script setup lang="ts">
import type { ParsedJsonTournament } from "~/types/prizes"
import type { Match } from "~/types/match"

const { tournaments, fetchTournaments } = useLiveTournaments()
const selected = useState<string>("selectedTournament", () => "")
await fetchTournaments()
if (!selected.value && tournaments.value.length > 0) {
  selected.value = tournaments.value[0].id
}

// const refreshing = ref(false)
// const target = useTemplateRef("target")
// const { isSwiping, direction } = useSwipe(target)
//
// watch(direction, (newDirection) => {
//   if (newDirection === "down" && !refreshing.value) {
//     refreshing.value = true
//     setTimeout(async () => {
//       await refreshTournaments()
//       refreshing.value = false
//     }, 1000)
//   }
// })

const { data: tournament, refresh: tournamentRefresh } =
  await useFetch<ParsedJsonTournament | null>(
    () => `/api/tournaments/${selected.value}`,
  )
if (!tournament.value) {
  throw createError({
    statusCode: 404,
    message: "Turnier nicht gefunden",
  })
}

const { data: matches, refresh: matchRefresh } = await useFetch<Match[]>(
  `/api/views/matches/${tournament.value.id}`,
)

const { data: liveMatches, refresh: refreshLiveMatches } = await useFetch<
  Match[]
>(`/api/views/matches/live/${tournament.value.id}`)

const refresh = async () => {
  await tournamentRefresh()
  await matchRefresh()
  await refreshLiveMatches()
}

const supabase = useSupabaseClient()

const channels = supabase
  .channel("custom-update-channel")
  .on(
    "postgres_changes",
    { event: "*", schema: "public", table: "matches_status" },
    (payload) => {
      console.log("Change received!", payload)
    },
  )
  .subscribe()
</script>

<template>
  <!--  <div v-if="refreshing" class="flex h-24 w-full items-center justify-center">-->
  <!--    <UIcon name="i-svg-spinners-6-dots-rotate" class="h-8 w-8" />-->
  <!--  </div>-->
  <div ref="target" class="h-full w-full">
    <div
      class="w-full border-b bg-gray-50 p-3 dark:border-gray-700 dark:bg-gray-900"
    >
      <USelect
        :options="tournaments"
        v-model="selected"
        size="lg"
        value-attribute="id"
        option-attribute="name"
      />
    </div>
    <div
      class="flex h-48 items-center justify-center border-b bg-gray-50 dark:border-gray-700 dark:bg-gray-900"
    >
      <p>Visualisierung fehlgeschlagen</p>
    </div>
    <div class="flex flex-col gap-2 p-3">
      <div class="flex flex-col gap-1.5">
        <div>
          <div
            class="flex items-center justify-center space-x-1.5 rounded-md bg-red-50 px-2.5 py-0.5 ring-1 ring-inset ring-red-500 ring-opacity-25 dark:bg-red-500 dark:bg-opacity-10 dark:ring-red-400 dark:ring-opacity-25"
          >
            <span class="relative flex h-2 w-2">
              <span
                class="absolute inline-flex h-full w-full animate-ping rounded-full bg-red-400 opacity-75"
              ></span>
              <span
                class="relative inline-flex h-2 w-2 rounded-full bg-red-500"
              ></span>
            </span>
            <p class="text-sm font-medium text-red-500 dark:text-red-400">
              Live
            </p>
          </div>
        </div>
        <MatchItemLive
          v-for="match in liveMatches"
          :key="match.match_id!"
          :match
        />
      </div>
      <div class="flex flex-col gap-1.5">
        <UDivider>Anstehende Spiele</UDivider>
        <div
          class="flex h-[30rem] flex-col gap-1.5 overflow-auto rounded-md bg-gray-50 p-3 pb-8 dark:bg-gray-900"
        >
          <MatchItemRow
            v-for="(match, index) in matches"
            :match
            :next="index < 2"
            :key="match.match_id!"
          />
        </div>
      </div>
    </div>
  </div>
</template>
