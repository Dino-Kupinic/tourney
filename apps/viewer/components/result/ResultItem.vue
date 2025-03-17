<script setup lang="ts">
import type { Match } from "~/types/match"
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
</script>

<template>
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
            color="white"
            size="xs"
            icon="i-heroicons-clock"
            block
          />
          <UBadge
            :label="match.end_time!"
            color="white"
            size="xs"
            icon="i-heroicons-bell"
            block
          />
        </div>
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
