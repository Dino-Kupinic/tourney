<script setup lang="ts">
import type { Node } from "@vue-flow/core"
import { VueFlow } from "@vue-flow/core"
import { Background } from "@vue-flow/background"
import { Controls } from "@vue-flow/controls"
import { MiniMap } from "@vue-flow/minimap"

// Define nodes for the tournament flow
const nodes = ref([
  { id: "5bhmbz", label: "5bhmbz", position: { x: 0, y: 0 } },
  { id: "4bhmbz", label: "4bhmbz", position: { x: 0, y: 100 } },
  { id: "4yhkuj", label: "4yhkuj", position: { x: 0, y: 200 } },
  { id: "1bhmbz", label: "1bhmbz", position: { x: 0, y: 300 } },
  { id: "2ahmbz", label: "2ahmbz", position: { x: 0, y: 400 } },
  { id: "2bhmbz", label: "2bhmbz", position: { x: 0, y: 500 } },
  { id: "2yhkuj", label: "2yhkuj", position: { x: 0, y: 600 } },
  { id: "1yhkug", label: "1yhkug", position: { x: 0, y: 700 } },
  { id: "qf1", label: "Quarter Final 1", position: { x: 300, y: 50 } },
  { id: "qf2", label: "Quarter Final 2", position: { x: 300, y: 250 } },
  { id: "qf3", label: "Quarter Final 3", position: { x: 300, y: 450 } },
  { id: "qf4", label: "Quarter Final 4", position: { x: 300, y: 650 } },
  { id: "sf1", label: "Semi Final 1", position: { x: 600, y: 150 } },
  { id: "sf2", label: "Semi Final 2", position: { x: 600, y: 550 } },
  { id: "final", label: "Final", position: { x: 900, y: 350 } },
  { id: "winner", label: "Winner", position: { x: 1200, y: 350 } },
])

// Define edges for the tournament flow
const edges = ref([
  { id: "e1", source: "5bhmbz", target: "qf1" },
  { id: "e2", source: "4bhmbz", target: "qf1" },
  { id: "e3", source: "4yhkuj", target: "qf2" },
  { id: "e4", source: "1bhmbz", target: "qf2" },
  { id: "e5", source: "2ahmbz", target: "qf3" },
  { id: "e6", source: "2bhmbz", target: "qf3" },
  { id: "e7", source: "2yhkuj", target: "qf4" },
  { id: "e8", source: "1yhkug", target: "qf4" },
  { id: "qf1-sf1", source: "qf1", target: "sf1" },
  { id: "qf2-sf1", source: "qf2", target: "sf1" },
  { id: "qf3-sf2", source: "qf3", target: "sf2" },
  { id: "qf4-sf2", source: "qf4", target: "sf2" },
  { id: "sf1-final", source: "sf1", target: "final" },
  { id: "sf2-final", source: "sf2", target: "final" },
  { id: "final-winner", source: "final", target: "winner" },
])
</script>

<template>
  <VueFlow
    class="bg-gray-100 dark:bg-gray-800"
    :default-viewport="{ zoom: 1.5 }"
    :min-zoom="0.2"
    :max-zoom="4"
  >
    <Background pattern-color="#aaa" :gap="16" />
    <MiniMap pannable zoomable />
    <Controls position="top-left" />
  </VueFlow>
</template>

<style scoped>
@import "@vue-flow/core/dist/style.css";
@import "@vue-flow/core/dist/theme-default.css";
@import "@vue-flow/controls/dist/style.css";
@import "@vue-flow/minimap/dist/style.css";
</style>
