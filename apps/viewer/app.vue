<script setup lang="ts">
useHead({
  titleTemplate: "%s - tourney",
})
</script>

<template>
  <div>
    <NuxtRouteAnnouncer />
    <NuxtLayout :name="$device.isMobile ? 'default' : 'desktop'">
      <NuxtPage />
    </NuxtLayout>
  </div>
</template>
