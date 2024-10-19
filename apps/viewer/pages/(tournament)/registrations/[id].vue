<script setup lang="ts">
import type { FormSubmitEvent } from "#ui/types"
import type { ParsedJsonTournament } from "~/types/prizes"
import { z } from "zod"

definePageMeta({
  name: "Anmeldung",
})

const route = useRoute()
const uuid = route.params.id

const { data: registration } = await useFetch(`/api/registrations/${uuid}`)
const { data: tournaments } = await useFetch("/api/tournaments")
const tournament = ref<ParsedJsonTournament>()
console.log(tournaments.value)

const schema = z.object({
  email: z.string().email("Invalid email"),
  password: z.string().min(8, "Must be at least 8 characters"),
})

type Schema = z.output<typeof schema>

const state = reactive({
  email: undefined,
  password: undefined,
})

async function onSubmit(event: FormSubmitEvent<Schema>) {
  // Do something with data
  console.log(event.data)
}

const isOpen = ref<boolean>(false)
</script>

<template>
  <div>
    <PageTitle class="mb-0">Anmeldeformular</PageTitle>
    <PageDescription>Trage dich hier ein für ein Turnier</PageDescription>
    <UCard
      :ui="{
        body: {
          padding: 'p-4',
        },
        header: {
          padding: 'p-4',
        },
        footer: {
          padding: 'p-4',
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
              <UBadge
                size="md"
                v-if="registration?.status === 'Ausstehend'"
                label="Ausstehend"
                color="yellow"
                variant="subtle"
              />
              <UBadge
                size="md"
                v-else-if="registration?.status === 'Abgesendet'"
                label="Abgesendet"
                color="orange"
                variant="subtle"
              />
              <UBadge
                size="md"
                v-else-if="registration?.status === 'Abgeschlossen'"
                label="Abgeschlossen"
                color="green"
                variant="subtle"
              />
              <UBadge
                size="md"
                v-else
                label="Abgelehnt"
                color="red"
                variant="subtle"
              />
            </div>
            <div class="flex items-center justify-center">
              <UButton
                icon="i-ic-round-question-mark"
                size="md"
                square
                color="white"
                @click="isOpen = true"
              />

              <UModal v-model="isOpen" :ui="{ width: 'w-full sm:max-w-96' }">
                <div class="p-4">
                  <PageHeading class="text-center">
                    Status der Anmeldung
                  </PageHeading>
                  <div class="my-4 flex flex-col gap-3 text-base sm:text-sm">
                    <div class="space-y-2">
                      <UBadge
                        label="Ausstehend"
                        color="yellow"
                        variant="subtle"
                      />
                      <p>Die Anmeldung muss noch ausgefüllt werden.</p>
                    </div>
                    <div class="space-y-2">
                      <UBadge
                        label="Abgesendet"
                        color="orange"
                        variant="subtle"
                      />
                      <p>
                        Die PDF wurde generiert und muss akzeptiert werden. Die
                        Anmeldung kann nichtmehr geändert werden.
                      </p>
                      <p>
                        Bei Fehlern kann sie von einem Lehrer wieder freigegeben
                        werden.
                      </p>
                    </div>
                    <div class="space-y-2">
                      <UBadge
                        label="Abgeschlossen"
                        color="green"
                        variant="subtle"
                      />
                      <p>Alles passt! Ihr wurdet erfolgreich angemeldet.</p>
                    </div>
                    <div class="space-y-2">
                      <UBadge label="Abgelehnt" color="red" variant="subtle" />
                      <p>
                        Ungültig oder das Turnier hat zu viele Teams und ein
                        paar Teams müssen entfernt werden.
                      </p>
                    </div>
                  </div>
                  <UButton
                    label="Ok, verstanden"
                    block
                    size="lg"
                    variant="soft"
                    @click="isOpen = false"
                  />
                </div>
              </UModal>
            </div>
          </div>
          <div class="flex gap-3">
            <div
              class="flex grow flex-col space-y-1 rounded-md bg-gray-50 p-3 dark:bg-gray-800"
            >
              <strong>Klasse</strong>
              <p>{{ registration?.name }}, {{ registration?.class?.name }}</p>
            </div>
            <div
              class="flex flex-col space-y-1 rounded-md bg-gray-50 p-3 dark:bg-gray-800"
            >
              <strong>Ablaufdatum</strong>
              <p>
                {{ useDateFormat(registration?.expire_date, "DD.MM.YYYY") }}
              </p>
            </div>
          </div>
          <div class="rounded-md bg-gray-50 p-3 dark:bg-gray-800">
            <USelectMenu
              v-if="tournaments"
              v-model="tournament"
              :options="tournaments"
              placeholder="Wähle das Turnier"
              option-attribute="name"
              size="lg"
            />
          </div>
        </div>
      </template>
      <PageHeading>Spieler</PageHeading>
      <!--      <UForm-->
      <!--        :schema="schema"-->
      <!--        :state="state"-->
      <!--        class="space-y-4"-->
      <!--        @submit="onSubmit"-->
      <!--      >-->
      <!--        <UFormGroup label="Email" name="email">-->
      <!--          <UInput v-model="state.email" />-->
      <!--        </UFormGroup>-->

      <!--        <UFormGroup label="Password" name="password">-->
      <!--          <UInput v-model="state.password" type="password" />-->
      <!--        </UFormGroup>-->

      <!--        <UButton type="submit"> Submit </UButton>-->
      <!--      </UForm>-->
      <PageHeading>Logo</PageHeading>
    </UCard>
  </div>
</template>
