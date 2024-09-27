<script setup lang="ts">
const title = ref<string>("Turniere")
useHead({
  title: () => title.value,
})
</script>

<template>
  <BasePageHeader :title="title"> </BasePageHeader>
  <BasePageContent> <InConstruction /> </BasePageContent>
</template>
