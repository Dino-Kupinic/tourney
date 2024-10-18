<script setup lang="ts">
definePageMeta({
  name: "Turniere",
})

const { data: tournaments } = useFetch("/api/tournaments")
</script>

<template>
  <PageTitle>Turniere</PageTitle>
  <div class="grid grid-cols-1 flex-col gap-4 sm:grid-cols-3">
    <TournamentItem v-for="tournament in tournaments" :tournament />
  </div>
</template>
