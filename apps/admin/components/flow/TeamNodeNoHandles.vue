<script setup lang="ts">
import type { NodeProps } from "@vue-flow/core"

defineProps<NodeProps>()
</script>

<template>
  <div class="team-node-no-handles">
    <div class="team-content">
      {{ data.teams[0] }}
    </div>
  </div>
</template>

<style scoped>
.team-node-no-handles {
  padding: 4px 8px;
  border-radius: 4px;
  background-color: white;
  border: 1px solid #e5e7eb;
  width: 150px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
  margin-bottom: 3px; /* Added margin to create additional spacing */
}

.team-content {
  font-size: 12px;
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>
