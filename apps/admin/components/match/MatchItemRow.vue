<script setup lang="ts">
import type { Match } from "~/types/match"

defineProps<{
  match: Match
  next: boolean
}>()

const isOpenInfo = ref<boolean>(false)
</script>

<template>
  <ModalInfo v-model="isOpenInfo">
    <pre class="overflow-auto">{{ match }}</pre>
  </ModalInfo>
  <div class="rounded-md border border-gray-200 shadow-sm dark:border-gray-700">
    <div
      class="flex justify-between gap-0.5 rounded-t-md border-b border-gray-200 bg-gray-100 p-0.5 dark:border-gray-700"
    >
      <UBadge
        v-if="next"
        label="Nächstes Spiel"
        color="green"
        size="xs"
        variant="subtle"
        block
      />
      <UBadge
        v-else
        label="Anstehendes Spiel"
        color="yellow"
        size="xs"
        variant="subtle"
        block
      />
      <UButton
        icon="i-heroicons-pencil"
        color="gray"
        size="3xs"
        square
        @click=""
      />
    </div>
    <div
      class="flex w-full flex-col items-center justify-between px-6 pb-3 pt-1.5 hover:cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-800"
      @click="isOpenInfo = true"
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
  </div>
</template>
