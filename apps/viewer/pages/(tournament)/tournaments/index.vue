<script setup lang="ts">
useHead({
  title: "Turniere",
})

const { data: tournaments } = await useFetch("/api/tournaments")
</script>

<template>
  <PageHeader title="Turniere" description="Alle Turniere im Überblick" />
  <UDivider type="dashed">
    <strong>2025</strong>
  </UDivider>
  <div class="grid grid-cols-1 flex-col gap-4 py-4 sm:grid-cols-3">
    <TournamentItem
      v-for="tournament in tournaments"
      :tournament
      :key="tournament.id"
    />
  </div>
  <UDivider type="dashed">
    <strong>2024</strong>
  </UDivider>
</template>
