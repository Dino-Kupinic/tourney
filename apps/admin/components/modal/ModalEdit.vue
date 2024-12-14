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
  width: `w-full ${modalWidth || defaultModalWidth}`,
}))
</script>

<template>
  <UModal v-model="isOpenEdit" :ui="modalUI">
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
        <strong> Editieren </strong>
      </template>

      <slot />

      <template #footer>
        <div class="flex items-center gap-2">
          <UButton
            variant="soft"
            size="xs"
            @click="$emit('edit')"
            label="Speichern"
          />
          <UButton
            color="gray"
            size="xs"
            @click="isOpenEdit = false"
            label="Abbrechen"
          />
        </div>
      </template>
    </UCard>
  </UModal>
</template>
