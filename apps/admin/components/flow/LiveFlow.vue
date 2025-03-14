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

const { tournamentId } = defineProps<{
  tournamentId: string
}>()

// Fetch tournament data by phases
const {
  data: tournamentData,
  status,
  error,
} = await useFetch(`/api/tournaments/${tournamentId}/phases`)

// Generate nodes for the tournament flow
const generateNodes = () => {
  if (!tournamentData.value) return []

  const nodes: Node[] = []
  const spacing = 200
  const groupSpacing = 150

  // Group stage nodes
  tournamentData.value.groups.forEach((group, groupIndex) => {
    // Group container node
    nodes.push({
      id: `group-${groupIndex}`,
      type: "tournamentMatch",
      data: {
        label: group.name,
        teams: group.teams,
        nodeType: "group",
      },
      position: { x: 0, y: groupIndex * groupSpacing },
    })
  })

  // Quarterfinal nodes
  Object.entries(tournamentData.value.results.quarterfinals).forEach(
    ([id, match], index) => {
      nodes.push({
        id,
        type: "tournamentMatch",
        data: {
          label: `Viertelfinale ${index + 1}`,
          teams: match.teams,
          nodeType: "quarterfinal",
          winner: match.winner,
        },
        position: { x: spacing, y: index * groupSpacing },
      })
    },
  )

  // Semifinal nodes
  Object.entries(tournamentData.value.results.semifinals).forEach(
    ([id, match], index) => {
      nodes.push({
        id,
        type: "tournamentMatch",
        data: {
          label: `Semifinale ${index + 1}`,
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
      label: "Finale",
      teams: tournamentData.value.results.final.teams,
      nodeType: "final",
      winner: tournamentData.value.results.final.winner,
    },
    position: { x: spacing * 3, y: groupSpacing / 2 },
  })

  // Winner node (if there is a winner)
  if (tournamentData.value.results.final.winner) {
    nodes.push({
      id: "winner",
      type: "tournamentMatch",
      data: {
        label: "Turniersieger",
        teams: [tournamentData.value.results.final.winner],
        nodeType: "winner",
      },
      position: { x: spacing * 4, y: groupSpacing / 2 },
    })
  }

  return nodes
}

// Generate edges for the tournament flow
const generateEdges = () => {
  if (!tournamentData.value) return []

  const edges: Edge[] = []

  // Connect group nodes to quarterfinals
  const groupCount = tournamentData.value.groups.length
  const qfCount = Object.keys(tournamentData.value.results.quarterfinals).length

  if (groupCount > 0 && qfCount > 0) {
    // Create connections from groups to quarterfinals
    tournamentData.value.groups.forEach((_, groupIndex) => {
      Object.keys(tournamentData.value.results.quarterfinals).forEach(
        (qfId) => {
          edges.push({
            id: `e-g${groupIndex}-${qfId}`,
            source: `group-${groupIndex}`,
            target: qfId,
          })
        },
      )
    })
  }

  // Connect quarterfinals to semifinals
  Object.keys(tournamentData.value.results.quarterfinals).forEach((qfId) => {
    Object.keys(tournamentData.value.results.semifinals).forEach((sfId) => {
      edges.push({
        id: `e-${qfId}-${sfId}`,
        source: qfId,
        target: sfId,
      })
    })
  })

  // Connect semifinals to final
  Object.keys(tournamentData.value.results.semifinals).forEach((sfId) => {
    edges.push({ id: `e-${sfId}-final`, source: sfId, target: "final" })
  })

  // Connect final to winner (if there is a winner)
  if (tournamentData.value.results.final.winner) {
    edges.push({ id: "e-final-winner", source: "final", target: "winner" })
  }

  return edges
}

// Create reactive nodes and edges that update when tournament data changes
const nodes = computed<Node[]>(() => generateNodes())
const edges = computed<Edge[]>(() => generateEdges())

// Loading state for the flow visualization
const isLoading = computed(() => status.value === "pending")
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
