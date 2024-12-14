<script setup lang="ts">
const isOpenInfo = defineModel<boolean>()
</script>

<template>
  <UModal v-model="isOpenInfo" :ui="{ width: 'w-full sm:max-w-md' }">
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
        <strong> Info </strong>
      </template>

      <slot />

      <template #footer>
        <div class="flex items-center gap-2">
          <UButton
            color="gray"
            size="xs"
            @click="isOpenInfo = false"
            label="Fertig"
          />
        </div>
      </template>
    </UCard>
  </UModal>
</template>
