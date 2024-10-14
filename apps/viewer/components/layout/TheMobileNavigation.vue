<script setup lang="ts">
const links = getNavLinks(true)
</script>

<template>
  <nav
    class="fixed bottom-0 flex h-16 w-full justify-around border-t border-gray-200 bg-gray-50 py-1 dark:border-gray-800 dark:bg-gray-900"
  >
    <div v-for="link in links">
      <NuxtLink :to="link.to" active-class="text-primary-500">
        <div class="flex flex-col items-center justify-center p-2 px-4">
          <UIcon :name="link.icon ?? ''" class="h-5 w-5" />
          <p class="text text-wrap text-sm font-medium">{{ link.label }}</p>
        </div>
      </NuxtLink>
    </div>
  </nav>
</template>
