<script setup lang="ts">
import type { NodeProps } from "@vue-flow/core"
import { Position, Handle } from "@vue-flow/core"

defineProps<NodeProps>()
</script>

<template>
  <div class="tournament-match-node" :class="data.nodeType">
    <Handle type="target" :position="Position.Left" />
    <div class="match-content">
      <div class="match-title">{{ data.label }}</div>
      <div v-if="data.teams && data.teams.length > 0" class="teams-container">
        <div
          v-for="(team, index) in data.teams"
          :key="index"
          class="team-item"
          :class="{ winner: data.winner === team }"
        >
          {{ team }}
        </div>
      </div>
      <div v-else class="pending-match">Pending</div>
    </div>
    <Handle type="source" :position="Position.Right" />
  </div>
</template>

<style scoped>
.tournament-match-node {
  padding: 10px;
  border-radius: 5px;
  background-color: white;
  border: 1px solid #ddd;
  min-width: 180px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.match-content {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.match-title {
  font-weight: bold;
  text-align: center;
  padding-bottom: 5px;
  border-bottom: 1px solid #eee;
}

.teams-container {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.team-item {
  padding: 5px;
  border-radius: 3px;
  background-color: #f5f5f5;
}

.team-item.winner {
  background-color: rgba(16, 185, 129, 0.2);
  font-weight: bold;
}

.pending-match {
  text-align: center;
  color: #888;
  font-style: italic;
}

/* Node type styling */
.group {
  background-color: rgba(59, 130, 246, 0.1);
  border-color: rgba(59, 130, 246, 0.5);
}

.quarterfinal {
  background-color: rgba(139, 92, 246, 0.1);
  border-color: rgba(139, 92, 246, 0.5);
}

.semifinal {
  background-color: rgba(245, 158, 11, 0.1);
  border-color: rgba(245, 158, 11, 0.5);
}

.final {
  background-color: rgba(239, 68, 68, 0.1);
  border-color: rgba(239, 68, 68, 0.5);
}

.winner {
  background-color: rgba(16, 185, 129, 0.1);
  border-color: rgba(16, 185, 129, 0.5);
}
</style>
