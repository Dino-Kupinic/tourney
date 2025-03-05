<script setup lang="ts">
import type { ParsedJsonTournament } from "~/types/prizes"

const route = useRoute()
const uuid = route.params.id

const { data: tournament } = await useFetch<ParsedJsonTournament | null>(
  `/api/tournaments/${uuid}`,
)

if (!tournament.value) {
  throw createError({
    statusCode: 404,
    message: "Turnier nicht gefunden",
  })
}

useHead({
  title: () => tournament.value?.name ?? "Turnier",
})

const bonus = computed(() => {
  return tournament.value?.prizes?.bonus ?? "Keine weiteren Preise"
})
</script>

<template>
  <UButton
    to="/tournaments"
    icon="i-heroicons-chevron-left"
    variant="link"
    class="-ml-3 mb-2"
    label="Zurück"
  />
  <PageTitle>{{ tournament?.name }}</PageTitle>
  <div
    class="mt-3 max-w-96 rounded-md border bg-white p-3 dark:border-gray-800 dark:bg-gray-900"
  >
    <PageHeading>Infos</PageHeading>
    <div class="flex items-center gap-4 sm:gap-3">
      <div
        class="flex grow items-center gap-1 rounded-md bg-gray-50 p-1 px-3 dark:bg-gray-800"
      >
        <div class="flex flex-col text-base sm:text-sm">
          <div class="flex items-center space-x-1">
            <UIcon name="i-heroicons-calendar-days" />
            <p>
              {{ useDateFormat(tournament?.start_date, "DD.MM.YYYY") }}
            </p>
          </div>
          <div class="flex items-center space-x-1">
            <UIcon name="i-heroicons-map-pin" />
            <p class="max-w-36 truncate">
              {{ tournament?.location }}
            </p>
          </div>
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
              {{ useDateFormat(parseStringToDate(tournament?.from!), "HH:mm") }}
            </p>
          </div>
          <div class="flex items-center space-x-1">
            <UIcon name="i-heroicons-clock" />
            <p>
              {{ useDateFormat(parseStringToDate(tournament?.to!), "HH:mm") }}
            </p>
          </div>
        </div>
      </div>
    </div>
    <PageHeading>Regeln</PageHeading>
    <div
      class="h-28 overflow-auto rounded-md border-gray-200 bg-gray-50 p-2 dark:border-gray-800 dark:bg-gray-800"
    >
      <pre class="text text-wrap text-sm">{{ tournament?.rules }}</pre>
    </div>
    <PageHeading>Preise</PageHeading>
    <div class="flex flex-col gap-1">
      <TournamentPrizeRow :place="1">
        {{ tournament?.prizes?.first ?? "Nichts" }}
      </TournamentPrizeRow>
      <TournamentPrizeRow :place="2">
        {{ tournament?.prizes?.second ?? "Nichts" }}
      </TournamentPrizeRow>
      <TournamentPrizeRow :place="3">
        {{ tournament?.prizes?.third ?? "Nichts" }}
      </TournamentPrizeRow>
      <div
        class="h-20 overflow-auto rounded-md border-gray-200 bg-gray-50 p-2 dark:border-gray-800 dark:bg-gray-800"
      >
        <!-- Keep this as one line or else there will be an unnecessary line -->
        <pre class="text text-wrap text-sm">{{ bonus }}</pre>
      </div>
    </div>
  </div>
</template>
