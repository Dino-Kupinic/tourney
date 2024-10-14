<script setup lang="ts">
import type { ButtonSize } from "#ui/types"

const { size = "lg" } = defineProps<{
  size: ButtonSize
}>()
</script>

<template>
  <UButton
    variant="solid"
    color="white"
    to="/settings"
    :size="size"
    square
    icon="i-heroicons-cog-8-tooth"
  />
</template>
