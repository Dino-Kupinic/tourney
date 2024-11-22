<script setup lang="ts">
import type { ParsedJsonTournament } from "~/types/prizes"
import type { Tables } from "~/types/database.types"
import type { FormPlayer } from "~/types/form"
import { FootballForm } from "#components"
import { key } from "~/keys/isFormLocked"

useHead({
  title: "Anmeldung",
})

const route = useRoute()
const uuid = route.params.id

const { data: registration } = await useFetch(`/api/registrations/${uuid}`)
if (!registration.value) {
  throw createError({
    statusCode: 404,
    message: "Anmeldung nicht gefunden",
  })
}

const { data: tournaments } = await useFetch("/api/tournaments/active")
const tournament = ref<ParsedJsonTournament>()

const isOpen = ref<boolean>(false)
const pdfName = ref<string>(`anmeldung_${registration.value?.class?.name}.pdf`)

const formPlayers = ref<FormPlayer[]>()
const players = ref<Omit<Tables<"player">, "id">[]>()

const downloadPdf = (response: Blob) => {
  const url = window.URL.createObjectURL(response)
  const a = document.createElement("a")
  a.href = url
  a.download = pdfName.value
  document.body.appendChild(a)
  a.click()
  document.body.removeChild(a)
}

const generatePDF = async () => {
  try {
    const formattedPlayers = formPlayers.value?.map((player) => {
      return `${player.firstName} ${player.lastName}, ${player.schoolClass.name}`
    })

    const payload = {
      pdfName: pdfName.value,
      id: registration.value?.id,
      date: tournament.value?.start_date,
      schoolClass: registration.value?.class?.name,
      players: formattedPlayers,
      year: new Date().getFullYear(),
      sport: tournament.value?.sport,
    }

    const response = await $fetch<Blob>("/api/pdf/generate", {
      method: "POST",
      body: JSON.stringify(payload),
    })

    downloadPdf(response)
  } catch (error) {
    throw createError({
      message: "Error generating PDF",
      data: error,
    })
  }
}

const displayPdfDownload: ComputedRef<boolean> = computed(() => {
  return registration.value?.status === "Abgesendet"
})

const isFormLocked: ComputedRef<boolean> = computed(() => {
  return registration.value?.status !== "Ausstehend"
})
provide(key, isFormLocked)

const formRef = useTemplateRef("formRef")
const submit = async () => {
  formRef.value?.$.exposed?.submitForm()

  if (registration.value) {
    registration.value.status = "Abgesendet"
    setTimeout(() => {
      window.scrollBy(0, 512)
    }, 500)
  }
}
</script>

<template>
  <div>
    <PageHeader
      title="Anmeldeformular"
      description="Trage dich hier ein für ein Turnier"
    />
    <UCard
      :ui="{
        base: 'max-w-xl mb-3',
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
              :disabled="isFormLocked"
              :options="tournaments ?? []"
              placeholder="Wähle das Turnier"
              option-attribute="name"
              size="lg"
            />
          </div>
        </div>
      </template>
      <template v-if="tournament">
        <PageHeading>Spieler</PageHeading>
        <FootballForm
          v-model:players="formPlayers"
          :default-class="registration?.class"
          ref="formRef"
        />
        <PageHeading>Logo</PageHeading>
        <RegistrationItem class="w-full gap-3 overflow-x-auto">
          <div v-for="x in 20" :key="x">
            <div
              class="flex h-16 w-16 flex-shrink-0 items-center justify-center rounded-md border border-gray-200 bg-white dark:border-gray-700 dark:bg-gray-900"
            >
              <NuxtImg
                width="48"
                height="48"
                :src="getImageUrl('/logos/star/star.svg')"
              />
            </div>
            <p class="mt-1 text-wrap text-center text-xs text-gray-500">
              Stern
            </p>
          </div>
        </RegistrationItem>
        <PageHeading>Varianten</PageHeading>
        <RegistrationItem class="w-full gap-3 overflow-x-auto">
          <div v-for="x in 3" :key="x">
            <div
              class="flex h-16 w-16 flex-shrink-0 items-center justify-center rounded-md border border-gray-200 bg-white dark:border-gray-700 dark:bg-gray-900"
            >
              <NuxtImg
                width="48"
                height="48"
                :src="getImageUrl('/logos/star/star.svg')"
              />
            </div>
            <p class="mt-1 text-wrap text-center text-xs text-gray-500">
              Farbe {{ x }}
            </p>
          </div>
        </RegistrationItem>
        <UAlert
          icon="i-heroicons-exclamation-triangle"
          color="yellow"
          variant="soft"
          class="my-3"
          title="Warnung"
          description="Die Daten können nicht mehr geändert werden. Falls ihr einen Fehler
          gemacht habt, wendet euch an einen Verantwortlichen für eine Freigabe."
        />
        <UButton
          label="Anmelden"
          @click="submit"
          block
          size="lg"
          variant="soft"
        />
      </template>
      <template v-else>
        <p class="text-center">Es wurde noch kein Turnier ausgewählt.</p>
      </template>
      <template #footer v-if="displayPdfDownload">
        <PageHeading>Nächsten Schritte</PageHeading>
        <div class="flex flex-col gap-3">
          <RegistrationItem class="flex-col gap-3">
            <div>
              <strong>1. Runterladen</strong>
              <p>Lade dir die PDF Datei auf deinem Gerät runter.</p>
            </div>
            <div>
              <strong>2. Bearbeiten</strong>
              <p>
                Öffne die Datei und fülle die Freistellungs-Tabelle aus. Lasse
                jede Einheit von den jeweiligen Lehrer/-innen unterschreiben.
              </p>
            </div>
            <div>
              <strong>3. Abgeben</strong>
              <p>Drucke die Datei aus und gebe sie ab.</p>
            </div>
            <UAlert
              icon="i-heroicons-information-circle"
              color="blue"
              variant="soft"
              title="Information"
              description="Die Anmeldung ist erst gültig, wenn das Formular abgegeben wurde."
            />
          </RegistrationItem>
          <RegistrationItem class="flex-col">
            <strong>PDF-Dokument</strong>
            <p>
              Name:
              <strong>{{ pdfName }}</strong>
            </p>
            <p>Das Dokument kann so oft wie nötig runtergeladen werden.</p>
          </RegistrationItem>
          <UButton
            block
            label="Download"
            size="lg"
            variant="soft"
            :ui="{
              gap: {
                lg: 'gap-x-2',
              },
            }"
            icon="i-heroicons-document-arrow-down"
            @click="generatePDF"
          />
          <UAlert
            icon="i-heroicons-exclamation-circle"
            color="red"
            variant="soft"
            title="Probleme beim runterladen?"
            description="Versuche es mit einem anderen Browser oder Gerät. Ansonsten wende dich
          an einen Verantwortlichen."
          />
        </div>
      </template>
    </UCard>
  </div>
</template>
