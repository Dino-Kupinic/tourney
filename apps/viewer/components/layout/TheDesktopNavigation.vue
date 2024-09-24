<script setup lang="ts">
const links = getNavLinks()
</script>

<template>
  <UHorizontalNavigation
    :links="links"
    class="border-b border-gray-200 px-2 dark:border-gray-800"
  />
</template>
