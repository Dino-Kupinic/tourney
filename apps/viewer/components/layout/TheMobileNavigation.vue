<script setup lang="ts">
const links = getNavLinks(true)
</script>

<template>
  <nav
    class="bottom-0 flex w-full justify-around border-t border-gray-200 dark:border-gray-800"
  >
    <div v-for="link in links">
      <NuxtLink :to="link.to" active-class="text-primary-500">
        <div class="flex flex-col items-center justify-center gap-1 p-2">
          <UIcon :name="link.icon ?? ''" class="h-5 w-5" />
          <p class="text text-wrap text-sm">{{ link.label }}</p>
        </div>
      </NuxtLink>
    </div>
  </nav>
</template>
