<script setup lang="ts">
import type { ParsedJsonTournament } from "~/types/prizes"

useHead({
  title: "Anmeldung",
})

const route = useRoute()
const uuid = route.params.id

const { data: registration } = await useFetch(`/api/registrations/${uuid}`)
const { data: tournaments } = await useFetch("/api/tournaments/active")
const tournament = ref<ParsedJsonTournament>()

const isOpen = ref<boolean>(false)
</script>

<template>
  <div>
    <PageHeader
      title="Anmeldeformular"
      description="Trage dich hier ein für ein Turnier"
    />
    <UCard
      :ui="{
        base: 'max-w-xl',
        body: {
          padding: 'p-4 sm:p-6',
        },
        header: {
          padding: 'p-4 sm:p-6',
        },
        footer: {
          padding: 'p-4 sm:p-6',
        },
      }"
    >
      <template #header>
        <div class="flex flex-col gap-3 text-base">
          <div
            class="flex justify-between rounded-md bg-gray-50 p-3 dark:bg-gray-800"
          >
            <div class="flex grow-0 flex-col gap-1">
              <strong>Status</strong>
              <StatusDisplay :status="registration?.status ?? ''" />
            </div>
            <div class="flex items-center justify-center">
              <UButton
                icon="i-ic-round-question-mark"
                size="md"
                square
                color="white"
                @click="isOpen = true"
              />
              <StatusExplanationModal v-model="isOpen" />
            </div>
          </div>
          <div class="flex gap-3">
            <RegistrationItem class="grow flex-col">
              <strong>Klasse</strong>
              <p>{{ registration?.name }}, {{ registration?.class?.name }}</p>
            </RegistrationItem>
            <RegistrationItem class="flex-col">
              <strong>Ablaufdatum</strong>
              <p>
                {{ useDateFormat(registration?.expire_date, "DD.MM.YYYY") }}
              </p>
            </RegistrationItem>
          </div>
          <div class="rounded-md bg-gray-50 p-3 dark:bg-gray-800">
            <USelectMenu
              v-model="tournament"
              :options="tournaments ?? []"
              placeholder="Wähle das Turnier"
              option-attribute="name"
              size="lg"
            />
          </div>
        </div>
      </template>
      <PageHeading>Spieler</PageHeading>
      <FootballForm />
      <PageHeading>Logo</PageHeading>
      <RegistrationItem class="w-full gap-3 overflow-x-auto">
        <div
          v-for="x in 30"
          :key="x"
          class="flex h-16 w-16 flex-shrink-0 items-center justify-center rounded-md border border-gray-200 bg-white dark:border-gray-700 dark:bg-gray-900"
        >
          <div>
            <NuxtImg
              width="48"
              height="48"
              :src="getImageUrl('/logos/star/star.svg')"
            />
            <p>Stern</p>
          </div>
        </div>
      </RegistrationItem>
      <PageHeading>Varianten</PageHeading>
      <RegistrationItem class="w-full gap-3 overflow-x-auto">
        <div
          v-for="x in 5"
          :key="x"
          class="flex h-16 w-16 flex-shrink-0 items-center justify-center rounded-md border border-gray-200 bg-white dark:border-gray-700 dark:bg-gray-900"
        >
          <div>
            <NuxtImg
              width="48"
              height="48"
              :src="getImageUrl('/logos/star/star.svg')"
            />
            <p>Farbe {{ x }}</p>
          </div>
        </div>
      </RegistrationItem>
      <UButton label="Anmelden" block size="lg" variant="soft" />
    </UCard>
  </div>
</template>
