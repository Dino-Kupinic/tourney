<script setup lang="ts">
import type { ParsedJsonTournament } from "~/types/prizes"
import type { Match } from "~/types/match"
import type { Standing } from "~/types/standing"

const { tournaments, fetchTournaments } = useLiveTournaments()
const selected = useState<string>("selectedTournament", () => "")
await fetchTournaments()
if (!selected.value && tournaments.value.length > 0) {
  selected.value = tournaments.value[0].id
}

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

const { data: groups } = tournament.value
  ? await useFetch(`/api/groups/${tournament.value.id}`)
  : { data: ref(null) }

const selectedGroup = useState<string>("selectedGroup", () => "")
if (groups.value && groups.value.length > 0) {
  selectedGroup.value = groups.value[0].id
}

const { data: standings, refresh: standingsRefresh } = selectedGroup.value
  ? await useFetch<Standing[]>(
      () => `/api/views/standings/group/${selectedGroup.value}`,
    )
  : { data: ref([]), refresh: () => Promise.resolve() }

watch(selectedGroup, async () => {
  if (selectedGroup.value) {
    await standingsRefresh()
  }
})

const { data: liveMatches, refresh: refreshLiveMatches } = await useFetch<
  Match[]
>(`/api/views/matches/live/${tournament.value.id}`)

const refresh = async () => {
  await tournamentRefresh()
  await matchRefresh()
  await refreshLiveMatches()
  await refreshHistory()
}

const supabase = useSupabaseClient()
supabase
  .channel("channel-match")
  .on(
    "postgres_changes",
    { event: "*", schema: "public", table: "match" },
    async () => {
      await refresh()
    },
  )
  .on(
    "postgres_changes",
    { event: "*", schema: "public", table: "result" },
    async () => {
      await refresh()
    },
  )
  .subscribe()

const { data: history, refresh: refreshHistory } = await useFetch(
  `/api/results/${tournament.value.id}`,
)

const { data: results, refresh: refreshResults } = await useFetch(
  `/api/tournament_results/${tournament.value.id}`,
)

const getTeamName = (index: number) =>
  computed(() => {
    if (!results.value) return
    // @ts-ignore
    return results.value?.[index]?.team?.name
  })

const first = getTeamName(0)
const second = getTeamName(1)
const third = getTeamName(2)
const fourth = getTeamName(3)

const { isDesktop } = useDevice()
</script>

<template>
  <PageHeader
    v-if="isDesktop"
    title="Live"
    description="Verfolge hier das Turnier"
  />
  <div
    :class="[
      'h-full w-full',
      isDesktop && 'rounded-md border dark:border-gray-800',
    ]"
  >
    <template v-if="tournaments.length">
      <div
        :class="[
          'w-full border-b bg-gray-50 p-3 dark:border-gray-700 dark:bg-gray-900',
          isDesktop ? 'rounded-t-md' : '',
        ]"
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

      <div
        :class="[
          isDesktop ? 'lg:grid lg:grid-cols-2 lg:gap-4' : 'flex flex-col gap-2',
          'p-3',
        ]"
      >
        <template v-if="results?.length">
          <div class="lg:col-span-2">
            <PageHeading>Gewinner</PageHeading>
            <TournamentPlaces
              :first="first"
              :second="second"
              :third="third"
              :fourth="fourth"
            />
          </div>
        </template>

        <template v-else>
          <div class="flex flex-col gap-1.5 lg:col-span-2">
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
            <div
              class="flex flex-col gap-1.5 rounded-md bg-gray-50 p-3 dark:bg-gray-900"
            >
              <template v-if="liveMatches?.length">
                <div
                  :class="[isDesktop ? 'lg:grid lg:grid-cols-2 lg:gap-3' : '']"
                >
                  <MatchItemLive
                    v-for="match in liveMatches"
                    :key="match.match_id!"
                    :match
                    class="lg:min-w-0"
                  />
                </div>
              </template>
              <template v-else>
                <UAlert
                  icon="i-heroicons-information-circle"
                  color="primary"
                  variant="soft"
                  title="Zurzeit keine Live Spiele"
                  description="Das nächste Spiel beginnt in Kürze."
                />
              </template>
            </div>
          </div>

          <div class="flex flex-col gap-1.5">
            <UDivider>Anstehende Spiele</UDivider>
            <div
              class="flex h-96 flex-col gap-1.5 overflow-auto rounded-md bg-gray-50 p-3 pb-8 dark:bg-gray-900"
            >
              <MatchItemRow
                v-for="(match, index) in matches"
                :match
                :next="index < 2"
                :key="match.match_id!"
              />
            </div>
          </div>

          <div class="flex flex-col gap-1.5">
            <UDivider>Historie</UDivider>
            <div
              class="flex h-96 flex-col gap-1.5 overflow-auto rounded-md bg-gray-50 p-3 pb-8 dark:bg-gray-900"
            >
              <!-- @vue-ignore -->
              <ResultItem
                v-for="result in history"
                :match="result.match as Match"
                :id="result.id"
                :score1="result.team1_score"
                :score2="result.team2_score"
                :winner="result.winner_id"
              />
            </div>
          </div>

          <div class="flex flex-col gap-1.5 lg:col-span-2">
            <UDivider>Platzierungen</UDivider>
            <USelect
              v-if="groups"
              :options="groups"
              v-model="selectedGroup"
              size="lg"
              value-attribute="id"
              option-attribute="name"
            />
            <StandingsTable
              v-if="standings"
              :standings="standings"
              class="lg:max-w-full"
            />
          </div>
        </template>
      </div>
    </template>
    <template v-else>
      <div class="p-3">
        <UAlert
          icon="i-heroicons-information-circle"
          color="primary"
          variant="soft"
          title="Keine Live Turniere gefunden"
          description="Entweder gibt es keine Turniere oder ein Fehler ist aufgetreten. Oder es geht bald los!"
        />
      </div>
    </template>
  </div>
</template>
