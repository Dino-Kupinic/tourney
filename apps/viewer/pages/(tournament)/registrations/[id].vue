<script setup lang="ts">
import type { FormSubmitEvent } from "#ui/types"
import type { ParsedJsonTournament } from "~/types/prizes"
import { z } from "zod"
import RegistrationItem from "~/components/registration/RegistrationItem.vue"
import PageHeader from "~/components/layout/PageHeader.vue"

definePageMeta({
  name: "Anmeldung",
})

const route = useRoute()
const uuid = route.params.id

const { data: registration } = await useFetch(`/api/registrations/${uuid}`)
const { data: tournaments } = await useFetch("/api/tournaments/active")
const tournament = ref<ParsedJsonTournament>()

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
    <PageHeader
      title="Anmeldeformular"
      description="Trage dich hier ein für ein Turnier"
    />
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
      <RegistrationItem class="w-full gap-3 overflow-auto">
        <div v-for="x in 10" class="h-16 w-16 border bg-red-500"></div>
      </RegistrationItem>
    </UCard>
  </div>
</template>
