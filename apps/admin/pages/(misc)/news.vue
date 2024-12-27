<script setup lang="ts">
const title = ref<string>("Aktuelles")
useHead({
  title: () => title.value,
})
const content = ref("")
const mode = useColorMode()
const theme = computed(() => {
  return mode.value === "dark" ? "vs-dark" : "vs-light"
})
</script>

<template>
  <BasePageHeader :title="title">
    <ToolbarContainer>
      <UButton
        label="Markdown Syntax"
        color="gray"
        size="xs"
        to="https://www.markdownguide.org/cheat-sheet/"
        target="_blank"
        rel="noopener noreferrer"
        icon="i-heroicons-arrow-top-right-on-square"
      />
      <UButton
        label="Änderungen speichern"
        variant="soft"
        size="xs"
        icon="i-heroicons-check"
      />
    </ToolbarContainer>
  </BasePageHeader>
  <ClientOnly>
    <div class="flex h-full w-full">
      <MonacoEditor
        v-model="content"
        lang="markdown"
        class="h-full w-3/5 border-r border-gray-200 dark:border-gray-700"
        :options="{ theme: theme }"
      />
      <div class="h-full w-2/5">
        <MDC
          class="h-full w-full overflow-auto bg-gray-100 p-3 pb-16 dark:bg-gray-800"
          :value="content"
        />
      </div>
    </div>
    <template #fallback>
      <div
        class="flex h-full w-full items-center justify-center bg-gray-100 dark:bg-gray-900"
      >
        <UIcon name="i-svg-spinners-180-ring-with-bg" size="24" />
      </div>
    </template>
  </ClientOnly>
</template>
