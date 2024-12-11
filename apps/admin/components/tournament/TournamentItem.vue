<script setup lang="ts">
import type { ParsedJsonTournament } from "~/types/prizes"

const { tournament } = defineProps<{
  tournament: ParsedJsonTournament
}>()

const { getUserById, formatUsername } = useUser()
const user = await getUserById(tournament.last_edited_by_id)
const { data } = await useFetch(`/api/tournaments/${tournament.id}/teams`)

const isOpenInfo = ref<boolean>(false)
const items = [
  [
    {
      label: "Editieren",
      icon: "i-heroicons-pencil-square-20-solid",
      click: () => {
        console.log("Edit")
      },
    },
    {
      label: "Info",
      icon: "i-heroicons-information-circle",
      click: () => (isOpenInfo.value = true),
    },
  ],
  [
    {
      label: "Löschen",
      icon: "i-heroicons-trash",
      click: () => "",
    },
  ],
]
</script>

<template>
  <div
    class="h-auto rounded-md border border-gray-200 bg-white hover:border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:hover:border-gray-600"
  >
    <ModalInfo v-model="isOpenInfo">
      <pre class="overflow-auto">{{ tournament }}</pre>
    </ModalInfo>
    <div
      class="flex h-32 flex-col justify-between rounded-t-md bg-gray-100 p-2 dark:bg-gray-800"
    >
      <div class="flex items-center justify-between">
        <TournamentLiveDisplay :is-live="tournament.is_live" />
        <ClientOnly>
          <UDropdown
            :items="items"
            :ui="{ width: 'w-auto' }"
            class="m-1"
            :popper="{ placement: 'left' }"
          >
            <UButton
              color="gray"
              icon="i-heroicons-ellipsis-horizontal-20-solid"
              size="2xs"
              square
            />
          </UDropdown>
          <template #fallback>
            <USkeleton class="m-1 h-6 w-6 bg-gray-200 dark:bg-gray-700" />
          </template>
        </ClientOnly>
      </div>
      <p class="pr-6 text-2xl font-bold tracking-tight">
        {{ tournament.name }}
      </p>
    </div>
    <NuxtLink :to="{ name: 'tournaments-id', params: { id: tournament.id } }">
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
        <div
          class="mt-3 flex flex-col gap-2 rounded-md bg-gray-50 p-2 px-3 dark:bg-gray-800"
          v-if="data"
        >
          <div class="flex justify-between">
            <div class="flex items-center space-x-1">
              <UIcon name="i-heroicons-clipboard-document-list" />
              <p v-if="data.teams === 1">{{ data?.teams }} Team</p>
              <p v-else>{{ data?.teams }} Teams</p>
            </div>
            <div class="flex items-center space-x-1">
              <UIcon name="i-heroicons-users" />
              <p>{{ data?.students }} Schüler</p>
            </div>
          </div>
          <UDivider
            :ui="{
              border: {
                base: 'flex border-gray-200 dark:border-gray-700',
              },
            }"
          />
          <TournamentTeamStatus :data="data" />
        </div>
        <div class="mt-3 text-right text-xs text-gray-500">
          <p>
            Zuletzt geändert von
            {{ formatUsername(user?.email) }}
          </p>
          <p>
            Erstellt am {{ useDateFormat(tournament.created_at, "DD.MM.YYYY") }}
          </p>
        </div>
      </div>
    </NuxtLink>
  </div>
</template>
