<script setup lang="ts">
const links = getNavLinks()
</script>

<template>
  <div
    class="m-auto flex items-center gap-2 border border-neutral-200 bg-neutral-50 px-2 py-1 dark:border-neutral-800 dark:bg-neutral-900"
  >
    <nav class="flex items-center gap-1">
      <NuxtLink
        v-for="link in links"
        :key="link.label"
        :to="link.to"
        class="flex items-center gap-2 rounded-md px-3 py-2 text-sm font-medium text-neutral-600 transition-colors hover:bg-neutral-100 hover:text-neutral-900 dark:text-neutral-300 dark:hover:bg-neutral-800 dark:hover:text-white"
        active-class="bg-neutral-100 text-primary dark:bg-neutral-800"
      >
        <UIcon :name="link.icon ?? ''" class="h-4 w-4" />
        <span>{{ link.label }}</span>
      </NuxtLink>
    </nav>
    <SettingsButton size="sm" />
  </div>
</template>
