<script setup lang="ts">
defineProps<{
  name: string
}>()

const firstName = defineModel<string>("firstName")
const lastName = defineModel<string>("lastName")

// TODO: change to school class obj
const schoolClass = defineModel<string>("schoolClass")
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
        <!-- TODO: change to dropdown -->
        <UInput v-model="schoolClass" />
      </UFormGroup>
    </div>
  </RegistrationItem>
</template>
