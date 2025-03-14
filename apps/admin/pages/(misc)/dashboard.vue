<script setup lang="ts">
import { VisXYContainer, VisLine, VisAxis } from "@unovis/vue"
import type { DashboardStatistics } from "~/types/dashboard"

const title = ref<string>("Dashboard")
useHead({
  title: () => title.value,
})

const stats = ref<DashboardStatistics | null>(null)
const { data, refresh: refreshStats } = await useFetch<DashboardStatistics>(
  "/api/dashboard/statistics",
)
stats.value = data.value

const refresh = async () => {
  await refreshStats()
  displaySuccessNotification(
    "Daten aktualisiert",
    "Die Daten wurden aktualisiert.",
  )
}

type DataRecord = { x: number; y: number }
const chartData: DataRecord[] = [
  { x: 0, y: 0 },
  { x: 1, y: 2 },
  { x: 2, y: 1 },
]
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
    </ToolbarContainer>
  </BasePageHeader>
  <BasePageContent>
    <div class="p-4 px-6">
      <div class="mb-6 grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-4">
        <DashboardItem
          title="Turniere"
          :value="stats?.tournaments.total"
          icon="i-heroicons-trophy"
        />

        <DashboardItem
          title="Teams"
          :value="stats?.teams.total"
          icon="i-heroicons-user-group"
        />

        <DashboardItem
          title="Anmeldungen"
          :value="stats?.registrations.total"
          icon="i-heroicons-clipboard-document-list"
        />

        <DashboardItem
          title="Spiele"
          :value="stats?.matches.total"
          icon="i-heroicons-flag"
        />
      </div>

      <VisXYContainer :height="200">
        <VisLine
          :data="chartData"
          :x="(d: DataRecord) => d.x"
          :y="(d: DataRecord) => d.y"
        />
        <VisAxis type="x" />
        <VisAxis type="y" />
      </VisXYContainer>
    </div>
  </BasePageContent>
</template>
