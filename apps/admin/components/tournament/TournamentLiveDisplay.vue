<script setup lang="ts">
defineProps<{
  isLive: boolean
}>()
</script>

<template>
  <div
    v-if="isLive"
    class="flex items-center space-x-1.5 rounded-md bg-red-50 px-2 py-1 ring-1 ring-inset ring-red-500 ring-opacity-25 dark:bg-red-500 dark:bg-opacity-10 dark:ring-red-400 dark:ring-opacity-25"
  >
    <span class="relative flex h-2 w-2">
      <span
        class="absolute inline-flex h-full w-full animate-ping rounded-full bg-red-400 opacity-75"
      ></span>
      <span class="relative inline-flex h-2 w-2 rounded-full bg-red-500"></span>
    </span>
    <p class="text-xs font-medium text-red-500 dark:text-red-400">Live</p>
  </div>
  <UBadge label="Inaktiv" color="white" size="sm" v-else />
</template>
