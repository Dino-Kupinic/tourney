<script setup lang="ts">
const links = getNavLinks()
</script>

<template>
  <div
    class="m-auto flex w-[1024px] items-center border border-gray-200 bg-gray-50 px-2 2xl:w-[1366px] dark:border-gray-800 dark:bg-gray-900"
  >
    <UHorizontalNavigation :links="links" />
    <SettingsButton size="sm" />
  </div>
</template>
