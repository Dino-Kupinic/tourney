<script setup lang="ts">
import type { ParsedJsonTournament } from "~/types/prizes"

const title = ref<string>("Turniere")
useHead({
  title: () => title.value,
})
const route = useRoute()
const { data } = await useFetch<ParsedJsonTournament | null>(
  `/api/tournaments/${route.params.id}`,
)
const tournamentName = ref<string>(data.value?.name ?? "Turnier")

const links = [
  {
    label: "Turniere",
    to: "/tournaments",
  },
  {
    label: tournamentName.value,
    to: `/tournaments/${route.params.id}`,
  },
]
</script>

<template>
  <BasePageHeader class="pl-0">
    <ToolbarContainer>
      <UBreadcrumb :links="links" />
    </ToolbarContainer>
  </BasePageHeader>
  <BasePageContent>
    <div class="flex h-full w-full">
      <div class="w-1/2 border-r border-gray-200 dark:border-gray-700">a</div>
      <div class="w-1/2">
        <ClientOnly>
          <TournamentFlow />
          <template #fallback>
            <div
              class="flex h-full w-full items-center justify-center bg-gray-100 dark:bg-gray-800"
            >
              <UIcon name="i-svg-spinners-180-ring-with-bg" size="24" />
            </div>
          </template>
        </ClientOnly>
      </div>
    </div>
  </BasePageContent>
</template>
