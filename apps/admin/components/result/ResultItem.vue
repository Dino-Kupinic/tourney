<script setup lang="ts">
import type { Match } from "@tourney/types"
import { z } from "zod"

const { id, match, score1, score2, winner } = defineProps<{
  id: string
  match: Match
  score1: number
  score2: number
  winner: string | null
}>()

const logoTeam1 = computed(
  () => match.team1?.logo_variant?.image_path ?? match.team1?.logo?.image_path,
)
const logoTeam2 = computed(
  () => match.team2?.logo_variant?.image_path ?? match.team2?.logo?.image_path,
)

const stateWinner = computed(() => {
  if (editState.score1 > editState.score2) return match.team1
  if (editState.score1 < editState.score2) return match.team2
  return null
})

const isOpenEdit = ref<boolean>(false)
const editSchema = z.object({
  score1: z.number(),
  score2: z.number(),
  winner: z.string().optional(),
})

const editState = reactive({
  score1: score1,
  score2: score2,
  winner: stateWinner,
})

const supabase = useDatabaseClient()
const emit = defineEmits(["refresh"])
const onSubmitEdit = async () => {
  try {
    const { error } = await supabase
      .from("result")
      .update({
        team1_score: editState.score1,
        team2_score: editState.score2,
        winner_id: stateWinner?.value?.id ?? null,
      })
      .eq("id", id)
    isOpenEdit.value = false
    if (error) {
      throw new Error(error.message)
    }
    displaySuccessNotification("Erfolg", "Das Match wurde aktualisiert.")
    emit("refresh")
  } catch (error) {
    const err = error as Error
    displayFailureNotification("Fehler", err.message)
    throw createError({
      statusMessage: err.message,
    })
  }
}
</script>

<template>
  <ModalEdit
    v-model="isOpenEdit"
    modal-width="sm:max-w-md"
    @edit="onSubmitEdit"
  >
    <UForm :schema="editSchema" :state="editState" class="space-y-4">
      <div class="flex justify-between">
        <UFormGroup
          :label="match.team1?.name"
          name="score1"
          description="Punkteanzahl"
          required
        >
          <UInput v-model="editState.score1" type="number" />
        </UFormGroup>
        <UFormGroup
          :label="match.team2?.name"
          name="score2"
          description="Punkteanzahl"
          required
        >
          <UInput v-model="editState.score2" type="number" />
        </UFormGroup>
      </div>
      <p>
        Anhand von diesen Angaben, ist
        <strong class="text-primary-500">{{
          stateWinner?.name ?? "keiner"
        }}</strong>
        der Gewinner.
      </p>
      <p v-if="winner === null">Somit ein Unentschieden.</p>
    </UForm>
  </ModalEdit>
  <div class="rounded-md border border-gray-200 shadow-sm dark:border-gray-700">
    <div
      class="flex justify-between gap-0.5 rounded-t-md border-b border-gray-200 bg-gray-100 p-0.5 dark:border-gray-700 dark:bg-gray-800"
    >
      <div class="flex w-full justify-between">
        <div class="flex gap-0.5">
          <UBadge
            :label="match.round ?? 'Unbekannte Runde'"
            color="fuchsia"
            size="xs"
            variant="subtle"
            block
          />
          <UBadge
            :label="match.start_time!"
            color="gray"
            size="xs"
            icon="i-heroicons-clock"
            block
          />
          <UBadge
            :label="match.end_time!"
            color="gray"
            size="xs"
            icon="i-heroicons-bell"
            block
          />
        </div>

        <UButton
          icon="i-heroicons-pencil"
          color="gray"
          size="3xs"
          square
          @click="isOpenEdit = true"
        />
      </div>
    </div>
    <div class="flex flex-col items-center justify-between gap-1 px-6 py-3">
      <div class="flex w-full items-center justify-between">
        <div class="flex flex-col items-center space-y-1">
          <NuxtImg
            width="36"
            height="36"
            :src="getImageUrl(logoTeam1!)"
            :class="{
              'dark:invert dark:filter': match.team1?.logo_variant === null,
            }"
          />
          <p :class="['text-xs', winner === match.team1?.id && 'font-bold']">
            {{ match.team1?.name }}
          </p>
          <p class="text-xs text-gray-500">{{ match.team1?.group?.name }}</p>
        </div>
        <div class="flex items-center gap-5">
          <p class="text-4xl font-bold">{{ score1 }}</p>
          <p>vs</p>
          <p class="text-4xl font-bold">{{ score2 }}</p>
        </div>
        <div class="flex flex-col items-center space-y-1">
          <NuxtImg
            width="36"
            height="36"
            :src="getImageUrl(logoTeam2!)"
            :class="{
              'dark:invert dark:filter': match.team2?.logo_variant === null,
            }"
          />
          <p :class="['text-xs', winner === match.team2?.id && 'font-bold']">
            {{ match.team2?.name }}
          </p>
          <p class="text-xs text-gray-500">{{ match.team2?.group?.name }}</p>
        </div>
      </div>
    </div>
  </div>
</template>
