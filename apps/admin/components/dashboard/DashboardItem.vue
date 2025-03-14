<script setup lang="ts">
defineProps<{
  title: string
  value: any
  icon: string
}>()
</script>

<template>
  <UCard class="p-2 dark:bg-gray-800 dark:ring-gray-700">
    <div class="flex flex-col gap-2">
      <div
        class="flex w-full items-center justify-between text-gray-500 dark:text-gray-400"
      >
        <div class="text-sm font-semibold tracking-tight">
          {{ title }}
        </div>
        <UIcon :name="icon" class="h-4 w-4" />
      </div>
      <div class="text-3xl font-bold">
        {{ value }}
      </div>
    </div>
    <div class="mt-4 flex items-center text-xs">
      <slot />
    </div>
  </UCard>
</template>
