<script setup lang="ts">
const isOpenDelete = defineModel<boolean>()
defineEmits<{
  delete: () => void
}>()
</script>

<template>
  <UModal v-model="isOpenDelete" :ui="{ width: 'w-full sm:max-w-md' }">
    <UCard
      :ui="{
        divide: 'divide-y divide-gray-100 dark:divide-gray-800',
        body: {
          padding: 'px-4 py-5 sm:p-6',
        },
        header: {
          padding: 'px-4 py-3 sm:px-6',
        },
        footer: {
          padding: 'px-4 py-3 sm:px-6',
        },
      }"
    >
      <template #header>
        <strong> Löschen </strong>
      </template>

      <slot />

      <template #footer>
        <div class="flex items-center gap-2">
          <UButton
            variant="soft"
            size="xs"
            color="red"
            @click="$emit('delete')"
            label="Löschen"
          />
          <UButton
            color="gray"
            size="xs"
            @click="isOpenDelete = false"
            label="Abbrechen"
          />
        </div>
      </template>
    </UCard>
  </UModal>
</template>
