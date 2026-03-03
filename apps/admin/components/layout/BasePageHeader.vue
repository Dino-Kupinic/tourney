<script lang="ts" setup>
const { title } = defineProps<{
  title?: string
}>()

const titleUppercase = computed(() => title?.toUpperCase() || "")
</script>

<template>
  <header
    class="flex w-full items-center justify-between rounded-t-md border-b border-neutral-200 bg-white p-2 px-6 text-sm text-neutral-950 dark:border-neutral-800 dark:bg-neutral-900 dark:text-neutral-100"
  >
    <HeaderTitle v-if="titleUppercase !== ''">
      {{ titleUppercase }}
    </HeaderTitle>
    <slot />
  </header>
</template>
