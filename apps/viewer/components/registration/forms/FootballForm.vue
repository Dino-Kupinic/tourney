<script setup lang="ts">
import { z } from "zod"
import type { FormSubmitEvent } from "#ui/types"

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
</script>

<template>
  <UForm
    :schema="schema"
    :state="state"
    class="my-2 space-y-4"
    @submit="onSubmit"
  >
    <BasePlayerItem
      name="Tormann"
      v-model:first-name="state.email"
      v-model:last-name="state.email"
      v-model:school-class="state.email"
    />
    <BasePlayerItem
      name="Feldspieler 1"
      v-model:first-name="state.email"
      v-model:last-name="state.email"
      v-model:school-class="state.email"
    />
    <BasePlayerItem
      name="Feldspieler 2"
      v-model:first-name="state.email"
      v-model:last-name="state.email"
      v-model:school-class="state.email"
    />
    <BasePlayerItem
      name="Feldspieler 3"
      v-model:first-name="state.email"
      v-model:last-name="state.email"
      v-model:school-class="state.email"
    />
    <BasePlayerItem
      name="Feldspieler 4"
      v-model:first-name="state.email"
      v-model:last-name="state.email"
      v-model:school-class="state.email"
    />
    <BasePlayerItem
      name="Feldspieler 5"
      v-model:first-name="state.email"
      v-model:last-name="state.email"
      v-model:school-class="state.email"
    />
    <BasePlayerItem
      name="Ersatzspieler 1"
      v-model:first-name="state.email"
      v-model:last-name="state.email"
      v-model:school-class="state.email"
    />
    <BasePlayerItem
      name="Ersatzspieler 2"
      v-model:first-name="state.email"
      v-model:last-name="state.email"
      v-model:school-class="state.email"
    />
  </UForm>
</template>

<style scoped></style>
