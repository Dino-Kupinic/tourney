<script lang="ts" setup>
const { title } = defineProps<{
  title: string
}>()

const titleUppercase = computed(() => title.toUpperCase())
</script>

<template>
  <header
    class="flex w-full justify-between rounded-t-md border-b border-gray-200 bg-white p-2 px-6 text-sm dark:border-gray-800 dark:bg-gray-900"
  >
    <HeaderTitle>
      {{ titleUppercase }}
    </HeaderTitle>
    <slot />
  </header>
</template>
