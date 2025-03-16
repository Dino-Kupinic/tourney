<script setup lang="ts">
import type { NodeProps } from "@vue-flow/core"

defineProps<NodeProps>()
</script>

<template>
  <div
    class="w-[150px] rounded border border-gray-200 bg-white px-2 py-2 shadow-sm"
  >
    <div
      class="overflow-hidden text-ellipsis whitespace-nowrap text-center text-xs"
    >
      {{ data.teams[0] }}
    </div>
  </div>
</template>
