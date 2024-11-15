<script setup lang="ts">
import { z } from "zod"
import type { FormSubmitEvent } from "#ui/types"
import type { Tables } from "~/types/database.types"
import type { FormPlayer } from "~/types/form"

const { isLocked, defaultClass } = defineProps<{
  isLocked: boolean
  defaultClass: Tables<"class">
}>()

const { data: schoolClasses } = await useFetch("/api/classes")

const model = defineModel<FormPlayer[]>("players")
const playerSchema = z.object({
  firstName: z.string(),
  lastName: z.string(),
  schoolClass: z.custom<Tables<"class">>(),
})

const schema = z.object({
  players: z.array(playerSchema).length(10),
})

type Schema = z.output<typeof schema>

const state = reactive({
  players: Array.from({ length: 10 }, () => ({
    firstName: "",
    lastName: "",
    schoolClass: defaultClass,
  })),
})

async function onSubmit(event: FormSubmitEvent<Schema>) {
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
    <template v-for="(player, index) in state.players" :key="index">
      <BasePlayerItem
        :name="'Spieler ' + (index + 1) + (index >= 6 ? ' (Ersatz)' : '')"
        :schoolClasses="schoolClasses ?? []"
        v-model:first-name="player.firstName"
        v-model:last-name="player.lastName"
        v-model:school-class="player.schoolClass"
      />
    </template>
  </UForm>
</template>
