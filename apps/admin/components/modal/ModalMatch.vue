<script setup lang="ts">
const isOpenConfirm = defineModel<boolean>()
defineEmits<{
  confirm: () => void
}>()

const loading = defineModel<boolean>("loading")
</script>

<template>
  <UModal v-model:open="isOpenConfirm" :ui="{ content: 'w-full sm:max-w-md' }">
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
          <strong> Spiel beenden? </strong>
        </template>

        <slot />

        <template #footer>
          <div class="flex items-center gap-2">
            <UButton
              variant="soft"
              size="sm"
              color="secondary"
              @click="$emit('confirm')"
              label="Beenden"
              :loading="loading"
            />
            <UButton
              color="neutral"
              variant="outline"
              size="sm"
              @click="isOpenConfirm = false"
              label="Abbrechen"
            />
          </div>
        </template>
      </UCard>
    </template>
  </UModal>
</template>
