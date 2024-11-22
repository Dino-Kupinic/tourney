<script setup lang="ts">
import { z } from "zod"
import type { Tables } from "~/types/database.types"
import type { FormPlayer } from "~/types/form"
import type { UForm } from "#components"
import type { Form } from "#ui/types"

const { defaultClass } = defineProps<{
  defaultClass: Tables<"class"> | null | undefined
}>()

if (defaultClass === undefined || defaultClass === null) {
  throw createError({
    statusCode: 404,
    message: "Klasse nicht gefunden",
  })
}

const { data: schoolClasses } = await useFetch("/api/classes")

const model = defineModel<FormPlayer[]>("players")
const PLAYER_LENGTH = 2

const schema = z.object({
  players: z
    .array(
      z.object({
        firstName: z.string().min(1),
        lastName: z.string().min(1),
        schoolClass: z.custom<Tables<"class">>(),
      }),
    )
    .length(PLAYER_LENGTH),
})
type Schema = z.output<typeof schema>
const state = reactive({
  players: Array.from({ length: PLAYER_LENGTH }, () => ({
    firstName: "",
    lastName: "",
    schoolClass: defaultClass,
  })),
})

const form = useTemplateRef<Form<Schema>>("form")
async function submitForm() {
  try {
    const result = schema.safeParse(state)
    if (!result.success) {
      const formErrors = result.error.errors.map((err) => ({
        path: err.path.join("."),
        message: err.message,
      }))
      form.value?.setErrors(formErrors)
    } else {
      model.value = state.players
    }
  } catch (error) {
    throw createError({
      statusCode: 500,
      message: "Unerwarteter Fehler bei der Validierung",
    })
  }
}
defineExpose({ submitForm })
</script>

<template>
  <UForm :schema="schema" :state="state" class="my-2 space-y-4" ref="form">
    <template v-for="(player, index) in state.players" :key="index">
      <BasePlayerItem
        :index="index"
        :name="'Spieler ' + (index + 1) + (index >= 6 ? ' (Ersatz)' : '')"
        :schoolClasses="schoolClasses ?? []"
        v-model:first-name="player.firstName"
        v-model:last-name="player.lastName"
        v-model:school-class="player.schoolClass"
      />
    </template>
  </UForm>
</template>
