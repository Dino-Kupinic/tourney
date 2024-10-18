<script setup lang="ts">
const route = useRoute()
const uuid = route.params.id

const { data: registration } = useFetch(`/api/registrations/${uuid}`)
console.log(registration.value)
</script>

<template>
  <p>{{ registration }}</p>
</template>

<style scoped></style>
