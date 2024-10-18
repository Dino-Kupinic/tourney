<script setup lang="ts">
const route = useRoute()
const uuid = route.params

const { data: tournament } = useFetch(`/api/tournament/${uuid}`)
</script>

<template>
  <p>{{ tournament }}</p>
</template>

<style scoped></style>
