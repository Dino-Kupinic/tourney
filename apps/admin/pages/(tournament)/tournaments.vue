<script setup lang="ts">
const title = ref<string>("Turniere")
useHead({
  title: () => title.value,
})
</script>

<template>
  <BasePageHeader :title="title">
    <ToolbarContainer>
      <SearchInput />

      <UButton size="xs" variant="soft" label="Neues Turnier..." />
    </ToolbarContainer>
  </BasePageHeader>
  <BasePageContent>
    <UTable
      :loading-state="{
        icon: 'i-heroicons-arrow-path-20-solid',
        label: 'Lade...',
      }"
      class="h-full w-full bg-white dark:bg-gray-900"
      :ui="{
        wrapper: 'relative overflow-auto',
        th: {
          padding: 'px-4 py-3',
        },
        td: { base: 'max-w-[0] truncate', padding: 'py-2' },
      }"
    />
  </BasePageContent>
</template>
