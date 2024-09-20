<script setup lang="ts">
const route = useRoute()
</script>

<template>
  <div class="flex h-full w-full items-center justify-center">
    <div>
      <div class="max-w-96 space-y-3">
        <UIcon
          name="i-heroicons-wrench"
          size="32"
          class="text-gray-500 dark:text-gray-400"
        />
        <p class="text-base font-semibold tracking-tight">In Arbeit</p>
        <p class="text-sm text-gray-700 dark:text-gray-500">
          Diese Seite befindet sich derzeit in Arbeit und wird in Kürze
          verfügbar sein. Wir bitten um etwas Geduld.
        </p>
        <p class="text-sm text-gray-700 dark:text-gray-500">
          In der Zwischenzeit können Sie die anderen Funktionen von tourney
          benutzen.
        </p>
        <pre class="text-right text-xs">Route: `{{ route.path }}`</pre>
      </div>
    </div>
  </div>
</template>
