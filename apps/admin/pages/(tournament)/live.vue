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
await fetchTournaments()
const selected = ref(tournaments.value[0])
console.log(selected.value)

const { data: tournament, refresh: tournamentRefresh } =
  await useFetch<ParsedJsonTournament | null>(
    `/api/tournaments/${selected.value.id}`,
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
  `/api/matches/${tournament.value.id}`,
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
</script>

<template>
  <BasePageHeader :title="title">
    <ToolbarContainer>
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
          <li class="ml-6">S = Siege</li>
          <li class="ml-6">N = Niederlagen</li>
          <li class="ml-6">U = Unentschieden</li>
          <li class="ml-6">
            Tore = Tore geschossen / Tore bekommen / Differenz
          </li>
        </ul>
      </ModalInfo>
    </ToolbarContainer>
  </BasePageHeader>
  <BasePageContent>
    <div class="h-full w-full">
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
          <template v-if="standings">
            <StandingsTable :standings="standings" />
          </template>
          <template v-else>
            <UAlert
              icon="i-heroicons-exclamation-triangle"
              color="yellow"
              variant="soft"
              title="Keine Daten"
              description="Wurden Matches erstellt?"
            />
          </template>
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
              :key="match.id"
            />
          </div>
        </div>
        <div class="flex grow-0 flex-col gap-1">
          <strong>Live</strong>
          <div
            class="flex h-full flex-col gap-1 overflow-auto border-t border-gray-200 pt-3 dark:border-gray-700"
            v-if="matches"
          >
            <MatchItemLive :match="matches[0]" />
            <MatchItemLive :match="matches[1]" />
          </div>
        </div>
      </div>
    </div>
  </BasePageContent>
</template>
