<script setup lang="ts">
const route = useRoute()
const uuid = route.params

const { data: tournament } = await useFetch(`/api/tournament/${uuid}`)

// definePageMeta({
//   name: tournament.value.name,
// })
</script>

<template>
  <p>{{ tournament }}</p>
</template>

<style scoped></style>
