<script setup lang="ts">
import type { ParsedJsonTournament } from "~/types/prizes"

defineProps<{
  tournament: ParsedJsonTournament
}>()
</script>

<template>
  <NuxtLink :to="{ name: 'tournaments-id', params: { id: tournament.id } }">
    <div
      class="h-auto rounded-md border border-gray-200 bg-white hover:border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:hover:border-gray-600"
    >
      <div
        class="flex h-32 flex-col justify-between rounded-t-md bg-gray-100 p-2 dark:bg-gray-800"
      >
        <div class="flex items-center justify-between">
          <TournamentLiveDisplay :is-live="tournament.is_live" />
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
                  {{
                    useDateFormat(parseStringToDate(tournament.from), "HH:mm")
                  }}
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
        <p class="text-semibold my-2">Teams</p>
        <div
          class="flex flex-col gap-2 rounded-md bg-gray-50 p-2 px-3 dark:bg-gray-800"
        >
          <div class="flex justify-between">
            <div class="flex items-center space-x-1">
              <UIcon name="i-heroicons-clipboard-document-list" />
              <p>31 Teams</p>
            </div>
            <div class="flex items-center space-x-1">
              <UIcon name="i-heroicons-users" />
              <p>92 Schüler</p>
            </div>
          </div>
          <UDivider
            :ui="{
              border: {
                base: 'flex border-gray-200 dark:border-gray-700',
              },
            }"
          />
          <div class="flex justify-between gap-1">
            <div
              class="flex grow items-center justify-center space-x-1 rounded-md bg-white px-2 py-1 dark:bg-gray-900"
            >
              <UIcon
                name="i-heroicons-envelope"
                class="text-orange-500"
                size="16"
              />
              <p class="font-mono">20</p>
            </div>
            <div
              class="flex grow items-center justify-center space-x-1 rounded-md bg-white px-2 py-1 dark:bg-gray-900"
            >
              <UIcon
                name="i-heroicons-check"
                class="text-green-500"
                size="16"
              />
              <p class="font-mono">10</p>
            </div>
            <div
              class="flex grow items-center justify-center space-x-1 rounded-md bg-white px-2 py-1 dark:bg-gray-900"
            >
              <UIcon
                name="i-heroicons-no-symbol"
                class="text-red-500"
                size="16"
              />
              <p class="font-mono">1</p>
            </div>
          </div>
        </div>
        <div class="mt-3 text-right text-xs text-gray-500">
          <p>Zuletzt geändert von Dino</p>
          <p>
            Erstellt am {{ useDateFormat(tournament.created_at, "DD.MM.YYYY") }}
          </p>
        </div>
      </div>
    </div>
  </NuxtLink>
</template>
