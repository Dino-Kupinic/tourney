<script setup lang="ts">
const { place } = defineProps<{
  place: 1 | 2 | 3 | 4
}>()

const bgColor = computed(() => {
  switch (place) {
    case 1:
      return "bg-amber-200 dark:bg-amber-500"
    case 2:
      return "bg-gray-200 dark:bg-gray-500"
    case 3:
      return "bg-yellow-600 dark:bg-yellow-700"
    case 4:
      return "bg-gray-300 dark:bg-gray-600"
  }
})
</script>

<template>
  <div
    class="flex items-center gap-3 rounded-md bg-gray-100 p-2 text-base sm:text-sm dark:bg-gray-800"
  >
    <div
      :class="[
        'flex h-7 w-7 shrink-0 items-center justify-center rounded-md p-2 sm:h-6 sm:w-6',
        bgColor,
      ]"
    >
      <span class="text-base">{{ place }}</span>
    </div>
    <p class="truncate">
      <slot />
    </p>
  </div>
</template>
