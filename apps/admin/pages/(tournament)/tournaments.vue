<script setup lang="ts">
const title = ref<string>("Turniere")
useHead({
  title: () => title.value,
})

const sortOptions = ["Sortiert nach Jahr", "Sortiert nach Sport"]
const selected = ref<string>(sortOptions[0])
</script>

<template>
  <BasePageHeader :title="title">
    <ToolbarContainer>
      <SearchInput />
      <USelectMenu
        v-model="selected"
        :options="sortOptions"
        size="xs"
        class="w-40"
      />
      <UButton square icon="i-ic-round-question-mark" size="xs" color="white" />
      <UButton size="xs" variant="soft" label="Neues Turnier..." />
    </ToolbarContainer>
  </BasePageHeader>
  <BasePageContent>
    <div class="h-full overflow-auto p-6">
      <div class="flex flex-col gap-3">
        <div>
          <UBadge label="2025" variant="subtle" size="md" />
        </div>
        <div class="grid grid-cols-[repeat(auto-fill,minmax(16rem,1fr))] gap-6">
          <div
            class="hover:border-primary-300 dark:hover:border-primary-700 h-96 rounded-md border border-gray-200 bg-gray-50 p-3 hover:shadow-[0_0px_40px_2px_rgba(29,78,216,0.1)] dark:border-gray-700 dark:bg-gray-900"
            v-for="x in 4"
          >
            a
          </div>
        </div>
      </div>
      <UDivider class="my-6" />
      <div class="flex flex-col gap-3">
        <div>
          <UBadge label="2024" variant="subtle" size="md" color="green" />
        </div>
        <div class="grid grid-cols-[repeat(auto-fill,minmax(16rem,1fr))] gap-6">
          <div
            class="hover:border-primary-300 dark:hover:border-primary-700 h-96 rounded-md border border-gray-200 bg-gray-50 p-3 hover:shadow-[0_0px_40px_2px_rgba(29,78,216,0.1)] dark:border-gray-700 dark:bg-gray-900"
            v-for="x in 4"
          >
            a
          </div>
        </div>
      </div>
    </div>
  </BasePageContent>
</template>
