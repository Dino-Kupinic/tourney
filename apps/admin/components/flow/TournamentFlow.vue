<script setup lang="ts">
import { type Node, type Edge, useVueFlow } from "@vue-flow/core"
import { VueFlow } from "@vue-flow/core"
import { Background } from "@vue-flow/background"
import { MiniMap } from "@vue-flow/minimap"
import { ControlButton, Controls } from "@vue-flow/controls"

// these are our nodes
const nodes = ref<Node[]>([
  // an input node, specified by using `type: 'input'`
  {
    id: "1",
    type: "input",
    position: { x: 250, y: 5 },
    // all nodes can have a data object containing any data you want to pass to the node
    // a label can property can be used for default nodes
    data: { label: "Node 1" },
  },

  // default node, you can omit `type: 'default'` as it's the fallback type
  {
    id: "2",
    position: { x: 100, y: 100 },
    data: { label: "Node 2" },
  },

  // An output node, specified by using `type: 'output'`
  {
    id: "3",
    type: "output",
    position: { x: 400, y: 200 },
    data: { label: "Node 3" },
  },

  // this is a custom node
  // we set it by using a custom type name we choose, in this example `special`
  // the name can be freely chosen, there are no restrictions as long as it's a string
  {
    id: "4",
    type: "special", // <-- this is the custom node type name
    position: { x: 400, y: 200 },
    data: {
      label: "Node 4",
      hello: "world",
    },
  },
])

// these are our edges
const edges = ref<Edge[]>([
  // default bezier edge
  // consists of an edge id, source node id and target node id
  {
    id: "e1->2",
    source: "1",
    target: "2",
  },

  // set `animated: true` to create an animated edge path
  {
    id: "e2->3",
    source: "2",
    target: "3",
    animated: true,
  },

  // a custom edge, specified by using a custom type name
  // we choose `type: 'special'` for this example
  {
    id: "e3->4",
    type: "special",
    source: "3",
    target: "4",

    // all edges can have a data object containing any data you want to pass to the edge
    data: {
      hello: "world",
    },
  },
])

const { onInit, onNodeDragStop, onConnect, addEdges, setViewport, toObject } =
  useVueFlow()
</script>

<template>
  <VueFlow
    :nodes="nodes"
    :edges="edges"
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
