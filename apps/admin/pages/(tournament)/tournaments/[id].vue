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
    {{ route.params.id }}
  </BasePageContent>
</template>

<style scoped></style>
