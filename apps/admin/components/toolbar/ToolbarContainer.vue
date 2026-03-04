<script setup lang="ts">
const { enabled, collapsed } = useAiAssistant()
</script>

<template>
  <div class="flex items-center gap-2">
    <slot />
    <UButton
      v-if="enabled"
      :variant="collapsed ? 'subtle' : 'soft'"
      color="tertiary"
      size="sm"
      square
      icon="i-heroicons-sparkles"
      :aria-label="
        collapsed ? 'AI-Assistent einblenden' : 'AI-Assistent ausblenden'
      "
      @click="collapsed = !collapsed"
    />
  </div>
</template>
