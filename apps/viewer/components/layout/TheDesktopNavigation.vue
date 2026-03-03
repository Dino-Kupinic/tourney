<script setup lang="ts">
const links = getNavLinks()
</script>

<template>
  <div
    class="m-auto flex items-center gap-2 border border-gray-200 bg-gray-50 px-2 py-1 dark:border-gray-800 dark:bg-gray-900"
  >
    <nav class="flex items-center gap-1">
      <NuxtLink
        v-for="link in links"
        :key="link.label"
        :to="link.to"
        class="flex items-center gap-2 rounded-md px-3 py-2 text-sm font-medium text-gray-600 transition-colors hover:bg-gray-100 hover:text-gray-900 dark:text-gray-300 dark:hover:bg-gray-800 dark:hover:text-white"
        active-class="bg-gray-100 text-primary dark:bg-gray-800"
      >
        <UIcon :name="link.icon ?? ''" class="h-4 w-4" />
        <span>{{ link.label }}</span>
      </NuxtLink>
    </nav>
    <SettingsButton size="sm" />
  </div>
</template>
