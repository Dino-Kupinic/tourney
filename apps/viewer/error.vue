<script setup lang="ts">
type ViewerError = {
  statusCode?: number
  message?: string
}

defineProps({
  error: Object as () => ViewerError,
})
</script>

<template>
  <div
    class="m-auto flex h-dvh max-w-[768px] flex-col items-center justify-between border-x border-dashed bg-gray-50 py-32 dark:border-gray-800 dark:bg-gray-900"
  >
    <div
      class="m-auto flex flex-col gap-3 rounded-md border border-gray-200 p-5 dark:border-gray-800"
    >
      <PageHeading>Oops! Ein Fehler ist aufgetreten</PageHeading>
      <div>
        <strong>Status</strong>
        <p>{{ error?.statusCode }}</p>
      </div>
      <div>
        <strong>Fehlermeldung</strong>
        <div
          class="h-40 w-80 rounded-md border-gray-200 bg-gray-50 p-2 dark:border-gray-800 dark:bg-gray-800"
        >
          <pre class="w-full overflow-auto text-sm text-wrap">
            {{ error?.message }}
          </pre>
        </div>
      </div>
      <UButton block to="/tournaments" size="lg" label="Zurück zu Turniere" />
    </div>
  </div>
</template>
