<script setup lang="ts">
import type { NodeProps } from "@vue-flow/core"
import { Position, Handle } from "@vue-flow/core"

defineProps<NodeProps>()
</script>

<template>
  <div
    class="relative h-full w-full rounded border border-blue-500/50 bg-blue-500/10 p-2.5"
  >
    <div
      class="mb-2.5 border-b border-blue-500/30 pb-1.5 text-center font-bold"
    >
      {{ data.label }}
    </div>
    <Handle type="source" :position="Position.Right" />
  </div>
</template>
