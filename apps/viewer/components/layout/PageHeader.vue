<script setup lang="ts">
defineProps<{
  title: string
  description: string
}>()
</script>

<template>
  <div class="my-2">
    <PageTitle>{{ title }}</PageTitle>
    <PageDescription>{{ description }}</PageDescription>
  </div>
</template>
