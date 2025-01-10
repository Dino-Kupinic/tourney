<script setup lang="ts">
import type { ParsedJsonTournament } from "~/types/prizes"
import {
  FOOTBALL_MAX_TEAMS,
  VOLLEYBALL_BASKETBALL_MAX_TEAMS,
} from "~/misc/constants"

const title = ref<string>("Turniere")
useHead({
  title: () => title.value,
})
const route = useRoute()
const { data: tournament, refresh } =
  await useFetch<ParsedJsonTournament | null>(
    `/api/tournaments/${route.params.id}`,
  )
if (!tournament.value) {
  throw createError({
    statusCode: 404,
    message: "Turnier nicht gefunden",
  })
}
const tournamentName = ref<string>(tournament.value?.name ?? "Turnier")
const { data } = await useFetch(`/api/tournaments/${tournament.value.id}/teams`)

const maxTeams = computed(() => {
  switch (tournament.value?.sport) {
    case "Fußball":
      return FOOTBALL_MAX_TEAMS
    case "Basketball":
    case "Volleyball":
      return VOLLEYBALL_BASKETBALL_MAX_TEAMS
  }
})

const links = [
  {
    label: "Turniere",
    to: "/tournaments",
  },
  {
    label: tournamentName.value,
    to: `/tournaments/${route.params.id}`,
  },
]

const { data: groups } = await useFetch(
  `/api/tournaments/${tournament.value.id}/groups`,
)

const isOpenLive = defineModel<boolean>()
const isTournamentLive: ComputedRef<boolean> = computed(() => {
  return tournament.value?.is_live!
})
const is_live = useState<boolean>("is_live", () => isTournamentLive.value)
watch(isTournamentLive, () => {
  is_live.value = isTournamentLive.value
})
const liveLabel = computed(() => {
  return is_live.value ? "Offline gehen..." : "Live gehen..."
})

const { fetchLiveTournaments } = useLiveTournaments()
const onSetLive = async () => {
  try {
    await $fetch(`/api/tournaments/${tournament.value?.id}/live`, {
      method: "PUT",
      body: {
        is_live: !isTournamentLive.value,
      },
    })
    isOpenLive.value = false
    await refresh()
    await fetchLiveTournaments()
    displaySuccessNotification(
      "Erfolgreich",
      `Das Turnier ist jetzt ${tournament.value?.is_live ? "live" : "offline"}.`,
    )
  } catch (err) {
    console.error(err)
    displayFailureNotification(
      "Fehler",
      "Das Turnier konnte nicht live gesetzt werden.",
    )
  }
}

const refreshTournament = () => {
  refresh()
  displaySuccessNotification("Aktualisiert", "Die Daten wurde aktualisiert.")
}

const timeline = [
  {
    label: "Gruppenphase",
  },
  {
    label: "Kreuzspiele",
  },
  {
    label: "Halbfinale",
  },
  {
    label: "Finale",
  },
]

const flowGroups = computed(() => {
  return groups.value?.map((group) => {
    return {
      name: group.name,
      teams: group.teams.map((team) => team.name),
    }
  })
})
</script>

<template>
  <BasePageHeader class="pl-0">
    <ToolbarContainer class="flex w-full items-center justify-between">
      <div class="flex items-center gap-2">
        <UBreadcrumb :links="links" />
        <TournamentLiveDisplay
          v-if="tournament"
          :is-live="tournament.is_live"
        />
      </div>
      <div class="flex items-center space-x-2">
        <UButton
          icon="i-heroicons-arrow-path"
          color="gray"
          size="xs"
          square
          @click="refreshTournament"
        />
        <UButton
          icon="i-heroicons-pencil-square"
          label="Bearbeiten"
          color="gray"
          size="xs"
          square
        />
        <UButton
          v-if="!tournament?.is_live"
          label="Gruppen neu mischen..."
          icon="i-heroicons-table-cells"
          variant="soft"
          size="xs"
        />
        <UButton
          :label="liveLabel"
          icon="i-heroicons-signal"
          color="red"
          variant="soft"
          size="xs"
          @click="isOpenLive = true"
        />
        <ModalLive v-model="isOpenLive" @live="onSetLive" />
      </div>
    </ToolbarContainer>
  </BasePageHeader>
  <BasePageContent>
    <div class="flex h-full w-full">
      <div
        class="flex w-1/2 flex-col overflow-auto border-r border-gray-200 dark:border-gray-700"
      >
        <div
          class="flex h-auto w-full gap-3 border-b border-gray-200 bg-gray-100 p-3 px-6 dark:border-gray-800 dark:bg-gray-900"
        >
          <div
            v-if="tournament"
            class="flex w-auto grow items-center gap-1 rounded-md bg-gray-50 p-3 pr-3 dark:bg-gray-800"
          >
            <div class="flex flex-col">
              <TournamentItemInfoStart
                :tournament
                :truncate="false"
                class="pr-3"
              />
              <div class="flex items-center">
                <TournamentItemInfoTime :tournament :arrow-right="true" />
              </div>
            </div>
          </div>
          <div
            class="flex w-64 flex-col gap-2 rounded-md bg-gray-50 p-2 px-3 dark:bg-gray-800"
            v-if="data"
          >
            <div class="flex justify-between">
              <div class="flex items-center space-x-1">
                <UIcon name="i-heroicons-clipboard-document-list" />
                <p>{{ data?.teams }}/{{ maxTeams }} Teams</p>
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
            <TournamentTeamStatus :data="data" class="grow" />
          </div>
          <div class="rounded-md bg-gray-50 p-3 pr-3 text-sm dark:bg-gray-800">
            <div class="flex items-center space-x-1">
              <UIcon name="i-heroicons-user-group" />
              <p>{{ tournament?.groups }} Gruppen</p>
            </div>
            <div class="flex items-center space-x-1">
              <UIcon name="i-heroicons-identification" />
              <p>{{ tournament?.group_teams }} Teams pro Gruppe</p>
            </div>
          </div>
        </div>
        <div class="flex h-full w-full flex-col gap-3 p-6">
          <strong>Ablauf</strong>
          <UBreadcrumb :links="timeline" divider="i-heroicons-arrow-long-right">
            <template #default="{ link, isActive }">
              <UBadge
                :color="isActive ? 'primary' : 'gray'"
                class="truncate rounded-full"
                :variant="isActive ? 'subtle' : 'solid'"
              >
                {{ link.label }}
              </UBadge>
            </template>
          </UBreadcrumb>
          <strong>Gruppen</strong>
          <div
            class="overflow-hidden rounded-md border border-gray-300 dark:border-gray-700"
          >
            <table class="w-full table-auto border-separate border-spacing-0">
              <thead>
                <tr
                  class="bg-gray-200 text-gray-700 dark:bg-gray-800 dark:text-gray-300"
                >
                  <th class="px-4 py-2 first:rounded-tl-sm last:rounded-tr-sm">
                    Gruppe
                  </th>
                  <th class="px-4 py-2 first:rounded-tl-sm last:rounded-tr-sm">
                    Teams
                  </th>
                </tr>
              </thead>
              <tbody v-if="groups">
                <tr
                  v-for="(group, groupIndex) in groups"
                  :key="groupIndex"
                  :class="[
                    groupIndex === groups?.length - 1
                      ? 'last:rounded-bl-md last:rounded-br-md'
                      : '',
                  ]"
                >
                  <td
                    class="border-r border-t border-gray-300 px-4 py-2 text-center font-medium dark:border-gray-700"
                  >
                    {{ group.name }}
                  </td>
                  <td
                    class="border-t border-gray-300 px-4 py-2 dark:border-gray-700"
                  >
                    <div class="flex flex-wrap gap-2">
                      <UBadge
                        v-for="(team, teamIndex) in group.teams"
                        :key="teamIndex"
                        :color="
                          team.registration?.status === 'Abgesendet'
                            ? 'orange'
                            : 'green'
                        "
                        :ui="{ rounded: 'rounded-full' }"
                        variant="subtle"
                        size="xs"
                        :label="team.name"
                      />
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <strong>Teams</strong>
        </div>
      </div>
      <div class="w-1/2">
        <ClientOnly>
          <TournamentFlow :groups="flowGroups" />
          <template #fallback>
            <div
              class="flex h-full w-full items-center justify-center bg-gray-100 dark:bg-gray-800"
            >
              <UIcon name="i-svg-spinners-180-ring-with-bg" size="24" />
            </div>
          </template>
        </ClientOnly>
      </div>
    </div>
  </BasePageContent>
</template>
