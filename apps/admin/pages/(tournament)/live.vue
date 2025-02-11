<script setup lang="ts">
import type { Group } from "~/types/group"
import type { ParsedJsonTournament } from "~/types/prizes"
import type { Match } from "~/types/match"

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

console.log(matches.value)
const refresh = async () => {
  await tournamentRefresh()
  await groupRefresh()
  await matchRefresh()
  displaySuccessNotification(
    "Daten aktualisiert",
    "Die Daten wurden aktualisiert.",
  )
}
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
    </ToolbarContainer>
  </BasePageHeader>
  <BasePageContent>
    <div class="h-full w-full">
      <div class="h-1/3">
        <p>a</p>
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
        <div class="flex grow flex-col gap-3">
          <strong>Punkte</strong>
        </div>
        <div class="flex grow flex-col gap-1">
          <strong>Spielplan</strong>
          <div class="flex flex-col gap-1 overflow-auto border-t pb-12 pt-3">
            <MatchItemRow
              v-for="(match, index) in matches"
              :match
              :next="index < 2"
            />
          </div>
        </div>
        <div class="flex grow-0 flex-col gap-1">
          <strong>Live</strong>
          <div class="flex h-full flex-col gap-1 overflow-auto border-t pt-3">
            <MatchItemLive />
            <MatchItemLive />
          </div>
        </div>
      </div>
    </div>
  </BasePageContent>
</template>
