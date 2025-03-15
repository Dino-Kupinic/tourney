<script setup lang="ts">
import type { NodeProps } from "@vue-flow/core"
import { Position, Handle } from "@vue-flow/core"

defineProps<NodeProps>()
</script>

<template>
  <div class="group-node">
    <div class="group-title">{{ data.label }}</div>
    <Handle type="source" :position="Position.Right" />
  </div>
</template>

<style scoped>
.group-node {
  padding: 10px;
  border-radius: 5px;
  background-color: rgba(59, 130, 246, 0.1);
  border: 1px solid rgba(59, 130, 246, 0.5);
  width: 100%;
  height: 100%;
  position: relative;
}

.group-title {
  font-weight: bold;
  text-align: center;
  padding-bottom: 5px;
  border-bottom: 1px solid rgba(59, 130, 246, 0.3);
  margin-bottom: 10px;
}
</style>
