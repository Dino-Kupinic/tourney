<script setup lang="ts">
import type { Match } from "~/types/match"

const { match } = defineProps<{
  match: Match
  next: boolean
}>()

const emit = defineEmits(["live"])
const logoTeam1 = computed(() => {
  return match.team1?.logo_variant?.image_path ?? match.team1?.logo?.image_path
})
const logoTeam2 = computed(() => {
  return match.team2?.logo_variant?.image_path ?? match.team2?.logo?.image_path
})

const startTime = computed(() => {
  return match.start_time?.split(":").slice(0, 2).join(":")
})
</script>

<template>
  <div class="rounded-md border border-gray-200 shadow-sm dark:border-gray-700">
    <div
      class="flex justify-between gap-0.5 rounded-t-md border-b border-gray-200 bg-gray-100 p-0.5 dark:border-gray-700 dark:bg-gray-800"
    >
      <div v-if="next" class="flex gap-0.5">
        <UBadge
          label="Nächstes Spiel"
          color="green"
          size="xs"
          variant="subtle"
          block
        />
      </div>
      <UBadge
        v-else
        label="Anstehendes Spiel"
        color="yellow"
        size="xs"
        variant="subtle"
        block
      />
    </div>
    <div
      class="flex w-full flex-col items-center justify-between px-6 pb-3 pt-2"
    >
      <div class="flex w-full items-center justify-between">
        <div class="flex flex-col items-center space-y-1">
          <NuxtImg
            width="24"
            height="24"
            :src="getImageUrl(logoTeam1!)"
            :class="{
              'dark:invert dark:filter': match.team1?.logo_variant === null,
            }"
          />

          <div class="flex flex-col items-center">
            <p class="text-xs">{{ match.team1?.name }}</p>
            <p class="text-xs text-gray-500">{{ match.team1?.group?.name }}</p>
          </div>
        </div>
        <div class="flex h-full flex-col items-center justify-between">
          <p class="text-xs text-gray-500">{{ match.round }}</p>
          <p>vs</p>
          <p class="text-xs text-gray-500">ca. {{ startTime }}</p>
        </div>
        <div class="flex flex-col items-center space-y-1">
          <NuxtImg
            width="24"
            height="24"
            :src="getImageUrl(logoTeam2!)"
            :class="{
              'dark:invert dark:filter': match.team2?.logo_variant === null,
            }"
          />
          <div class="flex flex-col items-center">
            <p class="text-xs">{{ match.team2?.name }}</p>
            <p class="text-xs text-gray-500">{{ match.team2?.group?.name }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
