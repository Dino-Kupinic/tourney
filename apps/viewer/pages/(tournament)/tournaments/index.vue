<script setup lang="ts">
useHead({
  title: "Turniere",
})

const { data: tournaments } = await useFetch("/api/tournaments")

const groupedTournaments = computed(() => {
  if (!tournaments.value) return []

  const grouped = tournaments.value.reduce<
    Record<number, typeof tournaments.value>
  >((acc, curr) => {
    const year = curr.year
    if (!acc[year]) {
      acc[year] = []
    }
    acc[year].push(curr)
    return acc
  }, {})

  return Object.entries(grouped)
    .map(([year, items]) => ({
      year: Number(year),
      tournaments: items,
    }))
    .sort((a, b) => b.year - a.year)
})
</script>

<template>
  <PageHeader title="Turniere" description="Alle Turniere im Überblick" />

  <div v-for="group in groupedTournaments" :key="group.year">
    <UDivider type="dashed">
      <strong>{{ group.year }}</strong>
    </UDivider>
    <div class="grid grid-cols-1 flex-col gap-4 py-4 sm:grid-cols-3">
      <TournamentItem
        v-for="tournament in group.tournaments"
        :tournament="tournament"
        :key="tournament.id"
      />
    </div>
  </div>
</template>
