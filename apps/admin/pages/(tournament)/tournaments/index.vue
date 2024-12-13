<script setup lang="ts">
import { z } from "zod"
import type { Enums } from "~/types/database.types"

const title = ref<string>("Turniere")
useHead({
  title: () => title.value,
})

const { data: groupedTournaments, refresh } = await useFetch(
  "/api/tournaments",
  {
    transform: (data) =>
      data?.reduce<Record<number, typeof data>>((acc, curr) => {
        const year = curr.year
        if (acc[year]) {
          acc[year].push(curr)
        } else {
          acc[year] = [curr]
        }
        return acc
      }, {}),
  },
)

const refreshTournaments = () => {
  refresh()
  displaySuccessNotification("Aktualisiert", "Turniere wurden aktualisiert")
}

const isOpenCreate = ref<boolean>(false)
const sports: Enums<"sport_type">[] = ["Fußball", "Basketball", "Volleyball"]

const client = useSupabaseClient()
const { data } = await client.storage.from("images").list("tournament")
const thumbnails = computed(() => {
  const temp = data?.filter((image) => image.name !== ".emptyFolderPlaceholder")
  return temp?.map((image) => `/tournament/${image.name}`)
})

const creationSchema = z.object({
  name: z.string(),
  rules: z.string(),
  start_date: z.string().date(),
  from: z.string().time(),
  to: z.string().time(),
  year: z.number(),
  sport: z.custom<Enums<"sport_type">>(),
  prizes: z.object({
    first: z.string(),
    second: z.string(),
    third: z.string(),
    bonus: z.string(),
  }),
  thumbnail_path: z.string(),
  location: z.string(),
})

const creationState = reactive({
  name: undefined,
  rules: "",
  start_date: undefined,
  from: undefined,
  to: undefined,
  year: 0,
  sport: undefined,
  prizes: {
    first: "",
    second: "",
    third: "",
    bonus: "",
  },
  thumbnail_path: undefined,
  location: "Sportplatz",
})

watch(
  () => creationState.start_date,
  (value: unknown) => {
    creationState.year = new Date(value as string).getFullYear()
  },
)

const onSubmitCreate = async () => {
  try {
    creationSchema.parse(creationState)
    const { id } = useUser()
    await $fetch("/api/tournaments/create", {
      method: "POST",
      body: {
        ...creationState,
        last_edited_by_id: id.value,
      },
    })
    isOpenCreate.value = false
    await refresh()
    displaySuccessNotification(
      "Turnier erstellt",
      "Das Turnier wurde erfolgreich erstellt.",
    )
  } catch (err) {
    console.error(err)
    displayFailureNotification(
      "Fehler beim Erstellen",
      "Das Turnier konnte nicht erstellt werden.",
    )
  }
}
</script>

<template>
  <BasePageHeader :title="title">
    <ToolbarContainer>
      <SearchInput />
      <UButton
        icon="i-heroicons-arrow-path"
        color="gray"
        size="xs"
        square
        @click="refreshTournaments"
      />
      <UButton
        size="xs"
        variant="soft"
        @click="isOpenCreate = true"
        label="Neues Turnier..."
      />
      <!-- Create Modal -->
      <UModal v-model="isOpenCreate" :ui="{ width: 'w-full sm:max-w-4xl' }">
        <UCard
          :ui="{
            divide: 'divide-y divide-gray-100 dark:divide-gray-800',
            body: {
              padding: 'px-4 py-5 sm:p-6',
            },
            header: {
              padding: 'px-4 py-3 sm:px-6',
            },
            footer: {
              padding: 'px-4 py-3 sm:px-6',
            },
          }"
        >
          <template #header>
            <strong> Neues Turnier </strong>
          </template>
          <UForm
            :schema="creationSchema"
            :state="creationSchema"
            class="pt-2"
            @submit="onSubmitCreate"
            :validate-on="[]"
            ref="formRef"
          >
            <div class="flex h-full w-full justify-between gap-6">
              <div class="flex w-[28rem] flex-col gap-3">
                <div class="flex space-x-3">
                  <UFormGroup label="Name" name="name" class="grow" required>
                    <UInput
                      v-model="creationState.name"
                      placeholder="Fußballturnier 2024/25"
                    />
                  </UFormGroup>
                  <UFormGroup label="Sportart" name="sport" required>
                    <USelect
                      v-model="creationState.sport"
                      placeholder="Sport auswählen"
                      :options="sports"
                      class="w-40"
                    />
                  </UFormGroup>
                </div>

                <UFormGroup class="grow" label="Ort" name="location" required>
                  <UInput v-model="creationState.location" />
                </UFormGroup>

                <UFormGroup label="Regeln" name="rules">
                  <UTextarea
                    v-model="creationState.rules"
                    :rows="4"
                    placeholder="Lorem Ipsum..."
                  />
                </UFormGroup>

                <div
                  class="flex flex-col gap-3 rounded-md border border-gray-200 p-3 dark:border-gray-700"
                >
                  <UFormGroup
                    label="Startdatum"
                    name="start_date"
                    description="An diesem Datum findet das Turnier statt."
                    required
                  >
                    <UInput v-model="creationState.start_date" type="date" />
                  </UFormGroup>

                  <div class="flex space-x-3">
                    <UFormGroup label="Von" name="from" required class="grow">
                      <UInput
                        v-model="creationState.from"
                        type="time"
                        :step="2"
                      />
                    </UFormGroup>

                    <UFormGroup label="Bis" name="to" required class="grow">
                      <UInput
                        v-model="creationState.to"
                        type="time"
                        :step="2"
                      />
                    </UFormGroup>
                  </div>
                </div>
              </div>
              <div class="flex flex-col gap-3">
                <UFormGroup
                  label="Vorschaubild"
                  name="thumbnail_path"
                  description="Ein Bild für das Turnier."
                  required
                >
                  <USelectMenu
                    v-model="creationState.thumbnail_path"
                    :options="thumbnails"
                    placeholder="Bild auswählen"
                  >
                    <template #option="{ option }">
                      <span class="font-mono text-xs">{{ option }}</span>
                    </template>
                  </USelectMenu>
                </UFormGroup>
                <p class="text-xs text-gray-500">
                  Keine Bilder? Lade eins hoch in
                  <NuxtLink to="/gallery">
                    <span class="text-primary-500">Galerie</span>
                    <UIcon
                      name="i-heroicons-arrow-up-right"
                      class="text-primary-500 ml-0.5 pt-1"
                      size="10"
                    />
                  </NuxtLink>
                </p>
                <UFormGroup label="Preise">
                  <div
                    class="flex flex-col gap-3 rounded-md bg-gray-50 p-3 dark:bg-gray-800"
                  >
                    <UFormGroup label="Erster Platz" name="prizes.first">
                      <UInput
                        v-model="creationState.prizes.first"
                        placeholder="Pokal"
                      />
                    </UFormGroup>
                    <div class="flex space-x-3">
                      <UFormGroup label="Zweiter Platz" name="prizes.second">
                        <UInput
                          v-model="creationState.prizes.second"
                          placeholder="Silver Medaille"
                        />
                      </UFormGroup>
                      <UFormGroup label="Dritter Platz" name="prizes.third">
                        <UInput
                          v-model="creationState.prizes.third"
                          placeholder="Bronze Medaille"
                        />
                      </UFormGroup>
                    </div>
                    <UFormGroup label="Sonstiges" name="prizes.bonus">
                      <UTextarea
                        v-model="creationState.prizes.bonus"
                        :rows="5"
                        placeholder="Eis, Frankfurter, etc."
                      />
                    </UFormGroup>
                  </div>
                </UFormGroup>
              </div>
            </div>
          </UForm>

          <template #footer>
            <div class="flex items-center gap-2">
              <UButton
                variant="soft"
                size="xs"
                @click="onSubmitCreate"
                label="Erstellen"
              />
              <UButton
                color="gray"
                size="xs"
                @click="isOpenCreate = false"
                label="Abbrechen"
              />
            </div>
          </template>
        </UCard>
      </UModal>
    </ToolbarContainer>
  </BasePageHeader>
  <BasePageContent>
    <div class="h-full overflow-auto p-6 pb-24">
      <div
        class="flex flex-col gap-3"
        v-for="(tournaments, year) in groupedTournaments"
        :key="year"
      >
        <div>
          <UBadge :label="year" variant="subtle" size="md" />
        </div>
        <TournamentGrid>
          <TournamentItem
            v-for="tournament in tournaments"
            :key="tournament.id"
            :tournament
            @refresh="refresh"
          />
        </TournamentGrid>
        <UDivider class="my-6" />
      </div>
    </div>
  </BasePageContent>
</template>
