<script setup lang="ts">
type DataTableColumn = object

const model = defineModel<DataTableColumn[]>()
defineProps<{
  columns: DataTableColumn[]
}>()
</script>

<template>
  <USelectMenu v-model="model" :items="columns" multiple v-slot="{ open }">
    <UButton color="neutral" size="xs" class="w-32 flex-1 justify-between">
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
