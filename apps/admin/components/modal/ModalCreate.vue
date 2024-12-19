<script setup lang="ts">
const isOpenCreate = defineModel<boolean>()
const { title, modalWidth } = defineProps<{
  title: string
  modalWidth?: string
}>()

defineEmits<{
  create: () => void
}>()

const defaultModalWidth = "sm:max-w-xl"
const modalUI = computed(() => ({
  width: `w-full ${modalWidth || defaultModalWidth}`,
}))
</script>

<template>
  <UModal v-model="isOpenCreate" :ui="modalUI">
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
        <strong> {{ title }} </strong>
      </template>

      <slot />

      <template #footer>
        <div class="flex items-center gap-2">
          <UButton
            variant="soft"
            size="xs"
            @click="$emit('create')"
            label="Erstellen"
          />
          <UButton
            color="gray"
            size="xs"
            @click="isOpenCreate = false"
            label="Abbrechen"
          />
        </div>
      </template>
    </UCard>
  </UModal>
</template>
