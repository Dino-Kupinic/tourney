<script setup lang="ts">
const content = ref("")
const supabase = useSupabaseClient()
const { data } = await supabase.storage.from("misc").download("news.md")
content.value = (await data?.text()) ?? ""
</script>

<template>
  <PageWrapper>
    <PageHeader title="Medien" description="Aktuelles und Galerie" />

    <div class="my-3">
      <ClientOnly>
        <MDC
          v-if="content"
          class="h-full w-full overflow-auto rounded-md bg-gray-100 p-3 sm:p-6 dark:bg-gray-900"
          :value="content"
        />
        <div v-else>
          <p class="p-3">Kein Inhalt</p>
        </div>
      </ClientOnly>
    </div>
  </PageWrapper>
</template>
