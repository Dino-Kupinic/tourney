<script setup lang="ts">
const links = getNavLinks(true)
</script>

<template>
  <nav
    class="fixed bottom-0 z-20 flex h-16 w-full justify-around border-t border-gray-200 bg-gray-50 bg-opacity-70 py-1 backdrop-blur-lg dark:border-gray-800 dark:bg-gray-900 dark:bg-opacity-70"
  >
    <div v-for="link in links" :key="link.label">
      <NuxtLink :to="link.to" active-class="text-primary-500">
        <div class="flex flex-col items-center justify-center p-2 px-4">
          <UIcon :name="link.icon ?? ''" class="h-5 w-5" />
          <p class="text text-wrap text-sm font-medium">{{ link.label }}</p>
        </div>
      </NuxtLink>
    </div>
  </nav>
</template>
