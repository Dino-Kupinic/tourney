<script setup lang="ts">
const links = getNavLinks()
</script>

<template>
  <div
    class="m-auto flex w-[1024px] items-center justify-between border border-gray-200 bg-gray-50 px-2 px-6 2xl:w-[1366px] dark:border-gray-800 dark:bg-gray-900"
  >
    <Logo class="h-9 w-9" />
    <div>
      <UHorizontalNavigation :links="links" />
    </div>
    <SettingsButton size="sm" />
  </div>
</template>
