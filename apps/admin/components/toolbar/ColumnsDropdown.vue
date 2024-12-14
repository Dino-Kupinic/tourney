<script setup lang="ts">
import type { TableColumn } from "#ui/types"

const model = defineModel<TableColumn[]>()
defineProps<{
  columns: TableColumn[]
}>()
</script>

<template>
  <USelectMenu v-model="model" :options="columns" multiple v-slot="{ open }">
    <UButton color="gray" size="xs" class="w-32 flex-1 justify-between">
      <div class="flex items-center gap-1">
        <UIcon name="i-heroicons-view-columns" class="h-4 w-4" />
        Spalten
      </div>
      <UIcon
        name="i-heroicons-chevron-right-20-solid"
        class="h-4 w-4 text-gray-400 transition-transform dark:text-gray-500"
        :class="[open && 'rotate-90 transform']"
      />
    </UButton>
  </USelectMenu>
</template>
