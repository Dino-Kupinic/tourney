<script setup lang="ts">
import type { ParsedJsonTournament } from "~/types/prizes"

defineProps<{
  tournament: ParsedJsonTournament
}>()
</script>

<template>
  <div
    class="hover:border-primary-300 dark:hover:border-primary-700 h-96 rounded-md border border-gray-200 bg-white hover:shadow-[0_0px_40px_2px_rgba(29,78,216,0.1)] dark:border-gray-700 dark:bg-gray-900"
  >
    <div
      class="flex h-28 flex-col justify-between rounded-t-md bg-gray-100 p-2 dark:bg-gray-800"
    >
      <div class="flex items-center justify-between">
        <div
          v-if="tournament.is_live"
          class="flex items-center space-x-1.5 rounded-md bg-red-50 px-2 py-1 ring-1 ring-inset ring-red-500 ring-opacity-25 dark:bg-red-500 dark:bg-opacity-10 dark:ring-red-400 dark:ring-opacity-25"
        >
          <span class="relative flex h-2 w-2">
            <span
              class="absolute inline-flex h-full w-full animate-ping rounded-full bg-red-400 opacity-75"
            ></span>
            <span
              class="relative inline-flex h-2 w-2 rounded-full bg-red-500"
            ></span>
          </span>
          <p class="text-xs font-medium text-red-500 dark:text-red-400">Live</p>
        </div>
        <UBadge label="Inaktiv" color="white" size="sm" v-else />
        <UDropdown :ui="{ width: 'w-auto' }" class="m-1">
          <UButton
            color="gray"
            icon="i-heroicons-ellipsis-horizontal-20-solid"
            size="2xs"
            square
          />
        </UDropdown>
      </div>
      <p class="pr-6 text-2xl font-bold tracking-tight">
        {{ tournament.name }}
      </p>
    </div>
    <div class="p-3">
      <div class="flex items-center gap-4 sm:gap-3">
        <div
          class="flex grow items-center gap-1 rounded-md bg-gray-50 p-1 px-3 dark:bg-gray-800"
        >
          <div class="flex flex-col text-base sm:text-sm">
            <div class="flex items-center space-x-1">
              <UIcon name="i-heroicons-calendar-days" />
              <p>
                {{ useDateFormat(tournament.start_date, "DD.MM.YYYY") }}
              </p>
            </div>
            <div class="flex items-center space-x-1">
              <UIcon name="i-heroicons-map-pin" />
              <p class="max-w-28 truncate">
                {{ tournament.location }}
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
    </div>
  </div>
</template>
