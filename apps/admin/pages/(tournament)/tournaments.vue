<script setup lang="ts">
import TournamentItem from "~/components/tournament/TournamentItem.vue"
import TournamentGrid from "~/components/tournament/TournamentGrid.vue"

const title = ref<string>("Turniere")
useHead({
  title: () => title.value,
})

const sortOptions = ["Sortiert nach Jahr", "Sortiert nach Sport"]
const selected = ref<string>(sortOptions[0])

const { data } = await useFetch("/api/tournaments")
</script>

<template>
  <BasePageHeader :title="title">
    <ToolbarContainer>
      <SearchInput />
      <USelectMenu
        v-model="selected"
        :options="sortOptions"
        size="xs"
        class="w-40"
      />
      <UButton square icon="i-ic-round-question-mark" size="xs" color="white" />
      <UButton size="xs" variant="soft" label="Neues Turnier..." />
    </ToolbarContainer>
  </BasePageHeader>
  <BasePageContent>
    <div class="h-full overflow-auto p-6 pb-24">
      <div class="flex flex-col gap-3">
        <div>
          <UBadge label="2025" variant="subtle" size="md" />
        </div>
        <TournamentGrid>
          <TournamentItem v-for="tournament in data" :tournament />
        </TournamentGrid>
      </div>
      <UDivider class="my-6" />
    </div>
  </BasePageContent>
</template>
