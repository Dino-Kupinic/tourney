<script setup lang="ts">
const title = ref<string>("Dashboard")
useHead({
  title: () => title.value,
})
</script>

<template>
  <InConstruction />
</template>

<style scoped></style>
