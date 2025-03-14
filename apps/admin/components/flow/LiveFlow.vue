<script setup lang="ts">
import type { Node, Edge } from "@vue-flow/core"
import { VueFlow, useVueFlow } from "@vue-flow/core"
import { Background } from "@vue-flow/background"
import { Controls } from "@vue-flow/controls"
import { MiniMap } from "@vue-flow/minimap"
import TournamentMatchNode from "./TournamentMatchNode.vue"

// Import Vue Flow styles
import "@vue-flow/core/dist/style.css"
import "@vue-flow/core/dist/theme-default.css"
import "@vue-flow/controls/dist/style.css"
import "@vue-flow/minimap/dist/style.css"

// Sample tournament data
const tournamentData = {
  groups: [
    {
      name: "Group A",
      teams: ["Team Alpha", "Team Beta", "Team Gamma", "Team Delta"],
    },
    {
      name: "Group B",
      teams: ["Team Epsilon", "Team Zeta", "Team Eta", "Team Theta"],
    },
  ],
  // Sample match results
  results: {
    // Group stage winners
    groupWinners: {
      "Group A": ["Team Alpha", "Team Beta"],
      "Group B": ["Team Epsilon", "Team Zeta"],
    },
    // Quarterfinals
    quarterfinals: {
      qf1: { teams: ["Team Alpha", "Team Zeta"], winner: "Team Alpha" },
      qf2: { teams: ["Team Beta", "Team Epsilon"], winner: "Team Epsilon" },
    },
    // Semifinals
    semifinals: {
      sf1: { teams: ["Team Alpha", "Team Epsilon"], winner: "Team Alpha" },
    },
    // Final
    final: {
      teams: ["Team Alpha", "Pending"],
      winner: null,
    },
  },
}

// Generate nodes for the tournament flow
const generateNodes = () => {
  const nodes: Node[] = []
  const spacing = 200
  const groupSpacing = 150

  // Group stage nodes
  tournamentData.groups.forEach((group, groupIndex) => {
    // Group container node
    nodes.push({
      id: `group-${groupIndex}`,
      type: "tournamentMatch",
      data: {
        label: group.name,
        teams: group.teams,
        nodeType: "group",
        winner: "a",
      },
      position: { x: 0, y: groupIndex * groupSpacing },
    })
  })

  // Quarterfinal nodes
  Object.entries(tournamentData.results.quarterfinals).forEach(
    ([id, match], index) => {
      nodes.push({
        id,
        type: "tournamentMatch",
        data: {
          label: `Quarterfinal ${index + 1}`,
          teams: match.teams,
          nodeType: "quarterfinal",
          winner: match.winner,
        },
        position: { x: spacing, y: index * groupSpacing },
      })
    },
  )

  // Semifinal nodes
  Object.entries(tournamentData.results.semifinals).forEach(
    ([id, match], index) => {
      nodes.push({
        id,
        type: "tournamentMatch",
        data: {
          label: `Semifinal ${index + 1}`,
          teams: match.teams,
          nodeType: "semifinal",
          winner: match.winner,
        },
        position: {
          x: spacing * 2,
          y: index * groupSpacing + groupSpacing / 2,
        },
      })
    },
  )

  // Final node
  nodes.push({
    id: "final",
    type: "tournamentMatch",
    data: {
      label: "Final",
      teams: tournamentData.results.final.teams,
      nodeType: "final",
      winner: tournamentData.results.final.winner,
    },
    position: { x: spacing * 3, y: groupSpacing / 2 },
  })

  // Winner node (if there is a winner)
  if (tournamentData.results.final.winner) {
    nodes.push({
      id: "winner",
      type: "tournamentMatch",
      data: {
        label: "Tournament Winner",
        teams: [tournamentData.results.final.winner],
        nodeType: "winner",
      },
      position: { x: spacing * 4, y: groupSpacing / 2 },
    })
  }

  return nodes
}

// Generate edges for the tournament flow
const generateEdges = () => {
  const edges: Edge[] = []

  // Connect group nodes to quarterfinals
  edges.push(
    { id: "e-g0-qf1", source: "group-0", target: "qf1" },
    { id: "e-g1-qf1", source: "group-1", target: "qf1" },
    { id: "e-g0-qf2", source: "group-0", target: "qf2" },
    { id: "e-g1-qf2", source: "group-1", target: "qf2" },
  )

  // Connect quarterfinals to semifinals
  edges.push(
    { id: "e-qf1-sf1", source: "qf1", target: "sf1" },
    { id: "e-qf2-sf1", source: "qf2", target: "sf1" },
  )

  // Connect semifinals to final
  edges.push({ id: "e-sf1-final", source: "sf1", target: "final" })

  // Connect final to winner (if there is a winner)
  if (tournamentData.results.final.winner) {
    edges.push({ id: "e-final-winner", source: "final", target: "winner" })
  }

  return edges
}

const nodes = ref<Node[]>(generateNodes())
const edges = ref<Edge[]>(generateEdges())
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

    <template #node-tournamentMatch="nodeProps">
      <TournamentMatchNode v-bind="nodeProps" />
    </template>
  </VueFlow>
</template>
