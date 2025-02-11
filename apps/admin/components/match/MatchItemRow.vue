<script setup lang="ts">
import type { Match } from "~/types/match"

defineProps<{
  match: Match
  next: boolean
}>()
</script>

<template>
  <div
    class="flex w-full flex-col items-center justify-between rounded-md border border-gray-200 px-6 py-3 shadow-sm dark:border-gray-700"
  >
    <div class="flex w-full items-center justify-between">
      <div class="flex flex-col items-center space-y-1">
        <UIcon name="i-game-icons-heartburn" size="24" />
        <div class="flex flex-col items-center">
          <p class="text-xs">{{ match.team1?.name }}</p>
          <p class="text-xs text-gray-500">{{ match.team1?.group?.name }}</p>
        </div>
      </div>
      <div class="flex h-full flex-col items-center justify-between">
        <UBadge
          v-if="next"
          label="Nächstes Spiel"
          color="green"
          size="xs"
          variant="subtle"
          block
        />
        <p class="text-xs text-gray-500">{{ match.round }}</p>
        <p>vs</p>
        <p class="text-xs text-gray-500">{{ match.start_time }}</p>
      </div>
      <div class="flex flex-col items-center space-y-1">
        <UIcon name="i-game-icons-dragon-head" size="24" />
        <div class="flex flex-col items-center">
          <p class="text-xs">{{ match.team2?.name }}</p>
          <p class="text-xs text-gray-500">{{ match.team2?.group?.name }}</p>
        </div>
      </div>
    </div>
  </div>
</template>
