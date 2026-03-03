<script setup lang="ts">
const isOpenDelete = defineModel<boolean>()
defineEmits<{
  delete: () => void
}>()
</script>

<template>
  <UModal v-model:open="isOpenDelete" :ui="{ content: 'w-full sm:max-w-md' }">
    <template #content>
      <UCard
        :ui="{
          root: 'divide-y divide-gray-100 dark:divide-gray-800',
          body: 'px-4 py-5 sm:p-6',
          header: 'px-4 py-3 sm:px-6',
          footer: 'px-4 py-3 sm:px-6',
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
              color="error"
              @click="$emit('delete')"
              label="Löschen"
            />
            <UButton
              color="neutral"
              size="xs"
              @click="isOpenDelete = false"
              label="Abbrechen"
            />
          </div>
        </template>
      </UCard>
    </template>
  </UModal>
</template>
