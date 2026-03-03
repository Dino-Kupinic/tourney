<script setup lang="ts">
import type { Enums } from "@tourney/types"

defineProps<{
  schema: any
  state: any
}>()

const sports: Enums<"sport_type">[] = ["Fußball", "Basketball", "Volleyball"]
const client = useSupabaseClient()
const { data } = await client.storage.from("images").list("tournament")
const thumbnails = computed(() => {
  const temp = data?.filter((image) => image.name !== ".emptyFolderPlaceholder")
  return temp?.map((image) => `/tournament/${image.name}`)
})
</script>

<template>
  <UForm :schema="schema" :state="state" class="pt-2" :validate-on="[]">
    <div class="flex h-full w-full justify-between gap-6">
      <div class="flex w-[28rem] flex-col gap-3">
        <div class="flex space-x-3">
          <UFormField label="Name" name="name" class="grow" required>
            <UInput
              v-model="state.name"
              placeholder="Fußball Turnier 2024/25"
            />
          </UFormField>
          <UFormField label="Sportart" name="sport" required>
            <USelect
              v-model="state.sport"
              placeholder="Sport auswählen"
              :items="sports"
              class="w-40"
            />
          </UFormField>
        </div>

        <UFormField class="grow" label="Ort" name="location" required>
          <UInput v-model="state.location" />
        </UFormField>

        <UFormField label="Regeln" name="rules">
          <UTextarea
            v-model="state.rules"
            :rows="4"
            placeholder="Lorem Ipsum..."
          />
        </UFormField>

        <div class="flex gap-3">
          <div
            class="flex flex-col gap-3 rounded-md border border-gray-200 p-3 dark:border-gray-700"
          >
            <UFormField
              label="Startdatum"
              name="start_date"
              description="An diesem Datum findet es statt."
              required
            >
              <UInput v-model="state.start_date" type="date" />
            </UFormField>

            <div class="flex space-x-3">
              <UFormField label="Von" name="from" required class="grow">
                <UInput v-model="state.from" type="time" :step="60" />
              </UFormField>

              <UFormField label="Bis" name="to" required class="grow">
                <UInput v-model="state.to" type="time" :step="60" />
              </UFormField>
            </div>
          </div>

          <div
            class="flex flex-col justify-between gap-3 rounded-md border border-gray-200 p-3 dark:border-gray-700"
          >
            <UFormField
              label="Knockout Interval"
              name="knockout_interval"
              description="Matchlänge für Matches nach der Gruppenphase."
              required
            >
            </UFormField>
            <UInput v-model="state.knockout_interval" type="number" />
          </div>
        </div>
      </div>
      <div class="flex flex-col gap-3">
        <UFormField
          label="Vorschaubild"
          name="thumbnail_path"
          description="Ein Bild für das Turnier."
          required
        >
          <USelectMenu
            v-model="state.thumbnail_path"
            :items="thumbnails"
            placeholder="Bild auswählen"
          >
            <template #item-label="{ item }">
              <span class="font-mono text-xs">{{ item }}</span>
            </template>
          </USelectMenu>
        </UFormField>
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
        <UFormField label="Preise">
          <div
            class="flex flex-col gap-3 rounded-md bg-gray-50 p-3 dark:bg-gray-800"
          >
            <UFormField label="Erster Platz" name="prizes.first">
              <UInput v-model="state.prizes.first" placeholder="Pokal" />
            </UFormField>
            <div class="flex space-x-3">
              <UFormField label="Zweiter Platz" name="prizes.second">
                <UInput
                  v-model="state.prizes.second"
                  placeholder="Silver Medaille"
                />
              </UFormField>
              <UFormField label="Dritter Platz" name="prizes.third">
                <UInput
                  v-model="state.prizes.third"
                  placeholder="Bronze Medaille"
                />
              </UFormField>
            </div>
            <UFormField label="Sonstiges" name="prizes.bonus">
              <UTextarea
                v-model="state.prizes.bonus"
                :rows="5"
                placeholder="Eis, Frankfurter, etc."
              />
            </UFormField>
          </div>
        </UFormField>
      </div>
    </div>
  </UForm>
</template>
