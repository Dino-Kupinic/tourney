<script setup lang="ts">
import type { PropType } from "vue"

defineProps({
  href: {
    type: String,
    default: "",
  },
  target: {
    type: String as PropType<
      "_blank" | "_parent" | "_self" | "_top" | (string & {}) | null | undefined
    >,
    default: undefined,
    required: false,
  },
})
</script>

<template>
  <NuxtLink
    :href="href"
    :target="target"
    class="text-primary-500 underline-offset-4 hover:underline hover:decoration-0"
  >
    <slot />
  </NuxtLink>
</template>
