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
    color="warning"
    variant="subtle"
  />
  <UBadge
    size="md"
    v-else-if="status === 'Abgesendet'"
    :label="status"
    color="warning"
    variant="subtle"
  />
  <UBadge
    size="md"
    v-else-if="status === 'Abgeschlossen'"
    :label="status"
    color="success"
    variant="subtle"
  />
  <UBadge size="md" v-else :label="status" color="error" variant="subtle" />
</template>
