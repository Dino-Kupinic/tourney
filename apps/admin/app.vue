<script setup lang="ts">
useHead({
  titleTemplate: "%s - tourney",
})
</script>

<template>
  <div>
    <NuxtLoadingIndicator />
    <NuxtRouteAnnouncer />
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>
  </div>
</template>
