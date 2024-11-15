<script setup lang="ts">
import type { Tables } from "~/types/database.types"

defineProps<{
  name: string
  schoolClasses: Tables<"class">[]
}>()

const firstName = defineModel<string>("firstName")
const lastName = defineModel<string>("lastName")

const schoolClass = defineModel<Tables<"class">>("schoolClass")
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
        <UFormGroup label="Vorname" name="email" size="lg">
          <UInput v-model="firstName" placeholder="Max" />
        </UFormGroup>
        <UFormGroup label="Nachname" name="email" size="lg" class="grow">
          <UInput v-model="lastName" placeholder="Mustermann" />
        </UFormGroup>
      </div>
      <UFormGroup label="Klasse" name="email" size="lg">
        <USelectMenu
          v-model="schoolClass"
          :options="schoolClasses ?? []"
          option-attribute="name"
        />
      </UFormGroup>
    </div>
  </RegistrationItem>
</template>
