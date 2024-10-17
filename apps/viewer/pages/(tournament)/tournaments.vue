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

const parseStringToDate = (timeString: string): Date => {
  const [hours, minutes, seconds] = timeString.split(":").map(Number)
  const date = new Date()
  date.setHours(hours)
  date.setMinutes(minutes)
  date.setSeconds(seconds)
  return date
}
</script>

<template>
  <PageTitle>Turniere</PageTitle>
  <div class="grid grid-cols-1 flex-col gap-4 sm:grid-cols-3">
    <UCard
      v-for="tournament in tournaments"
      :ui="{
        header: {
          padding: '',
        },
        body: {
          padding: 'p-4 sm:p-3',
        },
      }"
    >
      <template #header>
        <div
          class="relative flex h-[200px] flex-col justify-end overflow-hidden rounded-t-lg p-3"
        >
          <NuxtImg
            :src="getImageUrl(tournament.thumbnail_path)"
            class="absolute left-0 top-0 h-full w-full overflow-clip object-cover object-top"
          />
          <h2 class="z-10 text-3xl font-bold tracking-tight">
            {{ tournament.name }}
          </h2>
        </div>
      </template>
      <div class="flex items-center gap-4 sm:gap-3">
        <div
          class="flex grow items-center justify-center rounded-md bg-gray-50 p-1 dark:bg-gray-800"
        >
          <div class="flex h-12 items-center sm:h-10">
            <p class="text-lg font-medium">
              {{ useDateFormat(tournament.start_date, "DD.MM.YYYY") }}
            </p>
          </div>
        </div>
        <div
          class="flex items-center gap-1 rounded-md bg-gray-50 p-1 pr-3 dark:bg-gray-800"
        >
          <UIcon name="i-heroicons-arrow-long-down" size="20" />
          <div class="flex flex-col text-base sm:text-sm">
            <div class="flex items-center space-x-1">
              <UIcon name="i-heroicons-clock" />
              <p>
                {{ useDateFormat(parseStringToDate(tournament.from), "HH:mm") }}
              </p>
            </div>
            <div class="flex items-center space-x-1">
              <UIcon name="i-heroicons-clock" />
              <p>
                {{ useDateFormat(parseStringToDate(tournament.to), "HH:mm") }}
              </p>
            </div>
          </div>
        </div>
      </div>
      <p class="my-1 text-lg font-semibold">Regeln</p>
      <div
        class="h-32 overflow-auto rounded-md border-gray-200 bg-gray-50 p-2 dark:border-gray-800 dark:bg-gray-800"
      >
        <pre class="text-wrap">{{ tournament.rules }}</pre>
      </div>
      <p class="my-1 text-lg font-semibold">Preise</p>
      <p>{{ tournament.prizes?.first }}</p>
      <p>{{ tournament.prizes?.second }}</p>
      <p>{{ tournament.prizes?.third }}</p>
      <p>{{ tournament.prizes?.bonus }}</p>
    </UCard>
  </div>
</template>

<style scoped></style>
