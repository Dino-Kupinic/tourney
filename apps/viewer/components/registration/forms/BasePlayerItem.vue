<script setup lang="ts">
import type { Tables } from "~/types/database.types"
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
        class="w-full rounded-md border bg-white p-1 text-center dark:border-gray-700 dark:bg-gray-700"
      >
        <strong class="text-base"> {{ name }} </strong>
      </div>
      <div class="flex flex-col gap-3 sm:flex-row">
        <UFormGroup label="Vorname" :name="fNameInput" size="lg">
          <UInput v-model="firstName" placeholder="Max" :disabled="isLocked" />
        </UFormGroup>
        <UFormGroup label="Nachname" :name="lNameInput" size="lg" class="grow">
          <UInput
            v-model="lastName"
            placeholder="Mustermann"
            :disabled="isLocked"
          />
        </UFormGroup>
      </div>
      <UFormGroup label="Klasse" name="email" size="lg" v-if="allowClassMixing">
        <USelectMenu
          v-model="schoolClass"
          :options="schoolClasses ?? []"
          option-attribute="name"
          :disabled="isLocked"
        />
      </UFormGroup>
    </div>
  </RegistrationItem>
</template>
