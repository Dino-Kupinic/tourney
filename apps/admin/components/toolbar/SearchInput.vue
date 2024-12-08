<script setup lang="ts">
const model = defineModel<string>()
</script>

<template>
  <UInput
    v-model="model"
    icon="i-heroicons-magnifying-glass-20-solid"
    placeholder="Suchen..."
    size="xs"
  />
</template>
