<script setup lang="ts">
import type { ParsedJsonTournament, Standing } from "@tourney/types"

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

const { data: history } = await useFetch(`/api/results/${uuid}`)
const { data: results } = await useFetch(`/api/tournament_results/${uuid}`)

const { data: groups } = tournament.value
  ? await useFetch(`/api/groups/${tournament.value.id}`)
  : { data: ref(null) }

const selectedGroup = useState<string>("selectedGroup", () => "")
if (groups.value && groups.value.length > 0) {
  selectedGroup.value = groups.value[0].id
}

const { data: standings, refresh: refreshStandings = () => Promise.resolve() } =
  selectedGroup.value
    ? await useFetch<Standing[]>(
        () => `/api/views/standings/group/${selectedGroup.value}`,
      )
    : { data: ref([]) }

watch(selectedGroup, async () => {
  if (selectedGroup.value) {
    await refreshStandings()
  }
})

const getTeamName = (index: number) =>
  computed(() => {
    if (!results.value) return
    // @ts-ignore
    return results.value?.[index]?.team?.name
  })

const first = getTeamName(0)
const second = getTeamName(1)
const third = getTeamName(2)
const fourth = getTeamName(3)
</script>

<template>
  <PageWrapper>
    <UButton
      to="/tournaments"
      icon="i-heroicons-chevron-left"
      variant="link"
      class="-ml-3 mb-2"
      label="Zurück"
    />
    <PageTitle>{{ tournament?.name }}</PageTitle>
    <div class="grid max-w-2xl grid-cols-1 gap-4 md:grid-cols-2">
      <div
        class="mt-3 rounded-md border bg-white p-3 dark:border-gray-800 dark:bg-gray-900"
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
                  {{
                    useDateFormat(parseStringToDate(tournament?.from!), "HH:mm")
                  }}
                </p>
              </div>
              <div class="flex items-center space-x-1">
                <UIcon name="i-heroicons-clock" />
                <p>
                  {{
                    useDateFormat(parseStringToDate(tournament?.to!), "HH:mm")
                  }}
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

      <div
        v-if="results && results.length"
        class="mt-3 rounded-md border bg-white p-3 dark:border-gray-800 dark:bg-gray-900"
      >
        <PageHeading>Gewinner</PageHeading>
        <TournamentPlaces
          :first="first!"
          :second="second!"
          :third="third!"
          :fourth="fourth!"
        />
      </div>
    </div>

    <div
      class="mt-4 max-w-2xl rounded-md border bg-white p-3 dark:border-gray-800 dark:bg-gray-900"
    >
      <PageHeading>Visualisierung</PageHeading>
      <div
        class="flex h-64 items-center justify-center rounded-md border bg-gray-50 dark:border-gray-700 dark:bg-gray-900"
      >
        <ClientOnly>
          <LiveFlow :tournament-id="tournament?.id as string" />
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

    <div
      class="mt-4 max-w-2xl rounded-md border bg-white p-3 dark:border-gray-800 dark:bg-gray-900"
    >
      <PageHeading>Platzierungen</PageHeading>
      <USelect
        v-if="groups && groups.length"
        :options="groups"
        v-model="selectedGroup"
        size="lg"
        value-attribute="id"
        option-attribute="name"
        class="mb-2"
      />
      <div v-if="standings && standings.length">
        <StandingsTable :standings="standings" />
      </div>
      <UAlert
        v-else
        icon="i-heroicons-information-circle"
        color="primary"
        variant="soft"
        title="Keine Platzierungen verfügbar"
        description="Für dieses Turnier sind noch keine Platzierungen verfügbar."
      />
    </div>

    <div
      class="mt-4 max-w-2xl rounded-md border bg-white p-3 dark:border-gray-800 dark:bg-gray-900"
    >
      <PageHeading>Spielverlauf</PageHeading>
      <div
        class="flex h-96 flex-col gap-1.5 overflow-auto rounded-md border bg-gray-50 p-3 pb-8 dark:border-gray-800 dark:bg-gray-900"
      >
        <template v-if="history && history.length">
          <!-- @vue-ignore -->
          <ResultItem
            v-for="result in history"
            :match="result.match as Match"
            :id="result.id"
            :score1="result.team1_score"
            :score2="result.team2_score"
            :winner="result.winner_id"
          />
        </template>
        <UAlert
          v-else
          icon="i-heroicons-information-circle"
          color="primary"
          variant="soft"
          title="Keine Spielergebnisse verfügbar"
          description="Für dieses Turnier sind noch keine Spielergebnisse verfügbar."
        />
      </div>
    </div>
  </PageWrapper>
</template>
