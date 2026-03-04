<script setup lang="ts">
import type { Tables } from "@tourney/types"
import { formLocked } from "~/keys/isFormLocked"
import { classMixing } from "~/keys/allowClassMixing"

const { index } = defineProps<{
  index: number
  name: string
  schoolClasses: Tables<"class">[]
}>()

const firstName = defineModel<string>("firstName")
const lastName = defineModel<string>("lastName")
const schoolClass = defineModel<Tables<"class">>("schoolClass")

const isLocked = inject(formLocked)
const allowClassMixing = inject(classMixing)

const fNameInput = `players.${index}.firstName`
const lNameInput = `players.${index}.lastName`
</script>

<template>
  <RegistrationItem>
    <div class="flex grow flex-col gap-3">
      <div
        class="w-full rounded-md border bg-white p-1 text-center dark:border-neutral-700 dark:bg-neutral-700"
      >
        <strong class="text-base"> {{ name }} </strong>
      </div>
      <div class="flex flex-col gap-3 sm:flex-row">
        <UFormField label="Vorname" :name="fNameInput" size="lg">
          <UInput v-model="firstName" placeholder="Max" :disabled="isLocked" />
        </UFormField>
        <UFormField label="Nachname" :name="lNameInput" size="lg" class="grow">
          <UInput
            v-model="lastName"
            placeholder="Mustermann"
            :disabled="isLocked"
          />
        </UFormField>
      </div>
      <UFormField label="Klasse" name="email" size="lg" v-if="allowClassMixing">
        <USelectMenu
          v-model="schoolClass"
          :items="schoolClasses ?? []"
          option-attribute="name"
          :disabled="isLocked"
        />
      </UFormField>
    </div>
  </RegistrationItem>
</template>
