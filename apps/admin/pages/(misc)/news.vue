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

const supabase = useSupabaseClient()
const { data } = await supabase.storage.from("misc").download("news.md")
content.value = (await data?.text()) ?? ""
async function refresh() {
  const { data, error } = await supabase.storage
    .from("misc")
    .download("news.md")
  content.value = (await data?.text()) ?? ""
  if (error) {
    throw createError({
      statusCode: 500,
      message: error.message,
    })
  } else {
    displaySuccessNotification(
      "Inhalt aktualisiert",
      "Der Inhalt wurde erfolgreich aktualisiert.",
    )
  }
}

async function saveContent() {
  const { error } = await supabase.storage
    .from("misc")
    .upload("news.md", content.value, { upsert: true })
  if (error) {
    throw createError({
      statusCode: 500,
      message: error.message,
    })
  } else {
    displaySuccessNotification(
      "Änderungen gespeichert",
      "Die Änderungen wurden erfolgreich gespeichert.",
    )
  }
}
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
        icon="i-heroicons-arrow-path"
        color="gray"
        size="xs"
        square
        @click="refresh"
      />
      <UButton
        label="Änderungen speichern"
        variant="soft"
        size="xs"
        icon="i-heroicons-check"
        @click="saveContent"
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
          v-if="content"
          class="h-full w-full overflow-auto bg-gray-100 p-3 pb-16 dark:bg-gray-800"
          :value="content"
        />
        <div v-else>
          <p class="p-3">Kein Inhalt</p>
        </div>
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
