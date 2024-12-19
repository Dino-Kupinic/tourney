<script setup lang="ts">
import { type Node, type Edge, useVueFlow } from "@vue-flow/core"
import { VueFlow } from "@vue-flow/core"
import { Background } from "@vue-flow/background"
import { MiniMap } from "@vue-flow/minimap"
import { ControlButton, Controls } from "@vue-flow/controls"

const nodes = ref([
  {
    id: "1",
    type: "input",
    data: { label: "node" },
    position: { x: 250, y: 0 },
  },
  {
    id: "2",
    data: { label: "parent node" },
    position: { x: 100, y: 100 },
    style: {
      backgroundColor: "rgba(16, 185, 129, 0.5)",
      width: "200px",
      height: "200px",
    },
  },
  {
    id: "2a",
    data: { label: "child node" },
    position: { x: 10, y: 50 },
    parentNode: "2",
  },
  {
    id: "4",
    data: { label: "parent node" },
    position: { x: 320, y: 175 },
    style: {
      backgroundColor: "rgba(16, 185, 129, 0.5)",
      width: "400px",
      height: "300px",
    },
  },
  {
    id: "4a",
    data: { label: "child node" },
    position: { x: 15, y: 65 },
    extent: "parent",
    parentNode: "4",
  },
  {
    id: "4b",
    data: { label: "nested parent node" },
    position: { x: 15, y: 120 },
    style: {
      backgroundColor: "rgba(139, 92, 246, 0.5)",
      height: "150px",
      width: "270px",
    },
    parentNode: "4",
  },
  {
    id: "4b1",
    data: { label: "nested child node" },
    position: { x: 20, y: 40 },
    parentNode: "4b",
  },
  {
    id: "4b2",
    data: { label: "nested child node" },
    position: { x: 100, y: 100 },
    parentNode: "4b",
  },
  {
    id: "4c",
    data: { label: "child node" },
    position: { x: 200, y: 65 },
    parentNode: "4",
  },
  {
    id: "999",
    type: "input",
    data: { label: "Drag me to extend area!" },
    position: { x: 20, y: 100 },
    class: "light",
    expandParent: true,
    parentNode: "2",
  },
])
</script>

<template>
  <VueFlow
    :nodes="nodes"
    class="bg-gray-100 dark:bg-gray-800"
    :default-viewport="{ zoom: 1.5 }"
    :min-zoom="0.2"
    :max-zoom="4"
  >
    <Background pattern-color="#aaa" :gap="16" />
    <MiniMap pannable zoomable />
    <Controls position="top-left" />

    <!-- bind your custom node type to a component by using slots, slot names are always `node-<type>` -->
    <template #node-special="specialNodeProps">
      <SpecialNode v-bind="specialNodeProps" />
    </template>

    <!-- bind your custom edge type to a component by using slots, slot names are always `edge-<type>` -->
    <template #edge-special="specialEdgeProps">
      <SpecialEdge v-bind="specialEdgeProps" />
    </template>
  </VueFlow>
</template>

<style>
@import "@vue-flow/core/dist/style.css";
@import "@vue-flow/core/dist/theme-default.css";
@import "@vue-flow/controls/dist/style.css";
@import "@vue-flow/minimap/dist/style.css";
</style>
