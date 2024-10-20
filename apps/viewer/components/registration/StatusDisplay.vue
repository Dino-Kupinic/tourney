<script setup lang="ts">
defineProps<{
  status: string
}>()
</script>

<template>
  <UBadge
    size="md"
    v-if="status === 'Ausstehend'"
    :label="status"
    color="yellow"
    variant="subtle"
  />
  <UBadge
    size="md"
    v-else-if="status === 'Abgesendet'"
    :label="status"
    color="orange"
    variant="subtle"
  />
  <UBadge
    size="md"
    v-else-if="status === 'Abgeschlossen'"
    :label="status"
    color="green"
    variant="subtle"
  />
  <UBadge size="md" v-else :label="status" color="red" variant="subtle" />
</template>
