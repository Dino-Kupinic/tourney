<script setup lang="ts">
import type { Database } from "~/types/database.types"

definePageMeta({
  name: "Turniere",
})

const client = useSupabaseClient<Database>()

const { data: tournaments } = await useAsyncData("tournaments", async () => {
  const { data } = await client.from("tournament").select("*")

  return data
})
</script>

<template>
  <PageTitle>Turniere</PageTitle>
  <div class="flex flex-col gap-3">
    <div
      class="w-full rounded-md border p-4 shadow-sm dark:border-gray-800 dark:bg-gray-900"
      v-for="tournament in tournaments"
    >
      <NuxtImg
        :src="getImageUrl(tournament.thumbnail_path)"
        class="h-32 w-full"
      />
      <p>{{ tournament.name }}</p>
      <p>{{ tournament.description }}</p>
      <p>{{ tournament.to }}</p>
      <p>{{ tournament.from }}</p>
      <p>{{ tournament.is_live }}</p>
      <p>{{ tournament.start_date }}</p>
      <p>{{ tournament.rules }}</p>
      <p>{{ tournament.prizes }}</p>
    </div>
  </div>
</template>

<style scoped></style>
