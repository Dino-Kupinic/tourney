<script setup lang="ts">
import type { Group } from "~/types/group"
import type { ParsedJsonTournament } from "~/types/prizes"
import type { Match } from "~/types/match"
import type { Standing } from "~/types/standing"

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
const { data: groups, refresh: groupRefresh } = await useFetch(
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

const { data: matches, refresh: matchRefresh } = await useFetch<Match[]>(
  `/api/views/matches/${tournament.value.id}`,
)

const refresh = async () => {
  await tournamentRefresh()
  await groupRefresh()
  await matchRefresh()
  displaySuccessNotification(
    "Daten aktualisiert",
    "Die Daten wurden aktualisiert.",
  )
}

const isOpenInfo = ref<boolean>(false)
const { data: standings } = await useFetch<Standing[]>(
  `/api/views/standings/${tournament.value.id}`,
)

const { data: liveMatches, refresh: refreshLiveMatches } = await useFetch<
  Match[]
>(`/api/views/matches/live/${tournament.value.id}`)

// TODO: adding works but refresh doesn't
const refreshMatches = async () => {
  await matchRefresh()
  await refreshLiveMatches()
}

const supabase = useSupabaseClient()
const isOpenCreate = ref<boolean>(false)
const generateGroupMatches = async () => {
  const { error } = await supabase.rpc("generate_group_stage_matches", {
    p_interval_minutes: 12,
    p_start_time: "08:00",
    p_tournament_id: tournament.value?.id!,
  })
  if (error) {
    displayFailureNotification("Fehler", error.message)
    console.error(error)
  } else {
    await refreshMatches()
    displaySuccessNotification(
      "Gruppenphase gestartet",
      "Die Gruppenphase wurde gestartet.",
    )
  }
  isOpenCreate.value = false
}

// TODO: Don't display seconds in time
</script>

<template>
  <BasePageHeader :title="title">
    <ToolbarContainer>
      <UButton
        size="xs"
        variant="soft"
        color="indigo"
        label="Automatikmodus..."
        icon="i-heroicons-arrow-path-rounded-square"
        v-if="matches?.length"
      />
      <UButton
        size="xs"
        variant="soft"
        color="primary"
        label="Gruppenphase starten..."
        @click="isOpenCreate = true"
        v-if="matches?.length === 0"
      />
      <ModalCreate
        title="Gruppenphase starten"
        v-model="isOpenCreate"
        @create="generateGroupMatches"
      >
        <!-- TODO: form -->
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
      <template v-if="matches?.length">
        <div class="h-1/3">
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
        </div>
        <div
          class="flex h-2/3 justify-between gap-6 border-t border-gray-200 p-6 dark:border-gray-700"
        >
          <div class="flex grow flex-col gap-1">
            <strong>Punkte</strong>
            <StandingsTable v-if="standings" :standings="standings" />
          </div>
          <div class="flex grow flex-col gap-1">
            <strong>Spielplan</strong>
            <div
              class="flex flex-col gap-1 overflow-auto border-t border-gray-200 pb-12 pt-3 dark:border-gray-700"
            >
              <MatchItemRow
                v-for="(match, index) in matches"
                :match
                :next="index < 2"
                :key="match.match_id!"
                @live="refreshMatches"
              />
            </div>
          </div>
          <div
            class="flex flex-col gap-1"
            :class="[liveMatches?.length ? 'grow-0' : 'grow']"
          >
            <strong>Live</strong>
            <div
              class="flex h-full flex-col gap-1 overflow-auto border-t border-gray-200 pb-12 pt-3 dark:border-gray-700"
            >
              <MatchItemLive v-for="match in liveMatches" :match />
            </div>
          </div>
        </div>
      </template>
      <template v-else>
        <EmptyState
          title="Keine Matches"
          description="Es sind keine Matches vorhanden. Starte die Gruppenphase um loszulegen."
        />
      </template>
    </div>
  </BasePageContent>
</template>
