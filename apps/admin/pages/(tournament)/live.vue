<script setup lang="ts">
import { z } from "zod"
import type { Database, Match, ParsedJsonTournament, Standing } from "@tourney/types"
import { useDatabaseClient } from "~/composables/useDatabaseClient"

const title = ref<string>("Live")
useHead({
  title: () => title.value,
})

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

const isOpenInfo = ref<boolean>(false)
const { data: standings, refresh: standingsRefresh } = await useFetch<
  Standing[]
>(`/api/views/standings/${tournament.value.id}`)

const { data: liveMatches, refresh: refreshLiveMatches } = await useFetch<
  Match[]
>(`/api/views/matches/live/${tournament.value.id}`)

const refresh = async () => {
  await tournamentRefresh()
  await matchRefresh()
  await standingsRefresh()
  await refreshLiveMatches()
  await refreshResults()
  await refreshHistory()
  displaySuccessNotification(
    "Daten aktualisiert",
    "Die Daten wurden aktualisiert.",
  )
}

const refreshMatches = async () => {
  await matchRefresh()
  await refreshLiveMatches()
  await standingsRefresh()
  await refreshResults()
  await refreshHistory()
}

const schema = z.object({
  interval: z.number().int().positive(),
  start_time: z.string(),
})

const state = reactive({
  interval: 12,
  start_time: tournament.value?.from,
})

const supabase = useDatabaseClient()
const isOpenCreate = ref<boolean>(false)
const generateGroupMatches = async () => {
  try {
    schema.parse(state)
    const { error } = await supabase.rpc("generate_group_stage_matches", {
      p_interval_minutes: state.interval,
      p_start_time: state.start_time,
      p_tournament_id: tournament.value?.id!,
    })
    if (error) {
      displayFailureNotification(
        "Fehler",
        error.message || "Ein Fehler ist aufgetreten.",
      )
      console.error(error)
      return
    }
    await refreshMatches()
    displaySuccessNotification(
      "Gruppenphase gestartet",
      "Die Gruppenphase wurde erfolgreich gestartet.",
    )
    isOpenCreate.value = false
  } catch (error) {
    const err = error as Error
    displayFailureNotification("Fehler", err.message)
    throw createError({
      statusMessage: err.message,
    })
  }
}

const isOpenWinners = ref<boolean>(false)
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

const tabsMatches = [
  {
    slot: "matches",
    key: "matches",
    label: "Matches",
    icon: "i-heroicons-bars-4",
  },
  {
    slot: "history",
    key: "history",
    label: "Historie",
    icon: "i-heroicons-archive-box",
  },
]

const tabTable = [
  {
    label: "Platzierungen",
    icon: "i-heroicons-table-cells",
  },
]

const tabLive = [
  {
    label: "Live",
    icon: "i-heroicons-signal",
  },
]

const { data: history, refresh: refreshHistory } = await useFetch(
  `/api/results/${tournament.value.id}`,
)
</script>

<template>
  <BasePageHeader :title="title">
    <ToolbarContainer>
      <UButton
        size="xs"
        variant="soft"
        color="amber"
        label="Gewinner anzeigen"
        icon="i-heroicons-trophy"
        v-if="results?.length"
        @click="isOpenWinners = true"
      />
      <ModalInfo v-model="isOpenWinners">
        <TournamentPlaces
          v-if="results?.length"
          :first="first!"
          :second="second!"
          :third="third!"
          :fourth="fourth!"
        />
      </ModalInfo>
      <UButton
        size="xs"
        variant="soft"
        color="primary"
        label="Gruppenphase starten..."
        @click="isOpenCreate = true"
        v-if="!matches?.length && !liveMatches?.length && !results?.length"
      />
      <ModalCreate
        title="Gruppenphase starten"
        v-model="isOpenCreate"
        @create="generateGroupMatches"
        modal-width="sm:max-w-sm"
      >
        <UForm :schema="schema" :state="state" class="space-y-4 pt-2">
          <UFormGroup
            label="Matchlänge"
            name="interval"
            description="Matchlänge in Minuten, nach dieser Zeit folgt das nächste Match."
            required
          >
            <UInput v-model="state.interval" type="number" />
          </UFormGroup>

          <UFormGroup
            label="Startzeit"
            name="start_time"
            description="Startzeit der Gruppenphase. Standardmäßig die Turnierzeit."
            required
          >
            <UInput v-model="state.start_time" type="time" :step="60" />
          </UFormGroup>
        </UForm>
      </ModalCreate>
      <UButton
        icon="i-heroicons-arrow-path"
        color="gray"
        size="xs"
        square
        @click="refresh"
      />
      <USelect
        :options="tournaments"
        v-model="selected"
        size="xs"
        value-attribute="id"
        option-attribute="name"
      />
      <UButton
        @click="isOpenInfo = true"
        square
        color="white"
        icon="i-ic-round-question-mark"
        size="xs"
      />
      <ModalInfo v-model="isOpenInfo">
        <p>Punktetabelle Abkürzungen</p>
        <ul class="list-disc">
          <li class="ml-6">Pkt. = Punkte</li>
          <li class="ml-6">S = Siege</li>
          <li class="ml-6">U = Unentschieden</li>
          <li class="ml-6">N = Niederlagen</li>
          <li class="ml-6">T = Tore geschossen : Tore bekommen</li>
          <li class="ml-6">D = Tore Differenz</li>
        </ul>
      </ModalInfo>
    </ToolbarContainer>
  </BasePageHeader>
  <BasePageContent>
    <div class="h-full w-full">
      <div class="h-1/3">
        <ClientOnly>
          <LiveFlow :tournament-id="tournament?.id as string" />
          <template #fallback>
            <div
              class="flex h-full w-full items-center justify-center bg-gray-100 dark:bg-gray-800"
            >
              <UIcon name="i-svg-spinners-180-ring-with-bg" size="24" />
            </div>
          </template>
        </ClientOnly>
      </div>
      <div
        class="flex h-2/3 justify-between gap-6 border-t border-gray-200 p-6 pt-3 dark:border-gray-700"
      >
        <div class="flex w-1/3 flex-col gap-0.5">
          <UTabs
            :items="tabTable"
            :ui="{ list: { tab: { height: 'h-7' }, height: 'h-9' } }"
          />
          <StandingsTable v-if="standings" :standings="standings" />
        </div>
        <div class="flex w-1/3 flex-col gap-0.5">
          <UTabs
            :items="tabsMatches"
            :ui="{
              list: {
                base: 'relative mb-0.5',
                tab: { height: 'h-7' },
                height: 'h-9',
              },
            }"
          >
            <template #icon="{ item, selected }">
              <UIcon
                :name="item.icon"
                class="me-2 h-4 w-4 flex-shrink-0"
                :class="[selected && 'text-primary-500 dark:text-primary-400']"
              />
            </template>

            <template #matches>
              <!-- TODO: fix height constraint, adjust padding -->
              <div
                class="flex h-[500px] flex-col gap-1 overflow-auto border-t border-gray-200 pb-48 pt-2 dark:border-gray-700"
              >
                <MatchItemRow
                  v-for="(match, index) in matches"
                  :match
                  :next="index < 2"
                  :key="match.match_id!"
                  @live="refreshMatches"
                />
              </div>
            </template>
            <template #history>
              <!-- TODO: fix height constraint, adjust padding -->
              <div
                class="flex h-[500px] flex-col gap-1 overflow-auto border-t border-gray-200 pb-48 pt-2 dark:border-gray-700"
              >
                <!-- @vue-ignore -->
                <ResultItem
                  v-for="result in history"
                  :match="result.match as Match"
                  :id="result.id"
                  :score1="result.team1_score"
                  :score2="result.team2_score"
                  :winner="result.winner_id"
                  @refresh="refreshMatches"
                />
              </div>
            </template>
          </UTabs>
        </div>
        <div class="flex w-1/3 flex-col gap-0.5">
          <UTabs
            :items="tabLive"
            :ui="{ list: { tab: { height: 'h-7' }, height: 'h-9' } }"
          />
          <div
            class="flex h-full flex-col gap-1 overflow-auto border-t border-gray-200 pb-12 pt-2 dark:border-gray-700"
          >
            <MatchItemLive
              v-for="match in liveMatches"
              :key="match.match_id!"
              :match
              @finish="refreshMatches"
            />
          </div>
        </div>
      </div>
    </div>
  </BasePageContent>
</template>
