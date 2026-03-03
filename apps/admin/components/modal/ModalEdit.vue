<script setup lang="ts">
const isOpenEdit = defineModel<boolean>()
const { modalWidth } = defineProps<{
  modalWidth?: string
}>()

defineEmits<{
  edit: () => void
}>()

const defaultModalWidth = "sm:max-w-xl"
const modalUI = computed(() => ({
  content: `w-full ${modalWidth || defaultModalWidth}`,
}))
</script>

<template>
  <UModal v-model:open="isOpenEdit" :ui="modalUI">
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
          <strong> Editieren </strong>
        </template>

        <slot />

        <template #footer>
          <div class="flex items-center gap-2">
            <UButton
              variant="soft"
              size="sm"
              @click="$emit('edit')"
              label="Speichern"
            />
            <UButton
              color="neutral"
              variant="outline"
              size="sm"
              @click="isOpenEdit = false"
              label="Abbrechen"
            />
          </div>
        </template>
      </UCard>
    </template>
  </UModal>
</template>
