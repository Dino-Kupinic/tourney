<script setup lang="ts">
useHead({
  titleTemplate: "%s - tourney",
})

const route = useRoute()
const device = useDevice()

// dynamically change layout
const layout = computed(() => {
  if (route.path === "/") {
    return "home"
  }

  return device.isMobile ? "default" : "desktop"
})
</script>

<template>
  <div>
    <NuxtRouteAnnouncer />
    <NuxtLoadingIndicator />
    <NuxtLayout :name="layout">
      <NuxtPage />
    </NuxtLayout>
  </div>
</template>
