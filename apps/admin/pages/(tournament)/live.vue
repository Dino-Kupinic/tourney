<script setup lang="ts">
const title = ref<string>("Live")
useHead({
  title: () => title.value,
})
</script>

<template>
  <BasePageHeader :title="title">a </BasePageHeader>

  <InConstruction />
</template>
