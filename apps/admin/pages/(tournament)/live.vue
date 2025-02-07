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
console.log(selected.value)

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
      <div class="h-1/3">
        <ClientOnly>
          <TournamentFlow
            :groups="flowGroups"
            :key="JSON.stringify(flowGroups)"
          />
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
        class="flex h-2/3 justify-between gap-6 border-t border-gray-200 p-6 dark:border-gray-700"
      >
        <div class="flex grow flex-col gap-3">
          <strong>Punkte</strong>
        </div>
        <div class="flex grow flex-col gap-3">
          <strong>Spielplan</strong>
          <div class="flex flex-col gap-1 overflow-auto pb-12">
            <MatchItemRow />
            <MatchItemRow />
            <MatchItemRow />
            <MatchItemRow />
            <MatchItemRow />
            <MatchItemRow />
            <MatchItemRow />
            <MatchItemRow />
            <MatchItemRow />
          </div>
        </div>
        <div class="flex grow-0 flex-col gap-3">
          <strong>Live</strong>
          <div class="flex h-full flex-col gap-3 overflow-auto">
            <MatchItemLive />
            <MatchItemLive />
          </div>
        </div>
      </div>
    </div>
  </BasePageContent>
</template>
